# Hardware and audio

`roles/core/drivers` applies to **every** minion. Extra workstation scripts depend on node flags.

## Volume cap (all Linux)

PipeWire/PulseAudio have no hard ceiling. Capacitive volume strips (the unit comments mention Logitech MX 5000) can jump the sink past 100%.

Salt installs:

| Path | Role |
| --- | --- |
| `/usr/local/bin/cap-volume` | Script |
| `/etc/systemd/user/cap-volume.service` | User unit, Restart=always |
| `default.target.wants/cap-volume.service` | Enabled for every user session |

The script sets **`MAX_VOL=80`**. On start, and on every `pactl subscribe` sink event, if the default sink is above 80% it is forced back to 80%. Requires `pactl` (`pulseaudio-utils` is installed here).

This is a **user** service (`systemctl --user status cap-volume`). It is not gated on a pillar flag.

To stop it for a session: `systemctl --user disable --now cap-volume.service` — Salt will put the wants symlink back on the next apply.

## Bluetooth

If `laptop` **or** `bluetooth` is set, Linux gets `bluez-tools`. Pairing/agent CLI is whatever BlueZ ships; this tree does not add extra udev rules.

Yakin: laptop. BlueDrake: bluetooth. Draugh: both.

## Razer Nari Ultimate

If `node.has('razer')`, Salt drops ALSA card-profile paths and a udev rule (`idVendor=1532`, products `051a` / `051c` / `051d`) so Pulse/PipeWire expose separate **Chat** and **Game** sinks.

**No current node sets `razer: True`.** The files exist under `roles/core/drivers/files/pulseaudio/razer-nari-ultimate/`. Template engine for the udev rule is **mako** (Jinja would choke on `{{{ }}}`).

## Logitech G560 LED

If `g560` (BlueDrake) **and** `multimedia.sls` is applied:

- Python deps: pyusb, gobject, rpyc
- Clone [mdoyleaz/Logitech-G560-LED-Controller](https://github.com/mdoyleaz/Logitech-G560-LED-Controller) to `/opt/logitech-g560-led`
- `/usr/local/bin/g560-led` runs `python3 g560_gui.py` from that directory
- systemd **system** unit `g560.service` runs `g560_service.py` (RPC), enabled

`multimedia.sls` is **not** included from `userland-software/init.sls`, so a normal workstation highstate does **not** install this stack even on BlueDrake. The node flag is ready; the include is not.

## Intel I226-V Ethernet

If `i226` and kernel is Linux (BlueDrake): `/usr/bin/restore-ethernet-controller`.

Must run as **root**. Finds the PCI device whose `lspci` line contains `I226-V`, writes `remove` then `/sys/bus/pci/rescan`. Workaround for the controller going silent on Linux ([reference](https://blog.cordx.cx/posts/2024-09-19-intel-net-cont-problem)).

```bash
sudo restore-ethernet-controller
```

Exits 1 if not root or the chipset is not found.

## FreeBSD laptops

If `os == FreeBSD` and `laptop`:

- `xf86-input-synaptics` and `hw.psm.synaptics_support=1` in `/boot/loader.conf`
- `pwcview`, `webcamd_enable=YES`, `cuse4bsd_load=YES`

Yakin and Draugh are laptops in pillar; they are not FreeBSD in `top.sls` commentary, but the states would fire if the grain matched.
