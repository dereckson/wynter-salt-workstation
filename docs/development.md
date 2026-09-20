# Development

Workstation language toolchains and editors. Git-specific helpers have their own page: [Git helpers](git.md).

## PHP

- **Debian / FreeBSD:** PHP 8.5 packages; PHP 7.0 packages are removed.
- **Fedora (not rolling):** Remi repo + `dnf module enable php:remi-8.5`.
- **Fedora Rawhide (`rollingRelease`):** Remi enablement is skipped.
- Extensions: bcmath, gd, intl, mbstring, soap, xml; Debian also curl and xsl.
- Composer via distro package **and** pinned phar 2.8.8 at `/usr/local/bin/composer`.
- phpcs / pear / phpunit from distro maps.
- **Psysh** at `psysh` (see [Commands](commands.md)).

## Python

`python3` + pip. Salt also runs `python3 -m pip install --root-user-action=ignore` for:

| Tool | Config deployed for `dereckson` | Role |
| --- | --- | --- |
| `merge-dictionaries` | `~/.config/merge-dictionaries.conf` | git repo list (`wynter-dictionary`) |
| `resolve-hash` | `~/.config/resolve-hash.conf` | Wikimedia Gerrit URL; Terminator plugin `ResolveHashURLHandler` |

Exact CLI flags of those PyPI packages are not vendored here — run `merge-dictionaries --help` / `resolve-hash --help` on the box.

## Java, .NET, Node, Ruby, TCL, C/C++

See the tables on [Software](software.md). Node globals are dated frontend tooling (Bower, Browserify, Grunt, Gulp, `react-tools`). Ruby `rubocop` is skipped on RedHat family.

`GOPATH` is `$HOME/dev/go` when the `go` binary exists ([Shell](shell.md)). Go itself is not installed by these states.

## Rust

Two different mechanisms:

1. **Always (if `dev.sls` applies):** distro `rust` / `rust-all` / `rustc` plus PostgreSQL and SQLite client/devel libs “needed by diesel”.
2. **`rust.sls` (not included):** for each user task:
    - `install_rustup` — rustup via `sh.rustup.rs`, then `stable` and `nightly` for the host triplet from `rust.get_rustc_triplet`
    - `install_diesel` — `cargo install diesel_cli --no-default-features --features postgres,sqlite`

Pillar currently lists both tasks for `dereckson`, but **highstate will not run `rust.sls`** until it is included. Distro rustc is still present.

## Editors

| Editor | How it lands |
| --- | --- |
| vim, nano, joe, emacs | packages (`EDITOR=nano` in zsh) |
| gedit | desktop package |
| Pulsar | downloaded; ppm packages from pillar |
| Terminator | desktop package + dotfile |

`.editorconfig` in this **Salt repo** is for editing the states themselves (2-space YAML/Jinja, 4-space py/sh). It is not deployed to `$HOME`.

## Fedora RPM packaging extras

On BlueDrake and Draugh, `fedora-dev` adds `dnf-utils`, `perl-generators`, and `setools-console`. See [Fedora RPM work](fedora-dev.md).
