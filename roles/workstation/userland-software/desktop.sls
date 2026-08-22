#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-11-19
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages, packages_prefixes with context %}

#   -------------------------------------------------------------
#   Desktop environment
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

desktop_environment:
  pkg.installed:
    - pkgs:
        - guake
        {% if grains['os'] == 'FreeBSD' %}
        - gnome3
        - xorg
        {% endif %}

desktop_browsers:
  pkg.installed:
    - pkgs:
        - chromium
        - firefox

desktop_applications:
  pkg.installed:
    - pkgs:
        - calibre
        - filezilla
        - gedit
        - stellarium
        - terminator

#   -------------------------------------------------------------
#   Per-user configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt["node.has"]("desktop") %}
{% for username in pillar["users"] %}

{% set text_scaling_factor = salt["node.get"]("desktop").get("text-scaling-factor", 1.0) %}
{% set uid = salt["user.info"](username)["uid"] %}

desktop_text_scaling_factor_{{ username }}:
  cmd.run:
    - name: gsettings set org.gnome.desktop.interface text-scaling-factor {{ text_scaling_factor }}
    - runas: {{ username }}
    - env:
        DBUS_SESSION_BUS_ADDRESS: unix:path={{ dirs.run }}/user/{{ uid }}/bus
        XDG_RUNTIME_DIR: {{ dirs.run }}/user/{{ uid }}
    - unless: test "$(gsettings get org.gnome.desktop.interface text-scaling-factor)" = "{{ text_scaling_factor }}"

{% endfor %}
{% endif %}
