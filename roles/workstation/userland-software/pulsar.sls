#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-11-17
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Pulsar software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains["os"] == "Debian" %}
install_pulsar:
  cmd.run:
    - name: |
        wget -O pulsar_latest.deb "https://download.pulsar-edit.dev/?os=linux&type=linux_deb"
        dpkg -i pulsar_latest.deb
        rm -f pulsar_latest.deb
    - creates: /usr/bin/pulsar
    - cwd: /tmp
{% endif %}

{% if grains["os_family"] == "RedHat" %}
install_pulsar:
  cmd.run:
    - name: |
        wget -O pulsar_latest.rpm "https://download.pulsar-edit.dev/?os=linux&type=linux_rpm"
        dnf install ./pulsar_latest.rpm
        rm -f pulsar_latest.rpm
    - creates: /usr/bin/pulsar
    - cwd: /tmp
{% endif %}

#   -------------------------------------------------------------
#   Pulsar packages
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for user in salt['pillar.get']("users", []) %}
{% set home = dirs.home + "/" + user %}

{% for package in salt['pillar.get']("pulsar_packages:" + user, []) %}
pulsar_package_{{ package }}:
  cmd.run:
    - name: ppm install {{ package }}
    - runas: {{ user }}
    - creates: {{ home }}/.pulsar/packages/{{ package }}
{% endfor %}

{% endfor %}
