#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-11-19
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages, packages_prefixes with context %}

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
        - stellarium
