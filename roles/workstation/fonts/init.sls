#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2018-03-22
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Atom packages
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.fonts }}/fixedsys-excelsior:
  file.directory

{{ dirs.fonts }}/fixedsys-excelsior/FSEX300.ttf:
  file.managed:
    - source: http://www.fixedsysexcelsior.com/fonts/FSEX300.ttf
    - source_hash: 6ee0f3573bc5e33e93b616ef6282f49bc0e227a31aa753ac76ed2e3f3d02056d
