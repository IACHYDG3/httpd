#
# Cookbook Name:: httpd
# Attributes:: mod_auth_openidc
#

#
# All rights reserved - Do Not Redistribute
#

default['httpd']['openidc']['OIDCProviderMetadataURL'] = 'https://fssfed.stage.ge.com/fss/.well-known/openid-configuration'
default['httpd']['openidc']['OIDCClientID']            = 'nil'
default['httpd']['openidc']['OIDCClientSecret']        = 'nil'
default['httpd']['openidc']['OIDCRedirectURI']         = 'https://mySamleApp.com/redirect_uri'
default['httpd']['openidc']['OIDCScope']               = '"nil"'
default['httpd']['openidc']['OIDCCryptoPassphrase']    = 'nil'
default['httpd']['openidc']['OIDCAuthNHeader']         = 'SM_USER'
default['httpd']['openidc']['OIDCRemoteUserClaim']     = 'sub'
default['httpd']['openidc']['OIDCClaimPrefix']         = 'ge_'
default['httpd']['openidc']['modauthversion']          = '1.8.10.1'

default['httpd']['openidc']['package_name'] = if node['platform_version'].to_i >= 7
                                                   "mod_auth_openidc-#{node['httpd']['openidc']['modauthversion']}-1.el7.centos.x86_64.rpm"
                                                 else
                                                   "mod_auth_openidc-#{node['httpd']['openidc']['modauthversion']}-1.el6.x86_64.rpm"
                                                 end

default['httpd']['openidc']['openidc_url'] = "https://github.com/pingidentity/mod_auth_openidc/releases/download/v#{node['httpd']['openidc']['modauthversion']}/#{node['httpd']['openidc']['package_name']}"

default['httpd']['openidc']['hiredis_pkg'] = 'hiredis-0.10.1-3.el6.x86_64.rpm'
