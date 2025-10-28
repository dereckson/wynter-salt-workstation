#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if salt["node.has"]("i226") and grains["kernel"] == "Linux" %}

/usr/bin/restore-ethernet-controller:
  file.managed:
    - source: salt://roles/workstation/userland-software/files/scripts/restore-ethernet-controller.sh
    - mode: 755

{% endif %}
