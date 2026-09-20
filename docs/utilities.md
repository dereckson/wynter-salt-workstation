# Rescue utilities

Scripts under `utils/` are **operator tools in git**, not packages. Run them from a clone. All require root.

## Fedora: install Salt (`hello-fedora.sh`)

See [Getting started](getting-started.md). Idempotent-ish: it always rewrites `/etc/salt/minion` and `minion_id`; it only clones/symlinks `/srv/salt` if missing.

Touched files (from the script header): `/etc/dnf/repos.override.d/99-config_manager.repo`, `/etc/yum.repos.d/salt.repo`, package `salt-minion`.

## Fedora: OpenZFS (`install-openzfs-fedora.sh`)

Follows the [OpenZFS Fedora guide](https://openzfs.github.io/openzfs-docs/Getting%20Started/Fedora/):

1. `rpm -e --nodeps zfs-fuse` if present
2. Install `zfs-release-2-8$(rpm --eval %dist)` from zfsonlinux.org
3. `kernel-devel` matching `uname -r` (version before `-`)
4. `dnf install zfs`, `modprobe zfs`, `zpool import`

Does not create pools or set mountpoints.

## Live CD: import a root pool (`mount-root-pool.sh`)

```bash
sudo ./mount-root-pool.sh <pool>
```

Creates `/mnt/<pool>` and `zpool import -R /mnt/<pool> <pool>` so a pool that normally mounts at `/` does not clobber the running rescue system (“altroot”).

Intended for recovery, not day-to-day workstation use.
