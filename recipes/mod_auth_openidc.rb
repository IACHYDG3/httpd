#
# Cookbook Name:: httpd
# Recipe:: mod_auth_openidc
#
# All rights reserved - Do Not Redistribute
#

if tagged?('openidc')
  log 'openidc already installed' if node['DEBUG']
else
  tagger = method(:tag)

  ruby_block 'tag_openidc' do
    block do
      tagger.call 'openidc'
      node.save
    end
    action :nothing
  end

  tmp_path = Chef::Config['file_cache_path']

  include_recipe 'hc_yum'
  package 'jansson'

  if platform_family?('rhel') && node['platform_version'].to_i == 6
    hiredis_pkg = File.join(tmp_path, node['httpd']['openidc']['hiredis_pkg'])
    cookbook_file hiredis_pkg do
      source node['httpd']['openidc']['hiredis_pkg']
      action :create_if_missing
    end
    rpm_package 'hiredis' do
      source hiredis_pkg
    end
  else
    package 'hiredis'
  end

  mod_auth_openidc_pkg = File.join(tmp_path, node['httpd']['openidc']['package_name'])
  remote_file mod_auth_openidc_pkg do
    backup false
    source node['httpd']['openidc']['openidc_url']
    action :create_if_missing
  end
  rpm_package 'mod_auth_openidc' do
    source mod_auth_openidc_pkg
  end

  httpd_module 'auth_openidc' do
    package_name 'mod_auth_openidc.x86_64'
  end

  httpd_config 'auth_openidc conf' do
    config_name 'auth_openidc'
    source 'mod_auth_openidc.conf.erb'
    action :create
    notifies :restart, 'httpd_service[default]', :delayed
    notifies :run, 'ruby_block[tag_openidc]', :immediately
    not_if { File.exist? "#{node['httpd']['conf_mod_dir']}/auth_openidc.conf" }
  end

  httpd_service 'default' do
    action :nothing
  end
end
