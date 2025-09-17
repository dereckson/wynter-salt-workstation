#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2020-01-30
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "./map.jinja" import chocolatey_packages %}

#   -------------------------------------------------------------
#   Chocolatey
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_choco:
  module.run:
    - chocolatey.bootstrap

#   -------------------------------------------------------------
#   Packages
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for package in chocolatey_packages %}
chocolatey_install_{{ package }}:
  chocolatey.installed:
    - name: {{ package }}
{% endfor %}
