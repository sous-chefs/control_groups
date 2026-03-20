# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../libraries/helpers' unless defined?(ControlGroups::Helpers)

describe ControlGroups::Helpers do
  subject(:helper_object) do
    Class.new do
      include ControlGroups::Helpers

      attr_reader :node

      def initialize(platform_family)
        @node = { 'platform_family' => platform_family }
      end
    end.new(platform_family)
  end

  context 'when on debian' do
    let(:platform_family) { 'debian' }

    it 'returns the Debian package list' do
      expect(helper_object.control_group_packages).to eq(%w(cgroup-tools libcgroup2 libpam-cgroup))
    end
  end

  context 'when on amazon' do
    let(:platform_family) { 'amazon' }

    it 'returns the rpm package list' do
      expect(helper_object.control_group_packages).to eq(%w(libcgroup libcgroup-tools))
    end
  end
end
