#   -------------------------------------------------------------
#   pm
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   Software:       Angelmmiguel/pm
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Global installation
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

pm_shell_utilities_directory:
  file.directory:
    - name: /opt/shell_utilities
    - makedirs: True

pm_repository:
  git.latest:
    - name: "https://github.com/Angelmmiguel/pm.git"
    - target: /opt/shell_utilities/pm

/usr/local/share/zsh/site-functions/_pm:
  file.symlink:
    - target: /opt/shell_utilities/pm/zsh/_pm
    - makedirs: True

/usr/local/share/zsh/wynter/pm/pm.zsh:
  file.symlink:
    - target: /opt/shell_utilities/pm/zsh/pm.zsh
    - makedirs: True

#   -------------------------------------------------------------
#   Per-user installation
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for username, user_properties in salt['pillar.get']("users", {}).items() %}
{% if "install_pm" in user_properties["tasks"] %}

/home/{{ username }}/.pm:
  file.directory:
    - user: {{ username }}

{% endif %}
{% endfor %}
