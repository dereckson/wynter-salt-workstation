# About these docs

First-pass **user** documentation for the Wynter Salt workstation tree, generated as an MkDocs Material site.

## Baseline commit

Documentation in this pass was written against:

| | |
| --- | --- |
| Full SHA | `7dc0346fcc88f69591f02ba5c238136726479d52` |
| Short | `7dc0346` |
| Subject | Cap audio volume to avoid accidental maxing |
| Author date | Sat, 19 Sep 2026 23:57:53 +0200 |

If you extend the docs, diff the tree from that SHA and update this table.

## How to build

From the repository root:

```bash
python3 -m pip install -r requirements-docs.txt
mkdocs serve    # http://127.0.0.1:8000
mkdocs build    # output in site/
```

Theme: Material, light/dark palettes, **2027 Rewild** colours in `docs/stylesheets/rewild.css`.

## What this site is not

- Not a guide to writing or contributing Salt states
- Not an inventory of Nasqueron **servers** (README points at [devcentral OPS / devserver](https://devcentral.nasqueron.org/diffusion/OPS/) for that)
- Not a substitute for upstream man pages of vim, git, Unbound, Ollama, …

Open questions and intentional gaps: repository file `DOCS_NOTES.md`.
