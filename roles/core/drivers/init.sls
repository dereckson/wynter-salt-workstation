#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-11-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  {% if grains['os'] == 'FreeBSD' %}
  - .freebsd
  {% endif %}
