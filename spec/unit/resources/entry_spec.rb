# frozen_string_literal: true

require 'spec_helper'

describe 'control_groups_entry' do
  step_into :control_groups_entry
  platform 'ubuntu', '24.04'

  context 'when creating an entry' do
    recipe do
      control_groups_entry 'limited' do
        cpu('cpu.max' => '10000 100000')
        memory('memory.max' => '1048576')
        perm_task_uid 'root'
        extra_config('notify_on_release' => '1')
      end
    end

    it { is_expected.to install_package('cgroup-tools') }
    it { is_expected.to render_file('/etc/cgconfig.conf').with_content(/group limited \{/) }
    it { is_expected.to render_file('/etc/cgconfig.conf').with_content(/cpu.max = 10000 100000;/) }
    it { is_expected.to render_file('/etc/cgconfig.conf').with_content(/memory.max = 1048576;/) }
    it { is_expected.to render_file('/etc/cgconfig.conf').with_content(/notify_on_release = 1;/) }
    it { is_expected.to render_file('/etc/cgconfig.conf').with_content(/uid = root;/) }
  end

  context 'when deleting an entry' do
    recipe do
      control_groups_entry 'limited' do
        action :delete
      end
    end

    it { is_expected.to create_file('/etc/cgconfig.conf') }
    it { expect(chef_run).to_not render_file('/etc/cgconfig.conf').with_content(/group limited \{/) }
  end
end
