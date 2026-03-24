# frozen_string_literal: true

provides :control_groups_rule
unified_mode true

use '_partial/_config'

property :user,        String, name_property: true
property :command,     String
property :controllers, Array,  required: true, coerce: proc { |value| Array(value).map(&:to_s) }
property :destination, String, required: true

default_action :create

action_class do
  include ControlGroups::Helpers

  def target
    ControlGroups.build_target(new_resource.user, new_resource.command)
  end
end

action :create do
  initialize_control_group_state(mounts: new_resource.mounts)
  node.run_state[:control_groups][:rules][:active][target] = {
    controllers: new_resource.controllers,
    destination: new_resource.destination,
  }
  ensure_control_group_base_resources(manage_runtime: new_resource.manage_runtime)
end

action :delete do
  initialize_control_group_state(mounts: new_resource.mounts)
  node.run_state[:control_groups][:rules][:active].delete(target)
  ensure_control_group_base_resources(manage_runtime: new_resource.manage_runtime)
end
