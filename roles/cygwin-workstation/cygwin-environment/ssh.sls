#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2020-01-30
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/home/dereckson/bin/start:
  file.managed:
    - source: salt:/roles/cygwin-workstation/cygwin-environment/files/start
    - mode: 755
