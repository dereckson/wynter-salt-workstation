# Commands

Custom binaries and wrappers this tree installs (or would install). Distro packages (`vim`, `ag`, `pwgen`, …) are listed on [Software](software.md), not here.

Path prefixes follow `map.jinja`: `/usr/bin` on Linux, `/usr/local/bin` on FreeBSD, unless a state hardcodes `/usr/local/bin`.

## Always on Linux core

### `cap-volume`

| | |
| --- | --- |
| Path | `/usr/local/bin/cap-volume` |
| Service | user unit `cap-volume.service` |
| Purpose | Keep default Pulse/PipeWire sink ≤ 80% |

No CLI flags. Foreground loop: `pactl subscribe` filtered to sink events. You normally do not run it by hand; systemd does. See [Hardware](hardware.md).

## Workstation — always included

### `tmux-reattach`

| | |
| --- | --- |
| Path | `$bindir/tmux-reattach` (Linux: `/usr/bin/tmux-reattach`) |
| Source | `tmux -2 -u attach \|\| tmux -2 -u` |

256-color, UTF-8: attach to an existing tmux session, or create one. No options.

### `chrome-monthly-history`

| | |
| --- | --- |
| Path | `/usr/local/bin/chrome-monthly-history` |
| Usage | `chrome-monthly-history` · `chrome-monthly-history YYYY-MM` |

Reads Chrome History SQLite (copy, not the live file):

1. `~/.config/google-chrome-unstable/Default/History`
2. else `~/.config/google-chrome/Default/History`

Prints `(date, url, title)` rows for that month (`hidden=0`). **Chromium is installed; these paths are Google Chrome.** If neither DB exists, exit 2.

Excluded URL substrings (blog-oriented filter): pinterest.com, google.com, dereckson.be, nasqueron.org, youtube.com, leonardo.ai, adobe.com.

Invalid month → exit 1, message `Invalid month expression`.

### `psysh`

Symlink to `/opt/psysh/psysh` (v0.12.8). PHP REPL; manual DB at `/usr/local/share/psysh/php_manual.sqlite`. Zsh aliases `psysh` to `rlwrap psysh` when rlwrap exists.

### `composer`

`/usr/local/bin/composer` → `/opt/composer.phar` (Composer 2.8.8). Distro composer package may also be present.

### `merge-dictionaries` / `resolve-hash`

Installed with pip into `/usr/local/bin`. User configs:

- `~/.config/merge-dictionaries.conf` — git remotes to merge
- `~/.config/resolve-hash.conf` — Gerrit bases

### Git subcommands (`~/bin`)

See [Git helpers](git.md): `git get-default-branch`, `newbug`, `resend`, `receive`, `land`, `bye`, `rename-branch`, `delete-remote-branch`.

### `pm` (zsh function)

Not a binary. After `.zshrc` loads pm: `pm add`, `pm list`, `pm go`, `pm remove`, `pm config`. Data under `~/.pm/` when the `install_pm` task ran. See [Shell](shell.md).

## Workstation — node-gated

### `restore-ethernet-controller`

| | |
| --- | --- |
| Path | `/usr/bin/restore-ethernet-controller` |
| Gate | `nodes.<id>.i226` and Linux (BlueDrake) |
| Usage | `sudo restore-ethernet-controller` |

PCI remove + rescan for Intel I226-V. Root only.

## In the tree, not on the default highstate

### `g560-led`

Would be `/usr/local/bin/g560-led` if `multimedia.sls` applied and `g560` were set. Launches the upstream GUI from `/opt/logitech-g560-led`. Companion RPC daemon: `g560.service`.

### `organize-folders` / `organize-screenshots`

Would symlink from `/opt/wynter/kitro` if `kitro.sls` were included. `~/.config/organize/folders.yml` is already deployed (empty) by core home files.

### rustup / `diesel`

Would live in `~/.cargo/bin` if `rust.sls` applied and user tasks `install_rustup` / `install_diesel` were set.

## Not installed — run from the git checkout

These live under `utils/` and are **not** copied into `/usr`.

| Script | Usage |
| --- | --- |
| `utils/bootstrap/hello-fedora.sh` | `sudo ./hello-fedora.sh` — Salt minion + `/srv/salt` |
| `utils/zfs/install-openzfs-fedora.sh` | `sudo ./install-openzfs-fedora.sh` |
| `utils/zfs/mount-root-pool.sh` | `sudo ./mount-root-pool.sh <pool>` |

See [Rescue utilities](utilities.md).

## Cygwin

`/home/dereckson/bin/start` — start pageant/ssh-pageant, then `ssh -t ysul.nasqueron.org tmux -2 -u attach`. Only if the cygwin role is applied ([Windows](windows.md)).
