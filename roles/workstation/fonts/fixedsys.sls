#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
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

#   -------------------------------------------------------------
#   fontconfig
#
#   Fixedsys Excelsior, falling back to Symbols Nerd Font
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/fonts/conf.d/51-fixedsys.conf:
  file.managed:
    - source: salt://roles/workstation/fonts/files/51-fixedsys.conf

fonts_reload_cache_fixedsys:
  cmd.run:
    - name: fc-cache -f
    - onchanges:
      - file: {{ dirs.etc }}/fonts/conf.d/51-fixedsys.conf
      - file: {{ dirs.fonts }}/fixedsys-excelsior/FSEX302-alt.ttf
