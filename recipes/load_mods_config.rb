#
# Cookbook Name:: httpd
# Recipe:: load_mods_config
#

#
# All rights reserved - Do Not Redistribute
#

include_recipe 'httpd::default'

node['httpd']['mod_loads'].each do |mod|
  httpd_config "#{mod} conf" do
    config_name mod
    source 'mod_dummy.conf.erb'
    variables(
      mod_fullname: "#{mod}_module"
    )
    notifies :restart, 'httpd_service[default]', :delayed
    action :create
    not_if { File.exist?("#{node['httpd']['conf_mod_dir']}/#{mod}.conf") }
  end
end

log 'added mod configuration for specified mods'

# log 'added mod configs' do
#  message 'added mod configuration for specified mods'
#  notifies :restart, 'httpd_service[default]', :delayed
# end
