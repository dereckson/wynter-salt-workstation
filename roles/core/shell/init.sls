#   -------------------------------------------------------------
#   Salt — Zsh
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-10-26
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Software required
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

shell_software:
  pkg.installed:
    - pkgs:
      - zsh
      {% if grains['os'] != 'FreeBSD' %}
      - tcsh
      {% endif %}

{% for user in salt['pillar.get']("users", []) %}
{% set home = dirs.home + "/" + user %}
{{ home }}/.zshrc:
  file.managed:
    - source: salt://roles/core/shell/files/dot.zshrc
    - replace: False
{% endfor %}
