#   -------------------------------------------------------------
#   Salt — Zsh
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-10-26
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages with context %}

#   -------------------------------------------------------------
#   Software required
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

shell_software:
  pkg.installed:
    - pkgs:
      - zsh
      {% if grains['os'] != 'FreeBSD' %}
      - tcsh
      {% endif %}

{% for user in salt['pillar.get']("users", []) %}
{% set home = dirs.home + "/" + user %}
{{ home }}/.zshrc:
  file.managed:
    - source: salt://roles/core/shell/files/dot.zshrc
    - replace: False
    - user: {{ user }}
    - group: {{ user }}
{% endfor %}

#   -------------------------------------------------------------
#   Modules for zsh
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

shell_extra_utilities_directory:
  file.directory:
    - name: /opt/shell_utilities
    - makedirs: True

shell_extra_utilities:
  pkg.installed:
    - pkgs:
      - fzf
      - git
      - {{ packages.sqlite }}
      - starship
      - zoxide

zsh_histdb_repository:
  git.latest:
    - name: "https://github.com/larkery/zsh-histdb.git"
    - target: /opt/shell_utilities/zsh-histdb
