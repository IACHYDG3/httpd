# Cookbook Name::  httpd
# Unit test of Recipe:: mod_auth_openidc

require 'spec_helper'

describe 'httpd::mod_auth_openidc' do
  context 'CentOS 7 positive' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(file_cache_path: 'File_cache_path', platform: 'centos', version: '7.0') do |node|
        node.normal['httpd']['openidc']['openidc_url'] = 'http://not-real/'
      end.converge(described_recipe)
    end

    before do
      allow_any_instance_of(Chef::Recipe).to receive(:tagged?).and_return(false)
      allow_any_instance_of(Chef::Recipe).to receive(:tagged?).with('patch_now').and_return(false)
    end

    it 'tags that recipe is run' do
      resource1 = chef_run.ruby_block('tag_openidc')
      expect(resource1).to do_nothing
    end

    it 'include hc_yum recipe' do
      expect(chef_run).to include_recipe('hc_yum')
    end

    it "creates remote file ['httpd']['openidc']['package_name']" do
      expect(chef_run).to create_remote_file_if_missing('File_cache_path/mod_auth_openidc-1.8.10.1-1.el7.centos.x86_64.rpm').with(
        backup: false,
        source: 'http://not-real/'
      )
    end

    it 'installs rpm package mod_auth_openidc' do
      expect(chef_run).to install_rpm_package('mod_auth_openidc')
    end

    it 'creates httpd module auth_openidc' do
      expect(chef_run).to create_httpd_module('auth_openidc').with(
        package_name: 'mod_auth_openidc.x86_64'
      )
    end

    it "creates httpd config 'auth_openidc conf'" do
      expect(chef_run).to create_httpd_config('auth_openidc conf').with(
        config_name: 'auth_openidc',
        source: 'mod_auth_openidc.conf.erb'
      )
    end

    # notify?

    it 'httpd_service default does nothing' do
      expect(chef_run).to_not create_httpd_service('default')
    end

    %w(jansson hiredis).each do |pkg|
      it "installs package #{pkg}" do
        expect(chef_run).to install_package(pkg)
      end
    end

    it 'mod_auth_openidc rpm package name and version is correct' do
      expect(chef_run.node['httpd']['openidc']['package_name']).to eq('mod_auth_openidc-1.8.10.1-1.el7.centos.x86_64.rpm')
    end
  end

  context 'OEL 6 positive' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(file_cache_path: 'File_cache_path', platform: 'oracle', version: '6.6') do |node|
        node.normal['httpd']['openidc']['openidc_url'] = 'http://not-real/'
      end.converge(described_recipe)
    end

    before do
      allow_any_instance_of(Chef::Recipe).to receive(:tagged?).and_return(false)
      allow_any_instance_of(Chef::Recipe).to receive(:tagged?).with('patch_now').and_return(false)
    end

    it 'creates cookbook_file - hiredis rpm package' do
      expect(chef_run).to create_cookbook_file_if_missing('File_cache_path/hiredis-0.10.1-3.el6.x86_64.rpm')
    end

    it 'installs hiredis rpm package' do
      expect(chef_run).to install_rpm_package('hiredis')
    end

    it "creates remote file ['httpd']['openidc']['package_name']" do
      expect(chef_run).to create_remote_file_if_missing('File_cache_path/mod_auth_openidc-1.8.10.1-1.el6.x86_64.rpm').with(
        backup: false,
        source: 'http://not-real/'
      )
    end

    it 'mod_auth_openidc rpm package name and version is correct' do
      expect(chef_run.node['httpd']['openidc']['package_name']).to eq('mod_auth_openidc-1.8.10.1-1.el6.x86_64.rpm')
    end
  end
end
