
# Cookbook Name:: httpd
# Recipe:: default

#
# All rights reserved - Do Not Redistribute
#

unless node['jeeadm_accts'] # this attribute is NOT put in any attributes file
  service 'sssd' do
    action :stop
    only_if 'chkconfig sssd'
  end

  include_recipe 'httpd::configure_setup' # or directly code user and group resources

  service 'sssd' do
    action :start
    only_if 'chkconfig sssd'
  end

  ruby_block 'jeeadm_accts_attrib_set' do
    block do
      node.normal['jeeadm_accts'] = true
      node.save
    end
  end
end

httpd_service 'default' do
  run_group node['httpd']['group']
  run_user node['httpd']['user']
  action [:create, :start]
end

include_recipe 'httpd::load_mods'

httpd_config 'default' do
  source 'site.conf.erb'
  notifies :restart, 'httpd_service[default]', :delayed
  not_if { File.exist?('/etc/httpd-default/conf.d/default.conf') }
end

file "#{node['httpd']['docroot_dir']}/index.html" do
  content 'hello there\n'
  action :create_if_missing
  notifies :restart, 'httpd_service[default]', :delayed
end

# include_recipe 'httpd::mod_jk'
include_recipe 'httpd::configure_symlinks'
include_recipe 'httpd::load_mods_config'
include_recipe 'httpd::deploy_scripts'
include_recipe 'logrotate::default'

logrotate_app 'httpd-default-app' do
  path "#{node['httpd']['log_dir']}/httpd/*log"
  frequency 'daily'
  rotate 60
  create '644 root root'
  postrotate '/sbin/service httpd-default reload > /dev/nul 2>/dev/null || true'
  sharedscripts true
  options %w(missingok delaycompress notifempty)
end

file '/etc/httpd/conf/WARNING_README' do
  action :create
  owner 'root'
  group 'root'
  mode '0644'
  content "  You do not want to be here.
  Configurations should be done only under #{node['httpd']['conf_dir']}.
  Any changes here will have no or only temporary effect.
  "
end

# open iptables slot
iptables_rule 'httpd' do
  lines '-I INPUT 1 -p tcp --dport 80 -j ACCEPT'
end
