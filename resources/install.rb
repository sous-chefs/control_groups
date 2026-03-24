# frozen_string_literal: true

provides :control_groups_install
unified_mode true

use '_partial/_config'

default_action :install

action_class do
  include ControlGroups::Helpers
end

action :install do
  initialize_control_group_state(mounts: new_resource.mounts)
  ensure_control_group_base_resources(manage_runtime: new_resource.manage_runtime)
end

action :remove do
  systemd_unit 'cgred.service' do
    action %i(stop disable delete)
    ignore_failure true
  end

  systemd_unit 'cgconfig.service' do
    action %i(stop disable delete)
    ignore_failure true
  end

  file '/etc/cgrules.conf' do
    action :delete
  end

  file '/etc/cgconfig.conf' do
    action :delete
  end

  control_group_packages.each do |package_name|
    package package_name do
      action :remove
    end
  end
end
