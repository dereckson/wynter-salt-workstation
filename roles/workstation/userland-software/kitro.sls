#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

{% set kitro_dir = "/opt/wynter/kitro" %}

#   -------------------------------------------------------------
#   Kitro repository
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

kitro_repository:
  file.directory:
    - name: {{ kitro_dir }}
    - dir_mode: 0755
    - makedirs: True
  git.latest:
    - name: https://devcentral.nasqueron.org/source/wynter-kitro.git
    - branch: main
    - target: {{ kitro_dir }}

#   -------------------------------------------------------------
#   Organize
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.bin }}/organize-folders:
  file.symlink:
    - target: {{ kitro_dir }}/organize/organize-folders.py

{{ dirs.bin }}/organize-screenshots:
  file.symlink:
    - target: {{ kitro_dir }}/organize/organize-screenshots.sh
