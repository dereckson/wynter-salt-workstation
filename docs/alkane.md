# Local web sites (Alkane)

[Alkane](https://devcentral.nasqueron.org/) is treated as a **local PaaS** for vhost directories and deploy recipes. The workstation role always includes `roles/workstation/alkane`.

## Software is deliberately not installed

`alkane/software.sls` is empty on purpose:

> Alkane is generally developed and tested, so install it would create a conflict.

You are expected to run a checkout you are hacking on, not a Salt-pinned package.

## What Salt does install

### Account

Group **`web`**, GID **9003**.

### Config file

`/usr/local/etc/alkane.conf`:

```yaml
roots:
  db: /var/db/alkane
  sites: /var/wwwroot
  recipes: /usr/local/libexec/alkane

site_directory_template: "%domain%.%tld%/%subdomain%"
```

`/var/db/alkane` is created.

### Directory tree from pillar

For each entry in `alkane.domains`:

- `/var/wwwroot/<domain>` — gid `web`, mode 755
- `/var/log/www/<domain>` — gid `web`, mode 775

Parents `/var/wwwroot` and `/var/log/www` use the same ownership pattern.

### Recipes from pillar

For each `alkane.sites.<site_name>`:

- `/usr/local/libexec/alkane/<site_name>/init` — executable, body from `scripts.init`
- `…/update` — body from `scripts.update`

Alkane (when you run it) is configured to look for recipes under `/usr/local/libexec/alkane`. Environment variable used in the sample scripts: **`$ALKANE_SITE_PATH`**.

## Current pillar sample

`pillar/workstation/alkane.sls`:

| Key | Value |
| --- | --- |
| Domain | `lostwoods.drake` |
| Site id | `nasqueron-design-refresh.lostwoods.drake` |
| Subdomain | `nasqueron-design-refresh` |
| `init` | `mkdir` site path; `rsync -av --delete` from `~/dev/nasqueron/sandbox/design-refresh/` |
| `update` | `rsync -av` (no `--delete`) from the same tree |

That is a **worked example** for one sandbox site, not a generic CMS.

## Adding a site (user-facing pillar)

In `pillar/workstation/alkane.sls`:

```yaml
alkane:
  domains:
    - example.drake
  sites:
    app.example.drake:
      domain: example.drake
      subdomain: app
      scripts:
        init: |
          #!/bin/sh
          set -e
          mkdir -p "$ALKANE_SITE_PATH"
          # …
        update: |
          #!/bin/sh
          set -e
          # …
```

Re-apply the alkane states. Salt will not run `init`/`update` for you — it only writes the scripts and directories. Invoking Alkane itself is outside this tree.
