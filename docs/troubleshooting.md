# Troubleshooting

Only failure modes that are visible from scripts, comments, or state guards. This is not a general Linux FAQ.

## Zsh dies immediately with a missing `.zkbd` file

`.zshrc` does `source $HOME/.zkbd/$TERM` with no existence check. Salt never writes that file.

```bash
autoload zkbd
zkbd
```

Run once per terminal type (`xterm-256color`, `tmux-256color`, …).

## `~/.zshrc` did not pick up a Salt update

The state uses `replace: False`. First write wins. Merge by hand from `roles/core/shell/files/dot.zshrc` or move your file aside and re-apply.

## `git land` is not a git command

Helpers live in `~/bin`. Put that directory on `PATH` (the provisioned zshrc does not). Confirm:

```bash
ls ~/bin/git-land
git --exec-path
type git-land
```

## `chrome-monthly-history` cannot find the database

It only looks at **Google Chrome** paths (`google-chrome` / `google-chrome-unstable`), not `~/.config/chromium`. Exit 2. Copy or symlink History, or use Chrome.

## Ethernet gone on BlueDrake (I226-V)

```bash
sudo restore-ethernet-controller
```

If the script prints `Chipset not found.`, `lspci` has no `I226-V` line (wrong machine, or the device is already in a state `lspci` misses).

## Volume snaps back to 80%

That is `cap-volume`. Disable for the session:

```bash
systemctl --user disable --now cap-volume.service
```

Highstate will restore the enable symlink.

## Ollama / Docker states fail

Docker is not installed by Wynter states. Install Engine (and Salt’s docker Python bindings if required) first. The container always wants `/dev/kfd` and `/dev/dri`.

## eID / Chromium does not see the card

- Package `eid-mw` + viewer installed?
- `~/.pki/nssdb/pkcs11.txt` exists (state will not recreate an existing DB)?
- Rawhide: check `/etc/yum.repos.d/eid-archive.repo` no longer contains `$releasever`.

Firefox is not wired.

## GNOME scaling did not change

Needs `nodes.<id>.desktop` and a live user D-Bus (`/run/user/<uid>/bus`). Apply while logged into the graphical session.

## Unbound / DNS

- `systemctl status unbound systemd-resolved`
- BlueDrake: NM connection on `eno1` should show DNS 127.0.0.1
- `lan.` queries go to `172.27.26.100` — if that gateway is down, LAN names fail while public DNS may still work

## `pm` is not a command

Need a zsh that sourced pm.zsh. New terminals after highstate; `echo $plugins` should mention `pm` if the file loaded. `~/.pm/` is only mkdir’d when `install_pm` is in user tasks.

## Highstate errors on `node.get_all_properties`

Minion id must exist under `pillar` `nodes:`. `hello-fedora.sh` sets id from `hostname -s`.
