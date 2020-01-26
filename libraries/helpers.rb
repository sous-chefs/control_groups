class Chef
  module ControlGroups
    module Helpers
      def control_group_packages
        case node['platform_family']
        when 'debian'
          %w(cgroup-bin libcgroup1)
        when 'rhel', 'fedora', 'amazon'
          %w(libcgroup libcgroup-tools)
        else
          raise "Unsupported platform family encountered: #{node['platform_family']}"
        end
      end
    end
  end
end

# enable `modprobe netprio_cgroup`
