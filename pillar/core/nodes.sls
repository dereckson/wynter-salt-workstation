#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-10-25
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Forest nodes
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

nodes:
  yakin:
    laptop: True

  bluedrake:
    bluetooth: True
    g560: True
    i226: True
    rollingRelease: False
    is_synergy_server: True
    amd_gpu: True
