Control Groups
==============

[![Cookbook Version](https://img.shields.io/cookbook/v/control_groups.svg?style=flat)](https://supermarket.chef.io/cookbooks/sysctl) [![CircleCI](https://circleci.com/gh/sous-chefs/control_groups.svg?style=svg)](https://circleci.com/gh/sous-chefs/control_groups) [![License](https://img.shields.io/badge/license-Apache_2-blue.svg)](https://www.apache.org/licenses/LICENSE-2.0)

Manage control groups (cgroups) via chef!

Example usage:
--------------

```ruby
control_groups_entry 'lackresources' do
  memory('memory.limit_in_bytes' => '1M')
  cpu('cpu.shares' => 1)
end

control_groups_rule 'someuser' do
  controllers [:cpu, :memory]
  destination 'lackresources'
end
```

This will restrict all processes created by `someuser` into
the `lackresources` control group.

Repository:
-----------

* Repository: https://github.com/hw-cookbooks/control_groups
* IRC: Freenode @ #heavywater
