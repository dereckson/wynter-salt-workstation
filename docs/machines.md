# Known machines

Host identity is the Salt minion id (short hostname). Flags live in `pillar/core/nodes.sls` and are read by states via the custom `node.has` / `node.get` modules.

## Inventory

| Minion id | Roles (`top.sls`) | Node flags | Notes |
| --- | --- | --- | --- |
| **yakin** | `core` + `workstation` | `laptop: True` | Bluetooth tools via the laptop flag |
| **bluedrake** | `core` + `fedora-dev` + `workstation` | `bluetooth`, `g560`, `i226`, `amd_gpu`, `is_synergy_server`, `rollingRelease: False`; desktop text scale 1.25; `network.main_interface: eno1` | Primary desktop in recent history |
| **draugh** | `core` + `fedora-dev` + `workstation` | `bluetooth`, `laptop`, `rollingRelease: True` | Treated as Fedora Rawhide for eID and RPM Fusion |

Any other minion id still receives `roles/core` only.

## What each flag does for you

| Flag | Where | Effect when true |
| --- | --- | --- |
| `laptop` | `nodes:<id>` | Linux: install `bluez-tools`. FreeBSD: Synaptics + webcam (`pwcview`, `webcamd`, `cuse4bsd`). |
| `bluetooth` | `nodes:<id>` | Linux: install `bluez-tools` (same package as laptop). |
| `g560` | `nodes:<id>` | Clone Logitech G560 LED controller, install `g560-led`, enable `g560.service`. **BlueDrake only.** |
| `i226` | `nodes:<id>` | Install `/usr/bin/restore-ethernet-controller` (Intel I226-V PCI remove/rescan). Linux only. **BlueDrake only.** |
| `amd_gpu` | `nodes:<id>` | Install ROCm packages + AMD Ollama image; pass `/dev/kfd` and `/dev/dri` into the container. **BlueDrake only.** |
| `rollingRelease` | `nodes:<id>` | Fedora: enable RPM Fusion rawhide repos; skip Remi PHP module enablement; Fedora eID repo `$releasever` rewritten to a numbered Fedora. **Draugh.** |
| `desktop` | `nodes:<id>` | If present, run `gsettings` text-scaling-factor for every pillar user. **BlueDrake** uses `1.25`. |
| `network.main_interface` | `nodes:<id>` | NetworkManager connection on that NIC is rewritten to use Unbound at `127.0.0.1` / `::1`. **BlueDrake: `eno1`.** |
| `is_synergy_server` | `nodes:<id>` | Set on BlueDrake. **No state reads this key** (see below). |
| `razer` | `nodes:<id>` | PulseAudio/ALSA profile for Razer Nari Ultimate. **Not set on any current node.** |

`node.has('rollingRelease')` is also what `fedora.is_rawhide()` returns.

## Synergy identity mismatch

Two different notions of “Synergy server” exist:

1. `nodes.bluedrake.is_synergy_server: True`
2. `synergy_server.id: orin` and `synergy_server.addr: 172.27.26.119` in `pillar/workstation/synergy.sls`

Home-file templating (under `roles/core/home`) passes `is_synergy_server` as **`grains['id'] == pillar['synergy_server']['id']`**, i.e. hostname `orin`, not the BlueDrake node flag. The Synergy start snippet (`roles/workstation/userland-home/files/start.sh.jinja`) is **not** in a directory that any `file.recurse` currently deploys. See [DOCS_NOTES.md](https://github.com/dereckson/wynter-salt-workstation/blob/main/DOCS_NOTES.md).

## Adding a machine (user-facing)

To have Salt treat a new box as a laptop/GPU/etc. workstation:

1. Give it a short hostname that you will list in `top.sls` under the roles you want.
2. Add a `nodes:<minion_id>:` block in `pillar/core/nodes.sls` with the flags from the table above.
3. If userland should apply, keep or add the account in `pillar/core/users.sls`.
4. On Fedora, run or replicate `hello-fedora.sh` so `/etc/salt/minion` points at this tree.

There is no auto-registration.
