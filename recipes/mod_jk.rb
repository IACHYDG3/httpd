#
# Cookbook Name:: httpd
# Recipe:: mod_jk

# All rights reserved - Do Not Redistribute
#

tmp_path = Chef::Config['file_cache_path']

case node['platform_family']
when 'rhel'
  # #Install packages
  %w(httpd-devel gcc make).each do |pkg|
    package pkg do
      action :install
      not_if { ::File.exist?("#{node['httpd']['module_dir']}/mod_jk.so") }
    end
  end

  remote_file "#{tmp_path}/tomcat-connectors-#{node['httpd']['modjk']['version']}-src.tar.gz" do
    source "http://www.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-#{node['httpd']['modjk']['version']}-src.tar.gz"
    notifies :run, 'bash[Make the mod_jk from source]', :immediately
    action :create_if_missing
  end

  # -------------------makes mod_jk from source
  bash 'Make the mod_jk from source' do
    user 'root'
    cwd tmp_path
    code <<-EOH
    tar xvf tomcat-connectors-#{node['httpd']['modjk']['version']}-src.tar.gz
      cd tomcat-connectors-#{node['httpd']['modjk']['version']}-src/native
      which apxs
    export APXS_PATH="$(which apxs)"
    ./configure --with-apxs=$APXS_PATH
    make
    make install
    EOH
    not_if { ::File.exist?("#{node['httpd']['module_dir']}/mod_jk.so") }
  end

  template_name = "#{node['httpd']['conf_mod_dir']}/worker.properties"
  template template_name do
    source 'worker.properties.erb'
    mode '0644'
    not_if { File.exist? template_name }
  end

  httpd_module 'jk' do
    package_name 'vi'
  end

  file "#{node['httpd']['conf_dir']}/jk.conf" do
    content 'JkShmFile /var/run/httpd-default/mod_jk.shm'
    mode '0644'
    action :create_if_missing
    notifies :restart, 'httpd_service[default]', :delayed
  end
  # else
  # TODO: put other here
end
