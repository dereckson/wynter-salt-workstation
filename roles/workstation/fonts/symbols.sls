#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Symbols Nerd Font
#
#   https://github.com/ryanoasis/nerd-fonts/
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.fonts }}/symbols-nerd-font:
  file.directory

{% set symbols_fonts = {
    "SymbolsNerdFont-Regular.ttf": "2839f0a572d4559f3f17a6fb74b8772e183f0c0a47150998ab194932cad55829",
    "SymbolsNerdFontMono-Regular.ttf": "fe471e538392f51910faab985fa8e192a39dd3426125edd15b71b3680df0e749",
} %}

{% for font, hash in symbols_fonts.items() %}
{{ dirs.fonts }}/symbols-nerd-font/{{ font }}:
  file.managed:
    - source: https://raw.githubusercontent.com/ryanoasis/nerd-fonts/v3.5.1/patched-fonts/NerdFontsSymbolsOnly/{{ font }}
    - source_hash: {{ hash }}
{% endfor %}

#   -------------------------------------------------------------
#   fontconfig
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/fonts/conf.d/10-nerd-font-symbols.conf:
  file.managed:
    - source: salt://roles/workstation/fonts/files/10-nerd-font-symbols.conf

fonts_reload_cache_symbols:
  cmd.run:
    - name: fc-cache -f
    - onchanges:
      - file: {{ dirs.etc }}/fonts/conf.d/10-nerd-font-symbols.conf
      {% for font in symbols_fonts %}
      - file: {{ dirs.fonts }}/symbols-nerd-font/{{ font }}
      {% endfor %}
