#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-11-17
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Atom repository
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os_family'] == 'RedHat' %}

atom_gpgkey:
  cmd.run:
    - name: rpm --import https://packagecloud.io/AtomEditor/atom/gpgkey

/etc/yum.repos.d/atom.repo:
  file.managed:
    - source: salt://roles/workstation/userland-software/files/atom.repo

{% endif %}

#   -------------------------------------------------------------
#   Atom software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

atom:
  pkg.installed

#   -------------------------------------------------------------
#   Atom packages
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for user in salt['pillar.get']("users", []) %}
{% set home = dirs.home + "/" + user %}

{% for package in salt['pillar.get']("atom_packages:" + user, []) %}
atom_package_{{ package }}:
  cmd.run:
    - name: apm install {{ package }}
    - runas: {{ user }}
    - creates: {{ home }}/.atom/packages/{{ package }}
{% endfor %}

{% endfor %}
