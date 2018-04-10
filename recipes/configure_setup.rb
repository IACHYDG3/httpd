#
# Cookbook Name:: httpd
# Recipe:: configure_setup.rb
#
#
# All rights reserved - Do Not Redistribute
#

group node['httpd']['group'] do
  gid node['httpd']['gid']
  action :create
end

user node['httpd']['user'] do
  uid node['httpd']['uid']
  gid node['httpd']['group']
  shell '/bin/bash'
  home "/home/#{node['httpd']['user']}"
  manage_home true
  system true
  action :create
end
