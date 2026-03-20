# frozen_string_literal: true

module ControlGroups
  DEFAULT_MOUNTS = {
    cpu: '/sys/fs/cgroup/cpu',
    cpuacct: '/sys/fs/cgroup/cpuacct',
    cpuset: '/sys/fs/cgroup/cpuset',
    devices: '/sys/fs/cgroup/devices',
    memory: '/sys/fs/cgroup/memory',
    freezer: '/sys/fs/cgroup/freezer',
  }.freeze unless const_defined?(:DEFAULT_MOUNTS)

  class << self
    def default_mounts
      normalize_hash(DEFAULT_MOUNTS)
    end

    def rules_struct_init(node)
      node.run_state[:control_groups] ||= Mash.new
      node.run_state[:control_groups][:rules] ||= Mash.new(
        active: Mash.new
      )
    end

    def config_struct_init(node, mounts = default_mounts)
      node.run_state[:control_groups] ||= Mash.new
      node.run_state[:control_groups][:config] ||= Mash.new(
        structure: Mash.new,
        mounts: Mash.new(normalize_hash(mounts))
      )
    end

    def build_target(user, command = nil)
      [user, command].compact.join(':')
    end

    def build_rules(hash, structure)
      validate_rules!(hash, structure)

      output = ['# This file created by Chef!']
      unless hash.nil? || hash.empty?
        hash.to_hash.each_pair do |user, args|
          output << "#{user}\t#{Array(args[:controllers]).join(',')}\t#{args[:destination]}"
        end
      end
      output.join("\n") << "\n"
    end

    def build_config(hash)
      output = ['# This file created by Chef!']
      builder(hash[:structure], output, 0, 'group') unless hash[:structure].nil? || hash[:structure].empty?
      builder({ mount: hash[:mounts].to_hash }, output) unless hash[:mounts].nil? || hash[:mounts].empty?
      output.join("\n") << "\n"
    end

    def validate_rules!(rules, structure)
      return if rules.nil? || rules.empty?

      rules.to_hash.each_value do |rule|
        destination = structure[rule[:destination]] || structure[rule['destination']]
        raise "Invalid destination provided for rule (dest: #{rule[:destination] || rule['destination']})" unless destination

        Array(rule[:controllers] || rule['controllers']).each do |controller|
          next if destination[controller] || destination[controller.to_s]

          raise "Invalid controller provided for rule (controller: #{controller})"
        end
      end
    end

    def normalize_hash(hash)
      hash.each_with_object({}) do |(key, value), acc|
        acc[key.to_s] =
          if value.respond_to?(:to_hash)
            normalize_hash(value.to_hash)
          else
            value
          end
      end
    end

    private

    def builder(hash, array, indent = 0, prefix = nil)
      prefix = "#{prefix} " if prefix
      hash.to_hash.each_pair do |key, value|
        if value.is_a?(Hash)
          array << "#{' ' * indent}#{prefix}#{key} {"
          builder(value, array, indent + 2)
          array << "#{' ' * indent}}"
        else
          array << "#{' ' * indent}#{prefix}#{key} = #{value};"
        end
      end
    end
  end
end
