# Wynter workstation

Wynter is a **SaltStack tree for a personal ops/dev workstation**, not a server farm. It keeps a small forest of machines — currently named Yakin, BlueDrake, and Draugh — consistent: same shell, same editors, Belgian eID in Chromium, local DNS cache, fonts, git helpers, and the rest of the daily kit.

This site is a **user guide**. It describes what Salt puts on the machine, which commands and services you actually run, and which pillar keys turn features on. It is not a handbook for authoring new states.

<div class="grid cards" markdown>

-   **Getting started**

    ---

    How this tree is wired to Salt, and what is (and is not) documented as a runbook.

    [Open →](getting-started.md)

-   **Shell & desktop**

    ---

    Zsh, aliases, Starship, Terminator, fonts, avatars.

    [Shell →](shell.md) · [Desktop →](desktop.md)

-   **Commands & services**

    ---

    Custom binaries, git helpers, systemd units, Docker containers.

    [Commands →](commands.md) · [Services →](services.md)

-   **Pillar options**

    ---

    If you want a feature, set the matching node or user key.

    [Pillar →](pillar.md)

</div>

## What you get

A Wynter workstation is a **dev / SSH / browser machine**. The `workstation` role layers on top of `core` (applied to every minion in this tree):

| Layer | Role | Typical contents |
| --- | --- | --- |
| Every machine | `core` | Zsh, home-file templates, audio/Bluetooth/Razer drivers, Unbound DNS |
| Dev workstation | `workstation` | Packages, eID, fonts, Pulsar, Alkane site recipes, Ollama |
| RPM packaging | `fedora-dev` | `dnf-utils`, SELinux analysis tools (BlueDrake, Draugh) |
| Windows | `cygwin-workstation` | Cygwin + Chocolatey kit — **not assigned to any host in `top.sls`** |

Hosts are selected in the state top file by minion id (`bluedrake`, `draugh`, `yakin`). Feature flags live in pillar under `nodes:<id>` (laptop, AMD GPU, Logitech G560, and so on). See [Known machines](machines.md).

## Design assumptions

- You are comfortable on Linux (Fedora is the best-exercised path; Debian and FreeBSD mappings exist).
- Salt runs against this tree as file root `/srv/salt` and pillar root `/srv/salt/pillar`.
- The primary Unix account in pillar is `dereckson`. Userland (dotfiles, eID NSS DB, Pulsar packages, `~/bin` helpers) is applied to accounts listed under `users`.
- Several states exist in the tree but are **not included** from a role `init.sls`. Those are called out in the pages that mention them rather than documented as if they were live.

## This documentation

Built against git **`7dc0346`** — *Cap audio volume to avoid accidental maxing* (`7dc0346fcc88f69591f02ba5c238136726479d52`). See [About these docs](about.md) for the baseline, and `DOCS_NOTES.md` at the repository root for open questions from this first pass.

Serve a local copy:

```bash
python3 -m pip install -r requirements-docs.txt
mkdocs serve
```
