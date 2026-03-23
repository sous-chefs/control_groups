# control_groups_rule

Define or remove an entry in `/etc/cgrules.conf`.

## Actions

| Action     | Description                                         |
| ---------- | --------------------------------------------------- |
| `:create`  | Adds or updates the rule (default)                  |
| `:delete`  | Removes the rule target from `/etc/cgrules.conf`    |

## Properties

- `user`: `String`, defaults to the `name` property. User segment of the cgrules target.
- `command`: `String`, defaults to `nil`. Optional command segment of the target.
- `controllers`: `Array`, required. Controllers bound to the rule.
- `destination`: `String`, required. Destination group name.
- `mounts`: `Hash`, defaults to `ControlGroups.default_mounts`. Mount map written into `/etc/cgconfig.conf` before validating destinations.
- `manage_runtime`: `Boolean`, defaults to `true`. When `true`, enables and starts the libcgroup systemd units. Set to `false` in Dokken or other cgroup-v2 test environments.

## Examples

```ruby
control_groups_rule 'alice' do
  controllers %w(cpu memory)
  destination 'limited'
end
```

```ruby
control_groups_rule 'alice' do
  command 'stress-ng'
  controllers ['cpu']
  destination 'limited'
end
```

```ruby
control_groups_rule 'alice' do
  command 'stress-ng'
  controllers %w(cpu memory)
  destination 'limited'
  manage_runtime false
end
```
