ruby_block 'control_groups[write configs]' do
  block do
    ControlGroups.config_struct_init(node)
    ControlGroups.rules_struct_init(node)
    c = Chef::Resource::File.new('/etc/cgconfig.conf', run_context)
    c.content ControlGroups.build_config(node.run_state[:control_groups][:config])
    r = Chef::Resource::File.new('/etc/cgrules.conf', run_context)
    r.content ControlGroups.build_rules(node.run_state[:control_groups][:rules][:active])
    case node.platform
    when 'amazon', 'centos', 'fedora', 'oracle', 'redhat', 'scientific'
      c.notifies :restart, resources('service[cgconfig]'), :immediately
    when 'debian'
      c.notifies :restart, resources('service[cgconfig]'), :immediately
      r.notifies :restart, resources('service[cgred]'), :immediately
    when 'ubuntu'
      if node.platform_version == '12.04'
        c.notifies :restart, resources('service[cgconfig]'), :immediately
        r.notifies :restart, resources('service[cgred]'), :immediately
      else
        c.notifies :restart, resources('service[cgroup-lite]'), :immediately
      end
    end
    c.run_action(:create)
    r.run_action(:create)
  end
  action :nothing
end

ruby_block 'control_group_configs[notifier]' do
  block do
    Chef::Log.debug 'Sending delayed notification to cgroup config files'
  end
  notifies :create, resources(:ruby_block => 'control_groups[write configs]'), :delayed
end
