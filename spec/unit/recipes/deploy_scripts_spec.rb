# Cookbook Name::  httpd
# Unit test of Recipe:: deploy_scripts

require 'spec_helper'

describe 'httpd::deploy_scripts' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'oracle', version: '6.6') do |node|
      node.normal['httpd']['dir'] = 'dir'
    end.converge(described_recipe)
  end

  it "writes 'copy startup and shutdown scripts..'" do
    expect(chef_run).to write_log('copy startup and shutdown scripts..')
  end

  it 'creates template startup.sh' do
    expect(chef_run).to create_template('dir/startup.sh').with(
      source: 'startup.sh.erb',
      mode: '0755'
    )
  end

  it 'creates template shutdown.sh' do
    expect(chef_run).to create_template('dir/shutdown.sh').with(
      source: 'shutdown.sh.erb',
      mode: '0755'
    )
  end
end
