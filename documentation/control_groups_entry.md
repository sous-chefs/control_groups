# control_groups_entry

Define or remove a cgroup entry in `/etc/cgconfig.conf`.

## Actions

| Action | Description |
|--------|-------------|
| `:create` | Adds or updates the named cgroup entry (default) |
| `:delete` | Removes the named cgroup entry |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `group` | String | `name property` | Name of the cgroup entry |
| `perm_task_uid` | String | `nil` | Task owner UID |
| `perm_task_gid` | String | `nil` | Task owner GID |
| `perm_admin_uid` | String | `nil` | Admin owner UID |
| `perm_admin_gid` | String | `nil` | Admin owner GID |
| `cpu` | Hash | `nil` | CPU controller settings |
| `cpuacct` | Hash | `nil` | CPU accounting controller settings |
| `devices` | Hash | `nil` | Device controller settings |
| `freezer` | Hash | `nil` | Freezer controller settings |
| `memory` | Hash | `nil` | Memory controller settings |
| `extra_config` | Hash | `{}` | Additional key/value pairs rendered inside the group |

## Examples

```ruby
control_groups_entry 'limited' do
  cpu('cpu.max' => '10000 100000')
  memory('memory.max' => '1048576')
end
```

```ruby
control_groups_entry 'limited' do
  perm_task_uid 'root'
  extra_config('notify_on_release' => '1')
end
```
