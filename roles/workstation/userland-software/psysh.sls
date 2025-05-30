#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-03
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Prepare for installation
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/share/psysh:
  file.directory:
    - dir_mode: 755

#   -------------------------------------------------------------
#   Fetch software and PHP manual
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

psysh_software:
  archive.extracted:
    - name: /opt/psysh
    - enforce_toplevel: False
    - source: https://github.com/bobthecow/psysh/releases/download/v0.12.8/psysh-v0.12.8.tar.gz
    - source_hash: 3119a55735845612f889baff63a9b96d54e1f63c18d8426f685cd3055ed33a01

/usr/local/share/psysh/php_manual.sqlite:
  file.managed:
    - source: http://psysh.org/manual/en/php_manual.sqlite
    - skip_verify: True
    - require:
      - file: /usr/local/share/psysh

#   -------------------------------------------------------------
#   Install binary
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

psysh_permissions:
  file.managed:
    - name: /opt/psysh/psysh
    - mode: 755
    - require:
      - archive: psysh_software

{{ dirs.bin }}/psysh:
  file.symlink:
    - target: /opt/psysh/psysh
    - require:
      - file: psysh_permissions
