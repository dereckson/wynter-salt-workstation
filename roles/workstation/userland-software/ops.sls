#   -------------------------------------------------------------
#   Salt — Provision ops software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages, packages_prefixes with context %}

userland_software_ops:
  pkg.installed:
    - pkgs:
      - vault
      - ansible
