# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../libraries/control_groups' unless defined?(ControlGroups::DEFAULT_MOUNTS)

describe ControlGroups do
  describe '.build_target' do
    it 'builds a target with a command' do
      expect(described_class.build_target('alice', 'stress-ng')).to eq('alice:stress-ng')
    end

    it 'builds a target without a command' do
      expect(described_class.build_target('alice')).to eq('alice')
    end
  end

  describe '.build_rules' do
    let(:rules) do
      Mash.new(
        'alice:stress-ng' => {
          controllers: %w(cpu memory),
          destination: 'limited',
        }
      )
    end

    let(:structure) do
      Mash.new(
        'limited' => {
          'cpu' => { 'cpu.max' => '10000 100000' },
          'memory' => { 'memory.max' => '1048576' },
        }
      )
    end

    it 'renders the rules file' do
      expect(described_class.build_rules(rules, structure)).to eq("# This file created by Chef!\nalice:stress-ng\tcpu,memory\tlimited\n")
    end

    it 'raises for an invalid destination' do
      expect do
        described_class.build_rules(rules, Mash.new)
      end.to raise_error(RuntimeError, /Invalid destination/)
    end
  end
end
