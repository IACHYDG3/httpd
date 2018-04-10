#
# Cookbook Name:: httpd
# Recipe:: configure_symlinks
#
# Copyright 2017, GEHC
#
# All rights reserved - Do Not Redistribute
#

%W(
  #{node['httpd']['app_dir']}
  #{node['httpd']['log_dir']}
  #{node['httpd']['webroot_dir']}
).each do |path|
  directory path do
    mode '0755'
    owner node['httpd']['user']
    group node['httpd']['group']
    recursive true
  end
end

# symlink app folder
link "#{node['httpd']['app_dir']}/httpd" do
  to node['httpd']['dir']
  not_if "test -L #{node['httpd']['app_dir']}/httpd"
  owner node['httpd']['user']
  group node['httpd']['group']
end

# symlink log_dir
link "#{node['httpd']['log_dir']}/httpd" do
  to '/var/log/httpd-default'
  not_if "test -L #{node['httpd']['log_dir']}/httpd"
  owner node['httpd']['user']
  group node['httpd']['group']
end

# symlink webroot_dir
link "#{node['httpd']['webroot_dir']}/httpd/htdocs" do
  to '/var/www/html'
  not_if "test -L #{node['httpd']['webroot_dir']}/httpd/htdocs"
  owner node['httpd']['user']
  group node['httpd']['group']
end
