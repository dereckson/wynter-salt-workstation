#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Repositories for Fedora
#
#   :: Copr (Cool Other Package Repo)
#   -------------------------------------------------------------

{% if grains['os'] == 'Fedora' %}

{% for repository in pillar['repositories']['copr'] %}
enable_copr_{{ repository }}:
  cmd.run:
    - name: dnf copr -y -q enable {{ repository }}
    - creates: /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:{{ repository | replace("/", ":") }}.repo
{% endfor %}

{% endif %}
