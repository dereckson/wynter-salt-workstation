#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2020-01-30
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "./map.jinja" import packages %}

{% for package in packages %}
cygwin_install_{{ package }}:
  cyg.installed:
    - name: {{ package }}
{% endfor %}
