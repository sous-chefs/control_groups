# Limitations

This cookbook now targets the resource-oriented API only and is validated against a narrow, explicit support matrix.

## Supported platforms

- Ubuntu 24.04: `packages.ubuntu.com` lists `libpam-cgroup` in Noble's `admin` section, confirming the libcgroup userspace packages are still published for the current LTS.

## Researched but not supported

- Amazon Linux 2023: AWS documents `libcgroup-tools` on AL2023, but the same documentation states AL2023 uses cgroup v2 and recommends `systemd` resource control instead. This cookbook still renders classic `cgconfig.conf` and `cgrules.conf` files, so AL2023 is documented as a limitation rather than an advertised target.
- Debian 12: Debian still publishes the libcgroup stack, but this repository does not currently run Kitchen coverage for Debian and therefore does not advertise it as supported.
- openSUSE Leap: the modern `software.opensuse.org` results for related cgroup packages are either absent or community/experimental, so this cookbook does not claim support.
- RHEL-family clones: the repository no longer advertises CentOS or clone support without current package and runtime validation.
- Dokken / cgroup-v2 containers: a direct `kitchen converge` on Ubuntu 24.04 fails when `cgconfigparser` attempts to mount controller hierarchies from `cgconfig.conf` and receives `Operation not permitted`. The Kitchen suites therefore run with `manage_runtime false`, which verifies package installation, config generation, and systemd unit creation without attempting to start the libcgroup daemons in a cgroup-v2 container.

## Architecture notes

- Debian and Ubuntu publish the libcgroup packages for multiple architectures through their normal package repositories.
- This cookbook does not attempt source builds or vendor repositories; it relies on distro-packaged libcgroup utilities only.

## Source URLs

- Debian package index: https://packages.debian.org/bookworm/libpam-cgroup
- Ubuntu package index: https://packages.ubuntu.com/noble/admin/
- Amazon Linux 2023 cgroups guidance: https://docs.aws.amazon.com/linux/al2023/ug/resource-limiting-raw-cgroups.html
- Amazon Linux 2023 cgroup v2 note: https://docs.aws.amazon.com/linux/al2023/ug/cgroupv2.html
