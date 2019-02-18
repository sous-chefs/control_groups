property :group,           String
property :perm_task_uid,   String
property :perm_task_gid,   String
property :perm_admin_uid,  String
property :perm_admin_gid,  String
property :cpu,             Hash
property :cpuacct,         Hash
property :devices,         Hash
property :freezer,         Hash
property :memory,          Hash
property :extra_config,    Hash

def load_current_resource
  ControlGroups.config_struct_init(node)
  new_resource.group new_resource.name unless new_resource.group
end

action :create do
  run_context.include_recipe 'control_groups'

  group_name = new_resource.group.to_s
  group_struct = Mash.new(node.run_state[:control_groups][:config][:structure])
  perm = {}
  %w(task admin).each do |type|
    %w(uid gid).each do |idx|
      if (val = new_resource.send("perm_#{type}_#{idx}"))
        perm[type] ||= {}
        perm[type][idx] = val
      end
    end
  end

  grp_hsh = {}
  grp_hsh['perm'] = perm unless perm.empty?

  %w(cpu cpuacct devices freezer memory).each do |idx|
    if (val = new_resource.send(idx))
      grp_hsh[idx] = val
    end
  end
  group_struct[group_name] = grp_hsh
  node.run_state[:control_groups][:config][:structure] = group_struct
end
