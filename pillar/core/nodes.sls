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
    laptop: True
    g560: True
    rollingRelease: True
    amd_gpu: True
