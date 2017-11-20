#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-11-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Touchpad
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt['node.has']('laptop') %}

xf86-input-synaptics:
  pkg.installed

synaptics_support_in_boot_loader:
  file.append:
    - name: /boot/loader.conf
    - text: hw.psm.synaptics_support=1

{% endif %}
