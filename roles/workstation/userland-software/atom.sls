#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-11-17
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Atom packages
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for user in salt['pillar.get']("users", []) %}
{% set home = dirs.home + "/" + user %}

{% for package in salt['pillar.get']("atom_packages:" + user, []) %}
atom_package_{{ package }}:
  cmd.run:
    - name: apm install {{ package }}
    - runas: {{ user }}
    - creates: {{ home }}/.atom/packages/{{ package }}
{% endfor %}

{% endfor %}
