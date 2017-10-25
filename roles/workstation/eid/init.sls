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
    - name: modutil -dbdir sql:.pki/nssdb -add "Belgium eID" -libfile {{ dirs.lib }}/libbeidpkcs11.so.0
    - cwd: {{ home }}
    - runas: {{ user }}
    - creates: {{ home }}/.pki/nssdb/pkcs11.txt
{% endfor %}
