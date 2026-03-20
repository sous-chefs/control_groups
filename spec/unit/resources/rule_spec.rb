# frozen_string_literal: true

require 'spec_helper'

describe 'control_groups_rule' do
  step_into :control_groups_entry, :control_groups_rule
  platform 'ubuntu', '24.04'

  context 'when creating a rule' do
    recipe do
      control_groups_entry 'limited' do
        cpu('cpu.max' => '10000 100000')
        memory('memory.max' => '1048576')
      end

      control_groups_rule 'alice' do
        command 'stress-ng'
        controllers %w(cpu memory)
        destination 'limited'
      end
    end

    it { is_expected.to create_file('/etc/cgrules.conf') }
    it { is_expected.to render_file('/etc/cgrules.conf').with_content(/alice:stress-ng\tcpu,memory\tlimited/) }
  end

  context 'when deleting a rule' do
    recipe do
      control_groups_entry 'limited' do
        cpu('cpu.max' => '10000 100000')
      end

      control_groups_rule 'alice' do
        command 'stress-ng'
        controllers ['cpu']
        destination 'limited'
        action :delete
      end
    end

    it { is_expected.to create_file('/etc/cgrules.conf') }
    it { expect(chef_run).to_not render_file('/etc/cgrules.conf').with_content(/alice:stress-ng/) }
  end
end
