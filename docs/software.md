# Software

The `workstation` role installs a large userland. Package *names* are mapped per OS family in `map.jinja` (Debian default, plus RedHat / Arch / FreeBSD). This page describes **what you get**, not every distro package string.

Fedora additionally enables extra yum repositories before packages (see below).

!!! warning "States in the tree but not applied"
    `roles/workstation/userland-software/init.sls` includes `repo`, `base`, `dev`, `hardware`, `ops`, `misc`, `psysh`, `desktop`, `pulsar`. It does **not** include `rust.sls`, `multimedia.sls`, or `kitro.sls`. Rhythmbox/VLC, rustup/diesel, and `organize-*` are documented on their pages as inactive unless you apply those sls files yourself.

## Fedora repositories

Gated on `grains['os'] == 'Fedora'`, data from `pillar/workstation/repo.sls`:

| Pillar list | Current values | Effect |
| --- | --- | --- |
| `repositories.copr` | `keefle/glow`, `atim/starship` | `dnf copr enable` |
| `repositories.rpmfusion` | `free`, `nonfree` | RPM Fusion release RPMs |
| `repositories.rpmfusion_extra` | tainted free/nonfree | extra Fusion repos |
| `repositories.rpmfusion_rawhide` | rawhide free/nonfree | only if `node.has('rollingRelease')` |
| `repositories.third_party_as_repo` | HashiCorp Fedora repo | `dnf config-manager addrepo` |
| `repositories.third_party_as_rpm` | Belgian eID archive RPM (2021-1 URL) | `dnf install` that RPM |

On Fedora **41+**, `fedora-cisco-openh264` is enabled. CentOS only: `epel-release`.

Debian HashiCorp apt source is added from `misc.sls` (Vault), separate from the Fedora HashiCorp repo.

!!! note "eID repo twice on Fedora"
    Workstation `repo.sls` may install pillar’s `eid-archive-fedora-2021-1` RPM, while `roles/workstation/eid` installs `eid-archive-fedora-2025-2` itself. Both paths can run on a Fedora workstation.

## Base userland (`base.sls`)

| Area | Contents |
| --- | --- |
| Shells | bash, zsh, tcsh (non-FreeBSD) |
| Editors | vim, nano, joe, emacs (nox on Debian/FreeBSD) |
| UNIX utilities | mosh, cmatrix, figlet, grc, nmap, toilet, tmux, tree, whois; Debian extras (bsdmainutils, sockstat, dnsutils, …); RedHat `util-linux-script`; FreeBSD coreutils/gnugrep/gsed/wget/sudo |
| `tmux-reattach` | Installed to `$bindir/tmux-reattach` — [Commands](commands.md) |
| X / www | xclip; links, w3m, lynx |
| Dev basics | autoconf, automake, git, colordiff, cmake, valgrind, jq, cppunit, the_silver_searcher (`ag`); clang/llvm/strace except FreeBSD (arcanist, hub there) |
| Languages | python3; Debian: tcl8.6-dev, php8.5; FreeBSD: tcl86, php85. Old php7.0 removed on Debian/FreeBSD |
| PHP stack | bcmath, gd, intl, mbstring, soap, xml, composer, pear, phpcs; Debian also curl + xsl |
| TCL | tcllib, tcltls |
| Spelling | verbiste, aspell-fr, aspell-en |
| Media CLI | exiftool, ImageMagick; cmus on Debian/FreeBSD |

On **Fedora that is not rolling-release**, Remi is enabled and PHP module `php:remi-8.5` is selected (creates `/etc/yum.repos.d/remi.repo`). Draugh skips this.

## Dev languages (`dev.sls`)

| Stack | Packages / actions |
| --- | --- |
| C/C++ | boost, cmocka, librabbitmq |
| Java | OpenJDK (17 on Debian, 21 on RedHat), ant, maven, openjfx |
| .NET | mono-devel; RedHat also `mono-tools` |
| Python | pip |
| Node | nodejs + npm; global npm: bower, browserify, gulp, grunt, jsonlint, react-tools |
| PHP | phpunit; Composer **2.8.8** phar at `/opt/composer.phar`, symlink `/usr/local/bin/composer` |
| Ruby | rubocop **except RedHat** |
| Rust (distro) | rustc/rust-all **package**, plus libpq + sqlite (for diesel). This is not rustup. |
| Shell | bats, shellcheck |
| TCL | rlwrap, tcllib, tcltls, tdom; tclsoap on FreeBSD |
| Web | memcached |
| Git extras | colordiff, git-lfs, git-review, git-subtree |
| pip (system) | `merge-dictionaries`, `resolve-hash` → `/usr/local/bin/…` |

## Ops (`ops.sls`)

`vault`, `ansible`, icedtea-web (Java Web Start).

## Misc (`misc.sls`)

| Area | Contents |
| --- | --- |
| VCS | cvs, fossil, subversion |
| Text | antiword, odt2txt, TeX Live (`texlive-full` on Debian/FreeBSD) |
| Security | pwgen, vault; aescrypt on FreeBSD |
| Tools | boxes, p7zip, rsync; Debian: dos2unix, gist; FreeBSD: unix2dos, gist, s3fs, gawk, primegen, cursive |
| Gadgets | binclock, ditaa; FreeBSD: asciiquarium, epte, weatherspect |
| Games | bsd-games; FreeBSD textmaze |
| Chrome history | `/usr/local/bin/chrome-monthly-history` |

FreeBSD-only extra: ports tooling (ccache, portmaster, poudriere, …), `pefs` kernel module, media codecs. `/etc/make.conf` is referenced from a **`roles/devserver/...` path that does not exist in this repo**.

## Desktop apps

See [Desktop and fonts](desktop.md).

## Pulsar

Linux: latest `.deb` or `.rpm` from `download.pulsar-edit.dev` if `/usr/bin/pulsar` is missing. Then `ppm install` each package in `pulsar_packages:<user>`.

For `dereckson`: `atom-jinja2`, `atom-salt`, `city-lights-icons`, `city-lights-syntax`, `city-lights-ui`, `editorconfig`, `language-tcl`.

## Psysh

PsySH **v0.12.8** extracted to `/opt/psysh`, mode 755, linked as `$bindir/psysh`. English PHP manual SQLite at `/usr/local/share/psysh/php_manual.sqlite`. Interactive REPL; `.zshrc` wraps it with `rlwrap` when rlwrap exists.

## Not applied: multimedia, kitro, rustup

| File | Would install | Status |
| --- | --- | --- |
| `multimedia.sls` | rhythmbox, pulseaudio-utils, vlc; optional G560 LED stack | not in `init.sls` |
| `kitro.sls` | clone wynter-kitro; `organize-folders`, `organize-screenshots` | not in `init.sls` |
| `rust.sls` | rustup stable+nightly, `diesel_cli` for users with those tasks | not in `init.sls` (tasks still listed in pillar) |
