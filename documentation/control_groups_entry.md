# control_groups_entry

Define or remove a cgroup entry in `/etc/cgconfig.conf`.

## Actions

| Action     | Description                                        |
| ---------- | -------------------------------------------------- |
| `:create`  | Adds or updates the named cgroup entry (default)   |
| `:delete`  | Removes the named cgroup entry                     |

## Properties

- `group`: `String`, defaults to the `name` property. Name of the cgroup entry.
- `perm_task_uid`: `String`, defaults to `nil`. Task owner UID.
- `perm_task_gid`: `String`, defaults to `nil`. Task owner GID.
- `perm_admin_uid`: `String`, defaults to `nil`. Admin owner UID.
- `perm_admin_gid`: `String`, defaults to `nil`. Admin owner GID.
- `cpu`: `Hash`, defaults to `nil`. CPU controller settings.
- `cpuacct`: `Hash`, defaults to `nil`. CPU accounting controller settings.
- `devices`: `Hash`, defaults to `nil`. Device controller settings.
- `freezer`: `Hash`, defaults to `nil`. Freezer controller settings.
- `memory`: `Hash`, defaults to `nil`. Memory controller settings.
- `extra_config`: `Hash`, defaults to `{}`. Additional key/value pairs rendered inside the group.
- `mounts`: `Hash`, defaults to `ControlGroups.default_mounts`. Mount map written into `/etc/cgconfig.conf` before the group stanza.
- `manage_runtime`: `Boolean`, defaults to `true`. When `true`, enables and starts the libcgroup systemd units. Set to `false` in Dokken or other cgroup-v2 test environments.

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

```ruby
control_groups_entry 'limited' do
  cpu('cpu.max' => '10000 100000')
  manage_runtime false
end
```
