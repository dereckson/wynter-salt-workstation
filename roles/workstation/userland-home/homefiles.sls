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
#   Wallpapers and other system pictures
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for username, user_properties in salt['pillar.get']("users", {}).items() %}
{% for _collection, args in user_properties.get("system_pictures", {}).items() %}

/home/{{ username }}/Pictures/{{ args["collection"] }}:
  file.directory:
    - makedirs: True
    - user: {{ username }}
    - group: {{ username }}

{% for filename, source in args.get("items", {}).items() %}
/home/{{ username }}/Pictures/{{ args["collection"] }}/{{ filename }}:
  file.managed:
    - source: {{ source }}
    - skip_verify: True
    - replace: False
    - user: {{ username }}
    - group: {{ username }}
{% endfor %}

{% endfor %}
{% endfor %}
