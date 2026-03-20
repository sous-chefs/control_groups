# control_groups_install

Install and remove the libcgroup packages, service units, and generated configuration files used by this cookbook.

## Actions

| Action | Description |
|--------|-------------|
| `:install` | Installs packages, writes the config files, and enables the `cgconfig` and `cgred` services (default) |
| `:remove` | Stops the services, deletes the config files, and removes installed packages |

## Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `name` | String | `name` | Resource identity |
| `mounts` | Hash | `ControlGroups.default_mounts` | Mount map written into `/etc/cgconfig.conf` |

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
