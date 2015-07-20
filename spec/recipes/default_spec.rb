#
# Cookbook Name:: stow
# Spec:: default
#
# Copyright (c) 2015 Steven Haddox

require 'spec_helper'

describe 'stow::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    it 'creates stow src directory' do
      expect(chef_run).to create_directory('/usr/local/stow/src').with(
        user:  'root',
        group: 'root'
      )
    end

    it 'adds stow bin to $PATH' do
      expect(chef_run).to create_template('/etc/profile.d/stow.sh')
    end
  end

  context 'When running on CentOS 6' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'centos', version: '6.5')
      runner.converge(described_recipe)
    end

    it 'installs stow' do
      expect(chef_run).to install_package 'stow'
    end
  end

  context 'When running on Fedora 20' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'fedora', version: '20')
      runner.converge(described_recipe)
    end

    it 'installs stow' do
      expect(chef_run).to install_package 'stow'
    end
  end

  context 'When running on Ubuntu 14' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '14.04')
      runner.converge(described_recipe)
    end

    it 'installs stow' do
      expect(chef_run).to install_package 'stow'
    end
  end

  context 'When running on Debian 7' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'debian', version: '7.0')
      runner.converge(described_recipe)
    end

    it 'installs stow' do
      expect(chef_run).to install_package 'stow'
    end
  end

  context "When installing from source" do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'opensuse', version: '12.3')
      runner.converge(described_recipe)
    end

    it 'gets the latest stow' do
      expect(chef_run).to create_remote_file("/usr/local/stow/src/stow-2.2.0.tar.gz")
    end

    it 'installs stow from source' do
      expect(chef_run).to install_tar_package("file:////usr/local/stow/src/stow-2.2.0.tar.gz")
    end

    it 'stow_stow runs on clean install' do
      expect(chef_run).to run_execute('stow_stow')
    end

    it 'stow_stow is skipped if stow is up to date' do
      pending('todo')
      fail
      expect(chef_run).to_not run_execute('stow_stow')
    end

    it "destow_stow runs if an outdated package is in stow's path" do
      pending('todo')
      fail
      chef_run.node.set['stow']['current_version'] = nil
      chef_run.converge(described_recipe)
      expect(chef_run).to run_execute('destow_stow')
    end

    it "destow_stow is skipped if stow doesn't exist in stow's path" do
      pending('todo')
      fail
      chef_run.node.set['stow']['version'] = '2.2.0'
      chef_run.converge(described_recipe)
      expect(chef_run).to_not run_execute('destow_stow')
    end

    it "destow_stow is skipped if stow package is up to date" do
      pending('todo')
      fail
      chef_run.node.set['stow']['current_version'] = ''
      chef_run.converge(described_recipe)
      expect(chef_run).to_not run_execute('destow_stow')
    end
  end
end