#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% for username, user_properties in salt['pillar.get']("users", {}).items() %}
{% if "avatar" in user_properties %}

/home/{{ username }}/.face:
  file.symlink:
    - user: {{ username }}
    - group: {{ username }}
    - target: {{ user_properties["avatar"] }}

{% endif %}
{% endfor %}
