# Services

Units and long-running processes this tree manages. Distro packages may ship their own units (Unbound, NetworkManager) that Salt only enables or configures.

## User systemd — `cap-volume`

| | |
| --- | --- |
| Unit | `/etc/systemd/user/cap-volume.service` |
| Enablement | symlink in `default.target.wants` |
| After | `pipewire-pulse.service`, `pulseaudio.service` |
| Exec | `/usr/local/bin/cap-volume` |
| Restart | always, 3s |

```bash
systemctl --user status cap-volume
journalctl --user -u cap-volume
```

Linux only, all core minions. See [Hardware](hardware.md).

## Systemd — Unbound and resolved

| Unit | Salt action |
| --- | --- |
| `unbound` | installed, `running` + `enable`, watch local-resolver.conf |
| `systemd-resolved` | `running` + `enable`, watch `10-unbound.conf` |

See [Networking](networking.md).

## Docker — `ollama`

Not a systemd unit from this repo. Salt `docker_container.running`:

```bash
docker ps --filter name=ollama
curl -s localhost:11434/api/tags
```

Linux workstation. Image `ollama/ollama:rocm` on AMD nodes. See [AI and GPU](ai.md).

## Systemd — `g560` (not on default highstate)

Would be `/etc/systemd/system/g560.service`, `WorkingDirectory=/opt/logitech-g560-led`, `ExecStart=/usr/bin/python3 g560_service.py`, `Restart=always`, enabled. Requires `multimedia.sls` + `g560` flag.

## Profile snippets (not services)

`/etc/profile.d/rocm.sh` — PATH/LD_LIBRARY_PATH for ROCm on RedHat + `amd_gpu`.

## Not present

- No Vault server unit
- No Synergy systemd unit (only an undeployed X session snippet)
- No firewalld/iptables states
- `salt-minion` is installed by `hello-fedora.sh` but **not** enabled in that script
