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
