#
# Cookbook Name:: httpd
# Recipe:: load_mods
#

#
# All rights reserved - Do Not Redistribute
#

node['httpd']['mod_loads'].each do |mod|
  httpd_module mod do
    action :create
  end
end

httpd_module 'slotmem_shm' do
  action :create
  only_if { node['platform_version'].to_i == 7 }
end
