#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-11-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains['os'] == 'FreeBSD' %}

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

#   -------------------------------------------------------------
#   Webcam
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt['node.has']('laptop') %}

pwcview:
  pkg.installed

webcam_support_in_rc_conf:
  file.append:
    - name: /etc/rc.conf
    - text: |
        devfs_system_ruleset="system"
        webcamd_enable="YES"

cuse4bsd_support_in_boot_loader:
  file.append:
    - name: /boot/loader.conf
    - text: cuse4bsd_load="YES"

{% endif %}

{% endif %}
