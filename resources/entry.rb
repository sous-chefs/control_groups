# frozen_string_literal: true

provides :control_groups_entry
unified_mode true

use '_partial/_config'

property :group,           String, name_property: true
property :perm_task_uid,   String
property :perm_task_gid,   String
property :perm_admin_uid,  String
property :perm_admin_gid,  String
property :cpu,             Hash
property :cpuacct,         Hash
property :devices,         Hash
property :freezer,         Hash
property :memory,          Hash
property :extra_config,    Hash, default: {}

default_action :create

action_class do
  include ControlGroups::Helpers

  def group_payload
    permissions = {}
    %w(task admin).each do |type|
      %w(uid gid).each do |id|
        next unless (value = new_resource.send("perm_#{type}_#{id}"))

        permissions[type] ||= {}
        permissions[type][id] = value
      end
    end

    payload = ControlGroups.normalize_hash(new_resource.extra_config)
    payload['perm'] = permissions unless permissions.empty?

    %w(cpu cpuacct devices freezer memory).each do |controller|
      next unless (value = new_resource.send(controller))

      payload[controller] = ControlGroups.normalize_hash(value)
    end

    payload
  end
end

action :create do
  initialize_control_group_state(mounts: new_resource.mounts)
  node.run_state[:control_groups][:config][:structure][new_resource.group] = group_payload
  ensure_control_group_base_resources(manage_runtime: new_resource.manage_runtime)
end

action :delete do
  initialize_control_group_state(mounts: new_resource.mounts)
  node.run_state[:control_groups][:config][:structure].delete(new_resource.group)
  ensure_control_group_base_resources(manage_runtime: new_resource.manage_runtime)
end
