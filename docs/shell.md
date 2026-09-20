# Shell

`roles/core/shell` installs Zsh (and tcsh except on FreeBSD) and, for each pillar user, writes `~/.zshrc` **only if the file is missing**. Salt will not overwrite a customized rc.

The shipped file is `roles/core/shell/files/dot.zshrc`.

## Interactive environment

| Setting | Value |
| --- | --- |
| `EDITOR` | `nano` |
| `PAGER` / `LESS` | `less` / `eiMqXR` |
| `LC_ALL` | `en_US.UTF-8` |
| `BLOCKSIZE` | `K` |
| `HISTFILE` | `~/.histfile`, 10 000 entries, `appendhistory` |
| Prompt (fallback) | `%B%/%b ] ` with VCS info on the right |
| Line editor | Emacs (`bindkey -e`) |
| Completions | `compinstall` styles, `_correct` / `_approximate`, max 4 errors |

TERM is upgraded to 256-color variants for `xterm`, `screen`, and `tmux`.

### History: zsh-histdb

Salt clones [larkery/zsh-histdb](https://github.com/larkery/zsh-histdb) to `/opt/shell_utilities/zsh-histdb`. If `sqlite-history.zsh` is present, it is sourced (SQLite-backed history). Otherwise the rc falls back to `hist_ignore_all_dups`, `hist_reduce_blanks`, `inc_append_history`, and `share_history`.

`sqlite` devel packages are installed as a histdb dependency; `sqlite3` is aliased to `sqlite` when the binary exists.

### Prompt: Starship, VCS, zoxide

Packages **starship**, **zoxide**, **fzf**, and **git** are installed. The rc initializes:

```zsh
command -v starship > /dev/null && eval "$(starship init zsh)"
command -v zoxide > /dev/null && eval "$(zoxide init zsh)"
```

Starship replaces the fallback prompt when present. `z` comes from zoxide, not the old `rupa/z`. **fzf is installed but not wired in this `.zshrc`.**

Git/CVS/SVN branch info is shown via `vcs_info` on `RPROMPT`. If `git-achievements` is on PATH, `git` is aliased to it (that binary is not provisioned here).

## Project jumper: `pm`

[Angelmmiguel/pm](https://github.com/Angelmmiguel/pm) is cloned to `/opt/shell_utilities/pm`. Zsh function + completion:

- `/usr/local/share/zsh/wynter/pm/pm.zsh` → `pm.zsh`
- `/usr/local/share/zsh/site-functions/_pm` → completion

The rc sources `~/.pm/pm.zsh` if you have a per-user copy, else the Wynter path above. Per-user `~/.pm/` is created when `users:<name>.tasks` contains `install_pm` (currently `dereckson`).

Typical usage (upstream CLI):

```zsh
cd ~/dev/some-project
pm add some-project
pm list
pm go some-project
pm remove some-project
```

If the Go compiler is **not** installed, `go` is aliased to `pm go` so `go some-project` jumps directories. If `go` **is** installed, `GOPATH` is set to `$HOME/dev/go` and that alias is not created.

## Key bindings and zkbd

The rc **unconditionally** sources `$HOME/.zkbd/$TERM` after `autoload zkbd`. Salt does **not** generate that file. On a new account, run `zkbd` once per terminal type or the shell will error on startup. See [Troubleshooting](troubleshooting.md).

Home/End/Delete and friends are bound from that file; Up/Down search history by prefix.

## Aliases shipped in `.zshrc`

| Alias / helper | Meaning |
| --- | --- |
| `cd..`, `cd...`, `cd....` | Walk up 1–3 directories |
| `h` | `history` |
| `n` | `nano` |
| `si` | `french-conjugator --mode=subjunctive --tense=imperfect` (verbiste) |
| `t` | `t --task-dir ~/.tasks --list tasks` — the `t` binary is **not** installed by these states |
| `lastwp` / `lastwolf` | Tail Freenode IRC logs under `irclogs/` |
| `weather` | `curl https://v2.wttr.in/Brussels` |
| `sqlite` | `sqlite3` if present |

Optional extra aliases: if `~/.zshrc-misc-aliases` exists, it is sourced. Salt does not create it.

### salt-wrapper

If `salt-wrapper` is on PATH, `salt`, `salt-call`, `salt-cloud`, `salt-key`, `salt-run`, and `salt-ssh` are aliased through it. This tree does not install `salt-wrapper`; the aliases are inert until that tool exists. Docs: [Nasqueron salt-wrapper](https://docs.nasqueron.org/salt-wrapper/admin.html#shell-aliases).

### Vault CLI

```zsh
export VAULT_ADDR="https://127.0.0.1:8200"
```

Bash-style completion is enabled for `vault` when the binary exists. **No Vault server is provisioned in this repository** — only the CLI package (see [Identity and secrets](identity.md)).

### grc and rlwrap

If `grc` is installed (it is, via workstation `base` utilities): `ping`, `ping6`, `df`, `dnf`, `du`, `ifconfig`, `ps`, `tail` are wrapped; `mysql` is paged through `grcat`.

If `rlwrap` is installed (workstation `dev` TCL stack): `tclsh` → `rlwrap tclsh8.6`, `psysh` → `rlwrap psysh`.

### SSH agent

If `$HOME/bin/ssh-agent-session` exists, it is sourced. Core/workstation states do not create that file. The Cygwin `start` script does (see [Windows and Cygwin](windows.md)).

### csh compatibility

`setenv` / `unsetenv` functions are defined for old muscle memory.

## What Salt installs for the shell (packages)

From `roles/core/shell`: `zsh`, `tcsh` (non-FreeBSD), `fzf`, `git`, sqlite devel, `starship`, `zoxide`.

Workstation `base` adds bash, tmux, tmux-reattach, grc, and more — see [Software](software.md).
