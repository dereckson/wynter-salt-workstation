#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import services with context %}

{% if grains["kernel"] == "Linux" %}

pulseaudio-utils:
  pkg.installed

#   -------------------------------------------------------------
#   Volume cap
#
#   PipeWire/PulseAudio has no hard ceiling. Capacitive volume
#   strips (e.g. Logitech MX 5000) can slam the sink to 100%+.
#
#   The service is per user.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/bin/cap-volume:
  file.managed:
    - source: salt://roles/core/drivers/files/pulseaudio/cap-volume/cap-volume.sh
    - mode: 755

{% if services["manager"] == "systemd" %}

/etc/systemd/user/cap-volume.service:
  file.managed:
    - source: salt://roles/core/drivers/files/pulseaudio/cap-volume/cap-volume.service
    - mode: 644

/etc/systemd/user/default.target.wants/cap-volume.service:
  file.symlink:
    - target: /etc/systemd/user/cap-volume.service
    - makedirs: True

{% endif %}


{% endif %}
