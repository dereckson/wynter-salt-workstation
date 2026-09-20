# Pillar options

All pillar currently ships **in this repository** (`pillar/`) and is assigned to every minion via `pillar/top.sls`. There is no per-minion pillar targeting.

Convention: **if you want X, set Y**. Keys that only exist as documentation of current hosts are still listed so you can copy them.

## Nodes — `pillar/core/nodes.sls`

```yaml
nodes:
  <minion_id>:
    laptop: True
    bluetooth: True
    g560: True
    i226: True
    amd_gpu: True
    rollingRelease: True
    razer: True
    is_synergy_server: True
    desktop:
      text-scaling-factor: 1.25
    network:
      main_interface: eno1
```

| Want | Set |
| --- | --- |
| Bluetooth CLI tools on Linux | `laptop` and/or `bluetooth: True` |
| FreeBSD Synaptics + webcam | `laptop: True` (and actually be FreeBSD) |
| I226-V restore script | `i226: True` |
| ROCm + Ollama ROCm image | `amd_gpu: True` |
| Fedora Rawhide-style repos / eID `$releasever` rewrite / skip Remi PHP | `rollingRelease: True` |
| GNOME text scaling | `desktop.text-scaling-factor` (presence of `desktop` enables the state) |
| NM DNS forced to Unbound | `network.main_interface: <device>` |
| Razer Nari Pulse profiles | `razer: True` (no host currently) |
| G560 LED (also needs `multimedia.sls` included) | `g560: True` |

Undeclared minion ids make `node.get_all_properties` raise; several states call `node.has` / `node.get` which return `False` / `None` via `_get_property` **after** loading the node dict — if the id is missing entirely, `get_all_properties` errors. **Declare new hostnames in `nodes:` before applying states that use `node.has`.**

`is_synergy_server` under `nodes:` is **unused** by states. Synergy templating compares `grains['id']` to `synergy_server.id`.

## Users — `pillar/core/users.sls`

```yaml
users:
  alice:
    tasks:
      - install_pm
      - install_rustup
      - install_diesel
    avatar: /home/alice/Pictures/Avatars/face.jpg
    system_pictures:
      wallpapers_apps:
        collection: Wallpapers/Apps
        items:
          foo.jpg: https://example.invalid/foo.jpg
```

| Want | Set |
| --- | --- |
| Zsh rc, eID NSS DB, Pulsar ppm, desktop gsettings, home recurse | Add the Unix account name as a key under `users` |
| `~/.pm/` directory | `tasks: [install_pm]` (pm zsh still loads system-wide) |
| rustup + diesel | `install_rustup` / `install_diesel` **and** include `rust.sls` (currently not included) |
| GDM/AccountsService face | `avatar:` absolute path (file should exist via `system_pictures`) |
| Wallpaper / avatar downloads | `system_pictures.<id>.collection` + `items` map of filename → URL (`skip_verify`, no overwrite) |
| `~/bin` git helpers and Terminator config | Drop files under `roles/workstation/userland-home/files/<username>/` (not pillar). Only `dereckson` exists today. |

## Network — `pillar/core/network.sls`

| Want | Set |
| --- | --- |
| LAN zone forward | `network.gateway` (Unbound `lan.` forward-addr) |
| Public DNS forwarders | `network.dns` list |

## Repositories — `pillar/workstation/repo.sls`

Fedora only (plus CentOS EPEL hardcoded).

| Want | Set |
| --- | --- |
| Extra Copr | append `owner/name` to `repositories.copr` |
| RPM Fusion flavours | `rpmfusion`, `rpmfusion_extra`, `rpmfusion_rawhide` |
| `.repo` file from URL | `repositories.third_party_as_repo.<name>: <url>` |
| Repo-defining RPM | `repositories.third_party_as_rpm.<name>: <rpm url>` |

## Pulsar — `pillar/workstation/pulsar.sls`

```yaml
pulsar_packages:
  dereckson:
    - editorconfig
```

| Want | Set |
| --- | --- |
| Extra ppm packages | list under `pulsar_packages.<username>` |

Packages are installed once (`creates: ~/.pulsar/packages/<name>`).

## Alkane — `pillar/workstation/alkane.sls`

See [Local web sites](alkane.md). Keys: `alkane.domains`, `alkane.sites.<id>.{domain,subdomain,scripts.init,scripts.update}`.

## Synergy — `pillar/workstation/synergy.sls`

```yaml
synergy_server:
  id: orin
  addr: 172.27.26.119
```

Passed into `roles/core/home` Jinja as `synergy_server` / `is_synergy_server` (hostname == `id`). No live consumer until a templated start script is actually in that files tree.

## State top vs pillar

Assigning **roles** is not pillar: edit `top.sls` so the minion id includes `roles/workstation` (and optionally `roles/fedora-dev`). Pillar flags alone do not attach the workstation package set.
