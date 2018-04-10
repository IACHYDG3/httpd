#
# Cookbook Name:: httpd
# Attributes:: default
#
#
# All rights reserved - Do Not Redistribute
#

default['httpd']['user']           = 'jeeadm'
default['httpd']['uid']            = 501_967_086
default['httpd']['group']          = 'jeeadm'
default['httpd']['gid']            = 501_967_086

default['httpd']['module_dir']     = '/usr/lib64/httpd/modules'
default['httpd']['conf_dir']       = '/etc/httpd-default/conf.d'

default['httpd']['conf_mod_dir'] = case node['platform_version'].to_i
                                      when 6
                                        '/etc/httpd-default/conf.d'
                                      else
                                        '/etc/httpd-default/conf.modules.d'
                                      end

default['httpd']['app_dir']      = '/apps/jeeapp'
default['httpd']['log_dir']      = '/logs/jeeapp'
default['httpd']['webroot_dir']  = node['httpd']['app_dir']
default['httpd']['dir']          = '/etc/httpd-default'
default['httpd']['docroot_dir']  = '/var/www/html'

default['httpd']['mod_loads'] = %w(
  proxy rewrite proxy_ajp proxy_balancer proxy_connect cache dir proxy_ftp
  proxy_http headers ssl
)
