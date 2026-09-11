#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2018-03-22
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   FixedSys Excelsior
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.fonts }}/fixedsys-excelsior:
  file.directory

{{ dirs.fonts }}/fixedsys-excelsior/FSEX300.ttf:
  file.absent

{{ dirs.fonts }}/fixedsys-excelsior/FSEX302-alt.ttf:
  file.managed:
    - source: https://github.com/kika/fixedsys/releases/download/v3.09.10/FSEX302-alt.ttf
    - source_hash: 21b801fe4179dc884a9836d1fbd570ce83249d77204a0a017fbae14aa2dea132
