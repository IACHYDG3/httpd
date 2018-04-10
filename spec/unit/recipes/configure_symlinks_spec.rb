# Cookbook Name::  httpd
# Unit test of Recipe:: configure_symlinks

require 'spec_helper'

describe 'httpd::configure_symlinks' do
  before(:each) do
    stub_command('test -L app_dir/httpd').and_return(false)
    stub_command('test -L log_dir/httpd').and_return(false)
    stub_command('test -L webroot_dir/httpd/htdocs').and_return(false)
  end

  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'oracle', version: '6.6') do |node|
      node.normal['httpd']['group'] = 'httpd_group'
      node.normal['httpd']['user'] = 'httpd_user'
      node.normal['httpd']['app_dir'] = 'app_dir'
      node.normal['httpd']['log_dir'] = 'log_dir'
      node.normal['httpd']['webroot_dir'] = 'webroot_dir'
    end.converge(described_recipe)
  end

  %w(app_dir log_dir webroot_dir).each do |path|
    it "creates directory #{path}" do
      expect(chef_run).to create_directory(path).with(
        mode: '0755',
        owner: 'httpd_user',
        group: 'httpd_group',
        recursive: true
      )
    end
  end

  it "creates link ['httpd']['app_dir']}/httpd" do
    expect(chef_run).to create_link('app_dir/httpd').with(
      to: '/etc/httpd-default',
      owner: 'httpd_user',
      group: 'httpd_group'
    )
  end

  it "creates link ['httpd']['log_dir']}/httpd" do
    expect(chef_run).to create_link('log_dir/httpd').with(
      to: '/var/log/httpd-default',
      owner: 'httpd_user',
      group: 'httpd_group'
    )
  end

  it "['httpd']['webroot_dir']}/httpd/htdocs" do
    expect(chef_run).to create_link('webroot_dir/httpd/htdocs').with(
      to: '/var/www/html',
      owner: 'httpd_user',
      group: 'httpd_group'
    )
  end
end
