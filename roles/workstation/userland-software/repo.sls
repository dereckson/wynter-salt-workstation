#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Repositories for CentOS
#
#   :: EPEL
#   -------------------------------------------------------------

{% if grains['os'] == 'CentOS' %}
epel-release:
  pkg.installed
{% endif %}


#   -------------------------------------------------------------
#   Repositories for Fedora
#
#   :: Copr (Cool Other Package Repo)
#   :: RPM Fusion
#   -------------------------------------------------------------

{% if grains['os'] == 'Fedora' %}

{% for repository in pillar['repositories']['copr'] %}
enable_copr_{{ repository }}:
  cmd.run:
    - name: dnf copr -y -q enable {{ repository }}
    - creates: /etc/yum.repos.d/_copr:copr.fedorainfracloud.org:{{ repository | replace("/", ":") }}.repo
{% endfor %}

{% for flavour in pillar['repositories']['rpmfusion'] %}
enable_rpmfusion_{{ flavour }}:
  cmd.run:
    - name: dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-{{ flavour }}-release-{{ grains['osrelease'] }}.noarch.rpm
    - creates: /etc/yum.repos.d/rpmfusion-{{ flavour }}.repo
{% endfor %}

{% for flavour in pillar['repositories']['rpmfusion_extra'] %}
enable_rpmfusion_{{ flavour }}:
  cmd.run:
    - name: dnf install -y rmpfusion-{{ flavour }}
    - creates: /etc/yum.repos.d/rpmfusion-{{ flavour | replace("-release", "") }}.repo
{% endfor %}

{% if salt['node.has']('rollingRelease') %}
{% for flavour in pillar['repositories']['rpmfusion_rawhide'] %}
enable_rpmfusion_{{ flavour }}:
  cmd.run:
    - name: dnf install -y rmpfusion-{{ flavour }}
    - creates: /etc/yum.repos.d/rpmfusion-{{ flavour | replace("-release", "") }}.repo
{% endfor %}
{% endif %}

{% for repo_name, url in pillar['repositories']['third_party_as_repo'].items() %}
enable_repo_{{ repo_name }}:
  cmd.run:
    - name: dnf config-manager --add-repo {{ url }}
    - creates: /etc/yum.repos.d/{{ repo_name }}.repo
{% endfor %}

{% for repo_name, url in pillar['repositories']['third_party_as_rpm'].items() %}
enable_repo_{{ repo_name }}:
  cmd.run:
    - name: dnf install -y {{ url }}
    - creates: /etc/yum.repos.d/{{ repo_name }}.repo
{% endfor %}

{% endif %}
