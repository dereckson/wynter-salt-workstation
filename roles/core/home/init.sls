#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-11-19
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Provision /home directories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for user in salt['pillar.get']("users", []) %}
{% set home = dirs.home + "/" + user %}

{{ home }}:
  file.recurse:
    - source: salt://roles/core/home/files/{{ user }}
    - template: jinja
    - user: {{ user }}
    - context:
        is_synergy_server: {{ grains['id'] == pillar['synergy_server']['id'] }}
        synergy_server: {{ pillar['synergy_server']['addr'] }}
        hostname: {{ grains['id'] }}
        etc: {{ dirs.etc }}

{% endfor %}
