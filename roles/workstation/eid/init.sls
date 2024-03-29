#   -------------------------------------------------------------
#   Salt — Belgian eID
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-10-25
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages, dirs with context %}

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

{% for user in salt['pillar.get']("users", []) %}
{% set home = dirs.home + "/" + user %}
eid_chromium_setup_for_{{ user }}:
  cmd.run:
    - name: |
          mkdir -p .pki/nssdb
          chmod 700 .pki/nssdb
          certutil -d .pki/nssdb -N --empty-password
          modutil -force -add "Belgium eID" \
              -libfile {{ dirs.lib }}/libbeidpkcs11.so.0 \
              -dbdir sql:.pki/nssdb
    - cwd: {{ home }}
    - runas: {{ user }}
    - creates: {{ home }}/.pki/nssdb/pkcs11.txt
{% endfor %}
