#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages with context %}

fonts_software:
  pkg.installed:
    - pkgs:
        # Utilities
        - fonttools

        # Fonts as packages
        - {{ packages["font-ibm-plex"] }}
