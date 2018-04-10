# Cookbook Name::  httpd
# Unit test of Recipe:: configure_setup

require 'spec_helper'

describe 'httpd::configure_setup' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'oracle', version: '6.6') do |node|
      node.normal['httpd']['group'] = 'httpd_group'
      node.normal['httpd']['user'] = 'httpd_user'
    end.converge(described_recipe)
  end

  it 'creates group for httpd' do
    expect(chef_run).to create_group('httpd_group')
  end

  it 'creates httpd user' do
    expect(chef_run).to create_user('httpd_user').with(
      shell: '/bin/bash',
      home: '/home/httpd_user',
      supports: { manage_home: true },
      system: true
    )
  end
end
