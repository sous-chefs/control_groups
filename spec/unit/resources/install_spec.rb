# frozen_string_literal: true

require 'spec_helper'

describe 'control_groups_install' do
  step_into :control_groups_install

  context 'on ubuntu 24.04' do
    platform 'ubuntu', '24.04'

    recipe do
      control_groups_install 'default'
    end

    it { is_expected.to install_package('cgroup-tools') }
    it { is_expected.to install_package('libcgroup2') }
    it { is_expected.to install_package('libpam-cgroup') }
    it { is_expected.to create_file('/etc/cgconfig.conf') }
    it { is_expected.to create_file('/etc/cgrules.conf') }
    it { is_expected.to create_systemd_unit('cgconfig.service') }
    it { is_expected.to enable_systemd_unit('cgconfig.service') }
    it { is_expected.to start_systemd_unit('cgconfig.service') }
    it { is_expected.to create_systemd_unit('cgred.service') }
    it { is_expected.to enable_systemd_unit('cgred.service') }
    it { is_expected.to start_systemd_unit('cgred.service') }
    it { is_expected.to render_file('/etc/cgconfig.conf').with_content(%r{mount \{\n  cpu = /sys/fs/cgroup/cpu;}) }
  end

  context 'action :remove' do
    platform 'ubuntu', '24.04'

    recipe do
      control_groups_install 'default' do
        action :remove
      end
    end

    it { is_expected.to stop_systemd_unit('cgconfig.service') }
    it { is_expected.to disable_systemd_unit('cgconfig.service') }
    it { is_expected.to delete_systemd_unit('cgconfig.service') }
    it { is_expected.to stop_systemd_unit('cgred.service') }
    it { is_expected.to disable_systemd_unit('cgred.service') }
    it { is_expected.to delete_systemd_unit('cgred.service') }
    it { is_expected.to delete_file('/etc/cgconfig.conf') }
    it { is_expected.to delete_file('/etc/cgrules.conf') }
    it { is_expected.to remove_package('cgroup-tools') }
    it { is_expected.to remove_package('libcgroup2') }
    it { is_expected.to remove_package('libpam-cgroup') }
  end

  context 'when runtime management is disabled' do
    platform 'ubuntu', '24.04'

    recipe do
      control_groups_install 'default' do
        manage_runtime false
      end
    end

    it { is_expected.to create_systemd_unit('cgconfig.service') }
    it { is_expected.to enable_systemd_unit('cgconfig.service') }
    it { expect(chef_run).to_not start_systemd_unit('cgconfig.service') }
    it { is_expected.to create_systemd_unit('cgred.service') }
    it { is_expected.to enable_systemd_unit('cgred.service') }
    it { expect(chef_run).to_not start_systemd_unit('cgred.service') }
  end
end
