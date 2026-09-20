# Desktop and fonts

Applies on the `workstation` role unless noted. GNOME text scaling is gated on the `desktop` node flag (`core` does not set a DE).

## Packages

| Group | Packages |
| --- | --- |
| Environment | `guake`; on FreeBSD also `gnome3` and `xorg` |
| Browsers | `chromium`, `firefox` |
| Apps | `calibre`, `filezilla`, `gedit`, `stellarium`, `terminator` |

No GNOME Shell / mutter / gdm package list is declared for Linux — the tree assumes a desktop is already there (typical Fedora Workstation install).

## GNOME text scaling

If `nodes:<id>.desktop` exists, Salt runs for every pillar user:

```bash
gsettings set org.gnome.desktop.interface text-scaling-factor <factor>
```

with `DBUS_SESSION_BUS_ADDRESS` / `XDG_RUNTIME_DIR` pointed at that user’s session bus. Default factor is `1.0` if the key is missing; BlueDrake sets **`1.25`**.

The command is skipped when gsettings already reports that value. It requires a running user session (the bus socket must exist).

## Terminator (user `dereckson`)

Deployed via `file.recurse` of `roles/workstation/userland-home/files/dereckson/` into `$HOME` (not cleaned; extra files you add are kept).

`~/.config/terminator/config`:

| Profile | Background | Font |
| --- | --- | --- |
| `default` | solid, wallpaper path unused for bg type | Fixedsys Excelsior 12 |
| `WindRiver` | image, 77% darkness, `Pictures/Wallpapers/Apps/futuristic.jpg` | Fixedsys Excelsior 12 |
| `Local` | image, 47% darkness, `dark-muted-grunge-scifi.jpg` | Fixedsys Excelsior 12 |

Global: focus-follows-mouse, maximised window, infinite scrollback, copy-on-selection, PuTTY paste from clipboard. Plugins include `ResolveHashURLHandler` (pairs with the `resolve-hash` tool).

Wallpapers are downloaded only if missing (`replace: False`) from `users.dereckson.system_pictures`.

## Avatar and pictures

For each pillar user:

- `system_pictures` collections are created under `~/Pictures/<collection>/` and files fetched by URL.
- If `avatar` is set, `~/.face` is a symlink to that path (AccountsService / GDM face).

Current `dereckson` data:

| Key | Path / source |
| --- | --- |
| `avatar` | `/home/dereckson/Pictures/Avatars/LoupDereckson/loup_avatar-225.jpg` |
| Wallpapers | `dark-muted-grunge-scifi.jpg`, `futuristic.jpg` from `assets.dereckson.be` |
| Avatars | `loup_avatar-225.jpg`, `OeilDeNuit.jpg` |

## Fonts

`roles/workstation/fonts` installs three families system-wide and runs `fc-cache -f` when files change.

### Cozette v1.30.0

Bitmap programming font with Nerd Font symbols ([the-moonwitch/Cozette](https://github.com/the-moonwitch/Cozette)). Files under the OS fonts dir (`/usr/share/fonts/cozette` on Linux):

- `cozette.otb`, `cozette_hidpi.otb`
- `CozetteVector.ttf`, `CozetteVectorBold.ttf`

### Fixedsys Excelsior 3.02 alt

`FSEX302-alt.ttf` from [kika/fixedsys](https://github.com/kika/fixedsys) v3.09.10. Older `FSEX300.ttf` is **removed** if present.

fontconfig `51-fixedsys.conf`: family **Fixedsys Excelsior** falls back to **Symbols Nerd Font Mono**, then **Symbols Nerd Font**.

Terminator is configured to use `Fixedsys Excelsior 12`.

### Symbols Nerd Font v3.5.1

`SymbolsNerdFont-Regular.ttf` and `SymbolsNerdFontMono-Regular.ttf` from nerd-fonts. `10-nerd-font-symbols.conf` prefers Symbols Nerd Font as a fallback for a long list of mono families (Fira Code, JetBrains Mono, Hack, …).

## Home files that are *not* desktop UI

Also recursed into `$HOME` for `dereckson`:

- `~/.config/resolve-hash.conf` — Gerrit base `https://gerrit.wikimedia.org/r/`
- `~/.config/merge-dictionaries.conf` — git remote `git@github.com:dereckson/wynter-dictionary.git`
- `~/bin/git-*` helpers — [Git helpers](git.md)

`roles/core/home` also recurses `roles/core/home/files/dereckson/`, currently only `~/.config/organize/folders.yml` (file is **intentionally blank**). The organize CLI is in `kitro.sls`, which is **not included** in the workstation software role.

## Synergy start script (not deployed)

`roles/workstation/userland-home/files/start.sh.jinja` would launch `synergys` or `synergyc` depending on `is_synergy_server`. It sits outside any `files/<username>/` tree, so `homefiles.sls` does not install it. Core home templating expects Jinja context for Synergy but has no `start.sh` in that files directory. Treat Synergy as **configured in pillar only** until that wiring is fixed.
