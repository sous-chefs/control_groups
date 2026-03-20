# control_groups_rule

Define or remove an entry in `/etc/cgrules.conf`.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Adds or updates the rule (default) |
| `:delete` | Removes the rule target from `/etc/cgrules.conf` |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `user` | String | `name property` | User segment of the cgrules target |
| `command` | String | `nil` | Optional command segment of the target |
| `controllers` | Array | required | Controllers bound to the rule |
| `destination` | String | required | Destination group name |

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
