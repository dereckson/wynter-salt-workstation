#   -------------------------------------------------------------
#   Salt — Belgian eID
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-10-25
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages, dirs with context %}

#   -------------------------------------------------------------
#   Repository
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains["os"] == "Debian" %}

eid_repo:
  cmd.run:
    - name: |
          wget https://eid.belgium.be/sites/default/files/software/eid-archive_latest.deb
          dpkg -i eid-archive_latest.deb
          rm -f eid-archive_latest.deb
    - cwd: /tmp
    - creates: /etc/apt/sources.list.d/eid.list

{% endif %}

{% if grains["os"] == "Fedora" %}

eid_repo:
  cmd.run:
    - name: |
          wget https://eid.belgium.be/sites/default/files/software/eid-archive-fedora-2021-1.noarch.rpm
          rpm -i eid-archive-fedora-2021-1.noarch.rpm
          rm -f eid-archive-fedora-2021-1.noarch.rpm
    - cwd: /tmp
    - creates: /etc/yum.repos.d/eid-archive.repo

{% endif %}

#   -------------------------------------------------------------
#   Software required
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

eid_software:
  pkg.installed:
    - pkgs:
      - eid-mw
      - eid-viewer
      - {{ packages['nss-tools'] }}

#   -------------------------------------------------------------
#   Chromium
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains["os"] == "Debian" %}
{% set libdir = "/usr/lib/x86_64-linux-gnu" %}
{% else %}
{% set libdir = dirs["lib"] %}
{% endif %}

{% for user in salt['pillar.get']("users", []) %}
{% set home = dirs.home + "/" + user %}
eid_chromium_setup_for_{{ user }}:
  cmd.run:
    - name: |
          mkdir -p .pki/nssdb
          chmod 700 .pki/nssdb
          certutil -d .pki/nssdb -N --empty-password
          modutil -force -add "Belgium eID" \
              -libfile {{ libdir }}/libbeidpkcs11.so.0 \
              -dbdir sql:.pki/nssdb
    - cwd: {{ home }}
    - runas: {{ user }}
    - creates: {{ home }}/.pki/nssdb/pkcs11.txt
    - requires:
        pkg: eid_software
{% endfor %}
