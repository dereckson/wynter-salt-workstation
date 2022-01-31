#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

multimedia:
  pkg.installed:
    - pkgs:
      - rhythmbox
      - pulseaudio-utils
      - vlc
