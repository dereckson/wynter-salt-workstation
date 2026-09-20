# Windows and Cygwin

Role `cygwin-workstation` installs a Cygwin package set plus Chocolatey packages. **`top.sls` does not assign this role to any minion**, so it will not apply unless you add a Windows minion id (or call the sls files yourself).

## Cygwin packages

`roles/cygwin-workstation/cygwin-environment/base.sls` loops `cyg.installed` over a long list in `map.jinja`: shells (bash, zsh, dash, mintty), compilers (gcc, clang, gdb, cygwin32 toolchain), PHP + extensions, Python 2.7 / 3.8 pieces, Ruby, nginx, ImageMagick, DejaVu fonts, mosh, openssh, ssh-pageant, irssi, tmux, vim-minimal, the_silver_searcher, and base Cygwin utilities.

## `~/bin/start`

Salt writes `/home/dereckson/bin/start` (mode 755). Current behaviour (`MODE=PuTTY`):

1. `pageant` with `~/.ssh/id_ed25519.ppk` (Windows path via `cygpath -w`)
2. `ssh-pageant` env dumped to `$HOME/bin/ssh-agent-session`
3. `ssh -t ysul.nasqueron.org tmux -2 -u attach`

`MODE=OpenSSH` is in the script but not selected. Hardcoded user path and jump host.

!!! note "Source URL typo"
    The state uses `source: salt:/roles/cygwin-workstation/...` (one slash). Standard Salt URLs are `salt://`. Whether the minion still finds the file is unverified.

## Chocolatey

`chocolatey.bootstrap` then `chocolatey.installed` for:

- `ripgrep`
- `vault`

## Relation to Unix workstation

Cygwin does **not** reuse Linux `userland-software` or eID states. Treat it as a separate kit for a Windows box that still wants Unix CLI + SSH into `ysul`.
