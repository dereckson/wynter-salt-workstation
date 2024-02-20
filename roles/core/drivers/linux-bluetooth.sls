#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------


{% if grains['kernel'] == 'Linux' %}


#   -------------------------------------------------------------
#   Bluetooth
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt['node.has']('laptop') %}

bluez-tools:
  pkg.installed

{% endif %}


{% endif %}
