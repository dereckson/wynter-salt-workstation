#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Dotfiles
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for username, user_properties in salt['pillar.get']("users", {}).items() %}
{% if salt["slsutil.dir_exists"]("roles/workstation/userland-home/files/" + username) %}

dotfiles_for_{{ username }}:
  file.recurse:
    - name: /home/{{ username }}
    - source: salt://roles/workstation/userland-home/files/{{ username }}
    - include_empty: True
    - clean: False
    - user: {{ username }}
    - group: {{ username }}

{% endif %}
{% endfor %}

#   -------------------------------------------------------------
#   Wallpapers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for username, user_properties in salt['pillar.get']("users", {}).items() %}
{% for collection, args in user_properties.get("wallpapers", {}).items() %}

/home/{{ username }}/Pictures/Wallpapers/{{ args["collection"] }}:
  file.directory:
    - makedirs: True
    - user: {{ username }}
    - group: {{ username }}

{% for filename, source in args.get("items", {}).items() %}
/home/{{ username }}/Pictures/Wallpapers/{{ args["collection"] }}/{{ filename }}:
  file.managed:
    - source: {{ source }}
    - skip_verify: True
    - replace: False
{% endfor %}


# /home/dereckson/Pictures/Wallpapers/Apps/futuristic.jpg
{% endfor %}
{% endfor %}
