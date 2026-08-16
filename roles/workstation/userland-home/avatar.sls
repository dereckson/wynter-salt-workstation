#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/var/lib/AccountsService/.salt:
  file.directory

{% for username, user_properties in salt['pillar.get']("users", {}).items() %}
{% if "avatar" in user_properties %}

{% set avatar_target_path = "/var/lib/AccountsService/.salt/" + username + "-avatar.png" %}
{% set uid = salt["user.info"](username)["uid"] %}

/home/{{ username }}/.face:
  file.symlink:
    - user: {{ username }}
    - group: {{ username }}
    - target: {{ user_properties["avatar"] }}

avatar_file_{{ username }}:
  file.managed:
    - name: {{ avatar_target_path }}
    - source: {{ user_properties["avatar"] }}
    - user: root
    - group: root
    - mode: 644

set_avatar_{{ username }}:
  cmd.run:
    - name: >
        busctl call
        org.freedesktop.Accounts
        /org/freedesktop/Accounts/User{{ uid }}
        org.freedesktop.Accounts.User
        SetIconFile
        s {{ avatar_target_path }}
    - onchanges:
      - file: avatar_file_{{ username }}

{% endif %}
{% endfor %}
