#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages, packages_prefixes with context %}

#   -------------------------------------------------------------
#   General multimedia software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

multimedia:
  pkg.installed:
    - pkgs:
      - rhythmbox
      - pulseaudio-utils
      - vlc

#   -------------------------------------------------------------
#   Logitech G560
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt['node.has']('g560') %}

g560_led_dependencies:
  pkg.installed:
    - pkgs:
      - {{ packages_prefixes.python3 }}-pyusb
      - {{ packages_prefixes.python3 }}-gobject
      - {{ packages_prefixes.python3 }}-rpyc

g560_led_repo:
  file.directory:
    - name: /opt/logitech-g560-led
    - dir_mode: 0755
  git.latest:
    - name: https://github.com/mdoyleaz/Logitech-G560-LED-Controller.git
    - branch: master # This doesn't an endorsment of that name
    - target: /opt/logitech-g560-led

/usr/local/bin/g560-led:
  file.managed:
    - mode: 0755
    - contents: |
        #!/bin/sh

        cd /opt/logitech-g560-led
        python3 g560_gui.py

{% if services['manager'] == 'systemd' %}
g560_led_unit:
  file.managed:
    - name: /etc/systemd/system/g560.service
    - source: salt://roles/workstation/userland-software/files/g560.service
    - mode: 0644
  module.run:
    - service.force_reload:
      - name: g560
    - onchanges:
       - file: g560_led_unit

g560_led_running:
  service.running:
    - name: g560
    - enable: true
    - watch:
      - module: g560_led_unit
{% endif %}

{% endif %}
