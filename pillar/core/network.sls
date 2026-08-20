#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

network:
  gateway: 172.27.26.100

  dns:
    - 9.9.9.9
    - 8.8.8.8
    - 1.1.1.1
    - 4.2.2.1
