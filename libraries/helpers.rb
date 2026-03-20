# frozen_string_literal: true

module ControlGroups
  module Helpers
    def control_group_packages
      case node['platform_family']
      when 'debian'
        %w(cgroup-tools libcgroup2 libpam-cgroup)
      when 'rhel', 'fedora', 'amazon'
        %w(libcgroup libcgroup-tools)
      else
        raise "Unsupported platform family encountered: #{node['platform_family']}"
      end
    end

    def initialize_control_group_state(mounts: ControlGroups.default_mounts)
      ControlGroups.config_struct_init(node, mounts)
      ControlGroups.rules_struct_init(node)
    end

    def ensure_control_group_base_resources(manage_runtime: true)
      config_file = edit_resource(:file, '/etc/cgconfig.conf') do
        content lazy { ControlGroups.build_config(node.run_state[:control_groups][:config]) }
        owner 'root'
        group 'root'
        mode '0644'
        action :create
        notifies :restart, 'systemd_unit[cgconfig.service]', :delayed if manage_runtime
      end

      rules_file = edit_resource(:file, '/etc/cgrules.conf') do
        content lazy { ControlGroups.build_rules(node.run_state[:control_groups][:rules][:active], node.run_state[:control_groups][:config][:structure]) }
        owner 'root'
        group 'root'
        mode '0644'
        action :create
        notifies :restart, 'systemd_unit[cgred.service]', :delayed if manage_runtime
      end

      control_group_packages.each do |package_name|
        edit_resource(:package, package_name) do
          action :install
        end
      end

      edit_resource(:systemd_unit, 'cgconfig.service') do
        content(
          Unit: {
            Description: 'Configure libcgroup hierarchies',
            ConditionPathExists: '/etc/cgconfig.conf',
            After: 'local-fs.target',
          },
          Service: {
            Type: 'oneshot',
            RemainAfterExit: true,
            ExecStart: '/usr/sbin/cgconfigparser -l /etc/cgconfig.conf',
            ExecStop: '/usr/sbin/cgclear -l /etc/cgconfig.conf',
          },
          Install: {
            WantedBy: 'multi-user.target',
          }
        )
        triggers_reload true
        action manage_runtime ? %i(create enable start) : %i(create enable)
      end

      edit_resource(:systemd_unit, 'cgred.service') do
        content(
          Unit: {
            Description: 'Run libcgroup rules engine',
            ConditionPathExists: '/etc/cgrules.conf',
            After: 'cgconfig.service',
            Requires: 'cgconfig.service',
          },
          Service: {
            Type: 'simple',
            ExecStart: '/usr/sbin/cgrulesengd -n',
            ExecReload: '/bin/kill -USR2 $MAINPID',
            Restart: 'on-failure',
          },
          Install: {
            WantedBy: 'multi-user.target',
          }
        )
        triggers_reload true
        action manage_runtime ? %i(create enable start) : %i(create enable)
      end

      { config_file: config_file, rules_file: rules_file }
    end
  end
end
