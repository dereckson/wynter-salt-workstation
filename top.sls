#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-10-25
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

base:
  '*':
    - roles/core
  'orin':
    - roles/workstation
    - roles/fedora-dev
  'graywell':
    - roles/workstation
  'tigraki':
    - roles/workstation
