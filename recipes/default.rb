pkgs = case node.platform_family
when 'debian'
  %w(cgroup-bin libcgroup1)
when 'rhel'
else
  raise "Unsupported platform family encountered: #{node.platform_family}"
end

pkgs.each do |pkg_name|
  package pkg_name
end

service 'cgred' do
  action :nothing
end

service 'cgconfig' do
  action :nothing
end

ruby_block 'control_groups[write configs]' do
  block do
    ControlGroups.config_struct_init(node)
    ControlGroups.rules_struct_init(node)
    rc = Chef::RunContext.new(node, nil)
    c = Chef::Resource::File.new('/etc/cgconfig.conf', rc)
    c.content ControlGroups.build_config(node[:control_groups][:config])
    c.run_action(:create)
    Chef::Resource::Service.new('cgconfig', rc).run_action(:restart) if c.updated_by_last_action?
    r = Chef::Resource::File.new('/etc/cgrules.conf', rc)
    r.content ControlGroups.build_rules(node[:control_groups][:rules][:active])
    res = r.run_action(:create)
    Chef::Resource::Service.new('cgred', rc).run_action(:restart) if r.updated_by_last_action?
  end
  action :nothing
end

ruby_block "control_group_configs[notifier]" do
  block do
    Chef::Log.debug "Sending delayed notification to cgroup config files"
  end
  notifies :create, resources(:ruby_block => 'control_groups[write configs]'), :delayed
end
