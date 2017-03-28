pkgs = case node.platform_family
when 'debian'
  %w(cgroup-bin libcgroup1)
when 'rhel'
  %w(libcgroup)
else
  raise "Unsupported platform family encountered: #{node.platform_family}"
end

pkgs.each do |pkg_name|
  package pkg_name
end


cgroups_config_service = 'cgconfig'
cgroups_rules_service = 'cgred'

# Ubuntu 14.04 and upwards removed the cgconfig service, so we have a different flow there
if node[:platform] == 'ubuntu' && Float(node[:platform_version]) >= 14.04
  Chef::Log.info("Installing additional cgroup-lite package for ubuntu >= 14.04")
  package "cgroup-lite"

  cgroups_config_service = 'cgroup-lite'
  cgroups_rules_service = 'cgrulesengd'

  file '/etc/init/cgroup-lite.conf' do
    content <<-EOF
      start on mounted MOUNTPOINT=/sys/fs/cgroup

      script
        echo "Running cgconfigparser" >> /var/log/cgroup-lite.conf.log
        /usr/sbin/cgconfigparser -l /etc/cgconfig.conf >> /var/log/cgroup-lite.conf.log || true
        echo "Finished running cgconfigparser" >> /var/log/cgroup-lite.conf.log
      end script
    EOF
    mode 0755
    owner 'root'
    group 'root'
  end

  file '/etc/init/cgrulesengd.conf' do
    content <<-EOF
      start on started cgroup-lite
      stop on stopped cgroup-lite

      script
        echo "Running cgrulesengd" >> /var/log/cgrulesengd.conf.log
        exec /usr/sbin/cgrulesengd --nodaemon
        echo "Finished running cgrulesengd with status $?" >> /var/log/cgrulesengd.conf.log
      end script
    EOF
    mode 0755
    owner 'root'
    group 'root'
  end
end

service cgroups_rules_service do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :start => true, :stop => true, :reload => true, :restart => true
  restart_command "service #{cgroups_rules_service} restart"
  action :nothing
end

service cgroups_config_service do
  provider Chef::Provider::Service::Upstart
  supports :status => true, :start => true, :stop => true, :reload => true, :restart => true
  # The restart flow is - Mount cgroup itself if it isn't already mounted, then unmount or delete (it's safe) any mounted cgroup components - then run cgconfigparser.
  restart_command '(grep -q /sys/fs/cgroup /proc/mounts || mount -t tmpfs -o uid=0,gid=0,mode=0755 cgroups /sys/fs/cgroup); (for d in $(ls /sys/fs/cgroup); do (umount "/sys/fs/cgroup/$d" || rm -rf "/sys/fs/cgroup/$d" || true) 2> /dev/null; done); (/usr/sbin/cgconfigparser -l /etc/cgconfig.conf)'
  action :nothing
end

ruby_block 'control_groups[write empty configs]' do
  block do
    ControlGroups.config_struct_init(node)
    ControlGroups.rules_struct_init(node)
  end
  notifies :create, "file[/etc/cgconfig.conf]", :delayed
  notifies :create, "file[/etc/cgrules.conf]", :delayed
end

file '/etc/cgconfig.conf' do
  content lazy{ControlGroups.build_config(node.run_state[:control_groups][:config])}
  notifies :restart, "service[#{cgroups_config_service}]", :immediately
  action :nothing
end

file '/etc/cgrules.conf' do
  content lazy{ControlGroups.build_rules(node.run_state[:control_groups][:rules][:active])}
  notifies :restart, "service[#{cgroups_rules_service}]", :immediately
  action :nothing
end

# Disable default groups because it kills the cgconfig service
file "/etc/default/cgconfig" do
  content <<-EOH
CREATE_DEFAULT=no
CGCONFIG=/etc/cgconfig.conf
EOH
  notifies :restart, "service[#{cgroups_config_service}]", :delayed
end