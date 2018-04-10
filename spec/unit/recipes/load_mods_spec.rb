require 'spec_helper'

describe 'httpd::load_mods' do
  context 'default oracle 6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'oracle', version: '6.6') do |node|
        node.normal['httpd']['mod_loads'] = %w(mod1 mod2)
      end.converge(described_recipe)
    end

    %w(mod1 mod2).each do |mod|
      it "creates httpd_module for #{mod}" do
        expect(chef_run).to create_httpd_module(mod)
      end
    end

    it 'creates httpd_module slotmem_shm' do
      expect(chef_run).to_not create_httpd_module('slotmem_shm')
    end
  end
  context 'default centos 7' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0') do |node|
        node.normal['httpd']['mod_loads'] = %w(mod1 mod2)
      end.converge(described_recipe)
    end

    %w(mod1 mod2).each do |mod|
      it "creates httpd_module for #{mod}" do
        expect(chef_run).to create_httpd_module(mod)
      end
    end

    it 'creates httpd_module slotmem_shm' do
      expect(chef_run).to create_httpd_module('slotmem_shm')
    end
  end
end
