
# Cookbook Name:: httpd
# Recipe:: deploy_scripts
#

#
# All rights reserved - Do Not Redistribute
#

dir = node['httpd']['dir']

log 'copy startup and shutdown scripts..'

start_script = "#{dir}/startup.sh"
shutdown_script = "#{dir}/shutdown.sh"

template start_script do
  source 'startup.sh.erb'
  mode '0755'
  action :create
  not_if { File.exist? start_script }
end

template shutdown_script do
  source 'shutdown.sh.erb'
  mode '0755'
  action :create
  not_if { File.exist? shutdown_script }
end
