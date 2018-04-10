# Cookbook Name::  httpd
# Unit test of Recipe:: mod_jk

require 'spec_helper'

describe 'httpd::mod_jk' do
  # mock rhel platform_family for example centos 7.0
  let(:chef_run) do
    ChefSpec::SoloRunner.new(file_cache_path: 'File_cache_path', platform: 'centos', version: '7.0') do |node|
      node.normal['httpd']['module_dir'] = 'module_dir'
      node.normal['httpd']['modjk']['version'] = 'VERSION'
      node.normal['httpd']['conf_mod_dir'] = 'conf_mod_dir'
    end.converge(described_recipe)
  end

  let(:remote_file) { chef_run.remote_file('File_cache_path/tomcat-connectors-VERSION-src.tar.gz') }

  before(:each) do
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with('module_dir/mod_jk.so').and_return(false)
  end

  %w(httpd-devel gcc make).each do |pkg|
    it "installs package #{pkg}" do
      expect(chef_run).to install_package(pkg)
    end
  end

  it 'creates remote file tomcat-connectors-[version]-src.tar.gz' do
    expect(chef_run).to create_remote_file_if_missing('File_cache_path/tomcat-connectors-VERSION-src.tar.gz').with(
      source: 'http://www.apache.org/dist/tomcat/tomcat-connectors/jk/tomcat-connectors-VERSION-src.tar.gz'
    )
  end

  it 'notifies bash "Make the mod_jk from source" immediately' do
    expect(remote_file).to notify('bash[Make the mod_jk from source]').immediately
  end

  it 'runs bash "Make the mod_jk from source"' do
    expect(chef_run).to run_bash('Make the mod_jk from source').with(
      user: 'root',
      cwd: 'File_cache_path'
    )
  end

  it 'creates worker.properties file from template' do
    expect(chef_run).to create_template('conf_mod_dir/worker.properties').with(
      source: 'worker.properties.erb',
      mode: '0644'
    )
  end

  it 'creates httpd_module jk' do
    expect(chef_run).to create_httpd_module('jk').with(package_name: 'vi')
  end
end
