#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2018-03-22
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Cozette
#
#   Bitmap programming font with Nerd Font symbols
#   https://github.com/the-moonwitch/Cozette
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.fonts }}/cozette:
  file.directory

{% set cozette_fonts = {
    "cozette.otb": "cbcb83dc626b55eae5d79808a2db2fc87bdc0886b63d0226a5789968f8392d49",
    "cozette_hidpi.otb": "73a0edf52caacaf731b152706c49ac0e1d651fae1478cf9d3f178042bf7b6da4",
    "CozetteVector.ttf": "2d54a586f824f32d9d2dd01ec3b990c2a4d6445efa77e20177efe382ebe51627",
    "CozetteVectorBold.ttf": "9f113791362001d53cd4c09cbe91f9125c050ca7aab49d48393601e79b2b1d41",
} %}

{% for font, hash in cozette_fonts.items() %}
{{ dirs.fonts }}/cozette/{{ font }}:
  file.managed:
    - source: https://github.com/the-moonwitch/Cozette/releases/download/v.1.30.0/{{ font }}
    - source_hash: {{ hash }}
{% endfor %}
