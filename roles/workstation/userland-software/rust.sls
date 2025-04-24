#   -------------------------------------------------------------
#   Salt — Provision software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set triplet = salt['rust.get_rustc_triplet']() %}

{% for username, user_properties in salt['pillar.get']("users", {}).items() %}
{% set tasks = user_properties['tasks'] %}

#   -------------------------------------------------------------
#   Rustup
#
#   stable and nightly toolchains for current architecture
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if 'install_rustup' in tasks %}
{% set rustup_path = '/home/' + username + '/.cargo/bin/rustup' %}

install_rustup:
  cmd.run:
    - name: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    - runas: {{ username }}
    - creates: {{ rustup_path }}

{% for toolchain in ['stable', 'nightly'] %}
devserver_rustup_{{toolchain}}_{{username}}:
  cmd.run:
    - name: {{ rustup_path }} install {{ toolchain }}
    - runas: {{ username }}
    - creates: /home/{{ username }}/.rustup/toolchains/{{ toolchain }}-{{ triplet }}
{% endfor %}

{% endif %}

#   -------------------------------------------------------------
#   Diesel
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if 'install_diesel' in tasks %}
devserver_diesel_{{username}}:
  cmd.run:
    - name: /home/{{username}}/.cargo/bin/cargo install diesel_cli --no-default-features --features postgres,sqlite
    - runas: {{username}}
    - creates: /home/{{username}}/.cargo/bin/diesel
{% endif %}

{% endfor %}
