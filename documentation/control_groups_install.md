# control_groups_install

Install and remove the libcgroup packages, service units, and generated configuration files used by this cookbook.

## Actions

| Action     | Description                                                                                           |
| ---------- | ----------------------------------------------------------------------------------------------------- |
| `:install` | Installs packages, writes the config files, and enables the `cgconfig` and `cgred` services (default) |
| `:remove`  | Stops the services, deletes the config files, and removes installed packages                          |

## Properties

- `name`: `String`, defaults to `name`. Resource identity.
- `mounts`: `Hash`, defaults to `ControlGroups.default_mounts`. Mount map written into `/etc/cgconfig.conf`.
- `manage_runtime`: `Boolean`, defaults to `true`. When `true`, enables and starts the libcgroup systemd units. Set to `false` in cgroup-v2 test environments that cannot mount legacy controller hierarchies.

## Examples

```ruby
control_groups_install 'default'
```

```ruby
control_groups_install 'default' do
  mounts(
    cpu: '/sys/fs/cgroup/cpu',
    memory: '/sys/fs/cgroup/memory'
  )
end
```

```ruby
control_groups_install 'default' do
  manage_runtime false
end
```
