# Getting started

This page only restates what is already in the repository (README, `utils/bootstrap/hello-fedora.sh`, `top.sls`). It does not invent a highstate playbook.

## What Salt thinks this machine is

Minion id is the short hostname. `utils/bootstrap/hello-fedora.sh` writes it with:

```bash
hostname -s > /etc/salt/minion_id
```

`top.sls` then assigns roles:

```yaml
base:
  '*':
    - roles/core
  'bluedrake':
    - roles/fedora-dev
    - roles/workstation
  'draugh':
    - roles/fedora-dev
    - roles/workstation
  'yakin':
    - roles/workstation
```

Every minion gets `core`. Only those three ids currently get `workstation`. `cygwin-workstation` is defined as a role but **not listed** in `top.sls`.

If the short hostname is not one of those ids, you still get core (shell, Unbound, drivers) and none of the workstation software.

## README setup (any Unix)

From the repository README, for a primary or self-contained install:

1. Include the machine in pillar if needed (for example declare it as a laptop under `nodes:` — see [Known machines](machines.md) and [Pillar options](pillar.md)).
2. Symlink this repository to `/srv/salt`.
3. Sync custom execution modules from `_modules/`:

   ```bash
   salt-call --local saltutil.sync_all
   ```

Custom modules used by states: `node` (read `nodes:` pillar), `fedora` (Rawhide / eID repo version), `rust` (toolchain triplet; only loads if `rustc` is on PATH).

## Fedora bootstrap helper

`utils/bootstrap/hello-fedora.sh` is a root script, tested against Fedora 42, requiring **dnf5**. It:

1. Installs the Salt project yum repo and **`salt-minion`**, enabling `salt-repo-latest` (and disabling `salt-repo-3006-lts`).
2. If `/srv/salt` does not exist, symlinks the current git checkout there, or clones `https://github.com/dereckson/wynter-salt-workstation.git`.
3. Writes `/etc/salt/minion` with `file_roots` → `/srv/salt` and `pillar_roots` → `/srv/salt/pillar`.
4. Sets minion id from `hostname -s`.

It does **not** run a highstate, start `salt-minion`, or sync modules.

??? question "Is there an official apply command?"

    No. Nothing in this tree documents `state.apply` / `state.highstate`. Once the minion is configured, applying the top file is ordinary Salt (`salt-call --local state.apply` on a masterless box, or a master-driven highstate). Treat that as generic Salt, not a Wynter-specific runbook.

## Pillar is in-tree

`pillar/top.sls` ships with this repo and is applied to `*`:

| Pillar sls | Keys |
| --- | --- |
| `core/nodes` | Per-host flags (`laptop`, `amd_gpu`, …) |
| `core/users` | Accounts, tasks, avatar, pictures |
| `core/network` | Gateway + upstream DNS |
| `workstation/alkane` | Local site recipes |
| `workstation/pulsar` | Pulsar / ppm packages per user |
| `workstation/repo` | Copr, RPM Fusion, third-party repos (Fedora) |
| `workstation/synergy` | Synergy server id/address |

There is no separate encrypted pillar in this repository.

## After apply, what to expect as a user

- Zsh config is laid down **only if `~/.zshrc` does not already exist** (`replace: False`). Existing files are left alone.
- Git helpers land in `~/bin` for users that have a `roles/workstation/userland-home/files/<user>/` tree (currently `dereckson`).
- User systemd unit `cap-volume` is enabled for Linux; it caps the default PipeWire/Pulse sink at 80%. See [Hardware and audio](hardware.md).
- Workstation hosts pull a large package set, Belgian eID middleware, fonts, and (on Linux) an Ollama Docker container. Docker itself is **not** installed by these states.

Next: [Known machines](machines.md) if you need to match hostname to features, or [Shell](shell.md) to use the environment.
