# Documentation notes (first pass)

This file is for the human maintainer of the Wynter workstation docs, not for end users. The user-facing site lives under `docs/` (`mkdocs.yml`).

## Baseline

| Field | Value |
| --- | --- |
| SHA | `7dc0346fcc88f69591f02ba5c238136726479d52` |
| Short | `7dc0346` |
| Subject | Cap audio volume to avoid accidental maxing |
| Author date | Sat, 19 Sep 2026 23:57:53 +0200 |

Recorded again in `docs/about.md` and the MkDocs footer. Future passes should `git diff 7dc0346..HEAD` and update those three places.

## Ambiguities / questions

1. **Highstate command.** README + `hello-fedora.sh` never document `state.apply` / `state.highstate` or whether `salt-minion` should be enabled. Docs refuse to invent a runbook; confirm the intended local vs master workflow.

2. **`rust.sls`, `multimedia.sls`, `kitro.sls` are not included** from `roles/workstation/userland-software/init.sls`. Pillar still lists `install_rustup` / `install_diesel`; BlueDrake still has `g560`; core still deploys empty `organize/folders.yml`. Intentional WIP, or an oversight? Docs treat them as inactive on a normal apply.

3. **Synergy wiring looks unfinished.** `nodes.bluedrake.is_synergy_server` is unused. `synergy_server.id` is `orin`, not `bluedrake`. `start.sh.jinja` is not under `files/<user>/` and is never `file.managed`. Is Synergy supposed to start from an X session script, and which hostname is the server?

4. **`~/bin` not added to PATH** in the provisioned `.zshrc`. Git helpers and Cygwin `start` assume it. Does a desktop profile already inject it, or should zshrc do so?

5. **`.zkbd/$TERM` is required** and not generated. Is that an accepted first-login step, or should the rc guard `source`?

6. **`chrome-monthly-history` reads Google Chrome paths**, while the workstation installs **Chromium**. Is Chrome installed out of band, or should Chromium’s History path be added?

7. **Ollama always bind-mounts `/dev/kfd` and `/dev/dri`**, including the non-ROCm image. Does that fail on machines without AMD nodes (Yakin, Draugh)? Docker itself is not installed by Salt.

8. **NetworkManager DNS hook** uses `node.get("network:main_interface")` with no default. Only BlueDrake sets it. Does the `cmd.run` fail on other workstation minions when resolved.conf changes?

9. **`node.get_all_properties` errors if the minion id is missing from `nodes:`.** Core DNS/drivers call `node.has` / `node.get`. Applying core to a hostname not in pillar — does that blow up in practice?

10. **Fedora eID repo URLs disagree:** `repo.sls` / pillar third-party RPM is `eid-archive-fedora-2021-1`; `eid/init.sls` installs `2025-2`. Which should win?

11. **Cygwin `file.managed` source is `salt:/roles/...` (one slash).** Does the Windows minion resolve that? Role is also absent from `top.sls`.

12. **FreeBSD `misc.sls` manages `/etc/make.conf` from `salt://roles/devserver/userland-software/files/make.conf`**, a path that does not exist in this repository. Dead copy-paste from Nasqueron rOPS?

13. **`fedora.eid_repo_last_version`** raises `CommandExecutionError` and references `initial` / `floor` which are not defined in that function; `CommandExecutionError` is not imported. Only matters on Rawhide eID. Out of scope for user docs, but the Rawhide eID path may be fragile.

14. **Vault `VAULT_ADDR=https://127.0.0.1:8200`** with no server in-tree. Is a local Vault expected from another repo, or is the export leftover?

15. **`t` alias** expects a `t` task binary and `~/.tasks`. Not installed here. Still wanted?

16. **Alkane** config and recipes are deployed but the package is intentionally not installed. What command should a user type, and where does the binary live while developing it?

17. **`is_synergy_server` vs hostname `orin` vs BlueDrake** — also unclear whether `orin` is a machine that should appear in `top.sls` / `nodes:`.

18. **Starship package** comes from Copr `atim/starship` on Fedora and from `pkg.installed` in core shell. On Debian/FreeBSD, is `starship` in default repos?

## Intentional scope gaps (later pass)

- Per-package “why is this installed?” commentary for the long Cygwin list and the full nerd-fontconfig family list.
- Screenshots of Terminator profiles, eid-viewer, Pulsar, GNOME scaling.
- Upstream man-page duplication (Unbound, zoxide, Starship, Pulsar ppm, Ollama HTTP API).
- Maintainer/developer handbook (how to add a state, formula layout, CI). Explicitly out of scope.
- Nasqueron datacube / DevCentral / `arc` workflows beyond what the git wrappers already print.
- Windows Chocolatey/Cygwin verification (no host in top file).
- Translating `map.jinja` into a full Debian-vs-Fedora-vs-FreeBSD package matrix table.
- `utils/` disaster-recovery narrative beyond the script comments (ZFS layout, pool names).
- Secret/Vault operational procedures (none in repo).
- MkDocs hosting / GitHub Pages / versioned `mike` deploys.

## Engine

MkDocs Material, Rewild palette in `docs/stylesheets/rewild.css`. Build: `pip install -r requirements-docs.txt && mkdocs build`.
