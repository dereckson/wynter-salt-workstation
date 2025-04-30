#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-10-20
#   License:        Trivial work, not eligible to copyright
#   Keep in sync:   rOPS roles/devserver/userland-software/misc.sls
#   -------------------------------------------------------------

{% from "map.jinja" import packages, packages_prefixes with context %}

devserver_software_misc_vcs:
  pkg:
    - installed
    - pkgs:
      # VCS
      - cvs
      - fossil
      - subversion

{% if grains['os'] == 'FreeBSD' %}
devserver_software_misc_media:
  pkg:
    - installed
    - pkgs:
      - ffmpeg2theora
      - opencore-amr
      - opus
      - speex
      - speexdsp
      - x265
{% endif %}

devserver_software_misc_text_processing:
  pkg:
    - installed
    - pkgs:
      - antiword
      - odt2txt
      - {{ packages.texlive }}

{% if grains['os'] == 'Debian' %}
vault_repository_key:
  cmd.run:
    - name: |
        wget -O - https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
    - creates: /usr/share/keyrings/hashicorp-archive-keyring.gpg

/etc/apt/sources.list.d/hashicorp.list:
  file.managed:
    - source: salt://roles/workstation/userland-software/files/hashicorp.list
    - template: jinja
    - context:
        arch: {{ grains.osarch }}
        oscodename: {{ grains.oscodename }}
{% endif %}

devserver_software_misc_security:
  pkg:
    - installed
    - pkgs:
      {% if grains['os'] == 'FreeBSD' %}
      - aescrypt
      {% endif %}
      - pwgen
      - vault

devserver_software_misc_tools:
  pkg:
    - installed
    - pkgs:
      - boxes
      - p7zip
      - rsync

      {% if grains['os'] == 'Debian' %}
      # as unix2dos isn't packaged for Debian
      - dos2unix
      - gist
      {% endif %}

      {% if grains['os'] == 'FreeBSD' %}
      - cursive
      - gist
      - unix2dos
      - fusefs-s3fs
      - gawk
      - primegen
      {% endif %}

{% if grains['os'] == 'FreeBSD' %}
devserver_software_misc_ports:
  pkg:
    - installed
    - pkgs:
      - ccache
      - portmaster
      - portshaker
      - porttools
      - poudriere
      - portsearch

portsearch_database:
  cmd.run:
    - name: portsearch -u
    - creates: /var/db/portsearch
    - require:
      - pkg: devserver_software_misc_ports

/etc/make.conf:
  file.managed:
    - source: salt://roles/devserver/userland-software/files/make.conf

freebsd_kernel_modules:
  pkg.installed:
    - pkgs:
      - pefs-kmod

freebsd_kernel_modules_enable:
  module.wait:
    - name: freebsdkmod.load
    - mod: pefs
    - persist: True
    - watch:
        - pkg: freebsd_kernel_modules
{% endif %}

devserver_software_misc_gadgets:
  pkg:
    - installed
    - pkgs:
      - binclock
      - ditaa
      {% if grains['os'] == 'FreeBSD' %}
      - asciiquarium
      - epte
      - weatherspect
      {% endif %}

devserver_software_misc_games:
  pkg:
    - installed
    - pkgs:
      - {{ packages.bsdgames }}
      {% if grains['os'] == 'FreeBSD' %}
      - textmaze
      {% endif %}

{% if grains['os'] == 'FreeBSD' %}
devserver_software_misc_network:
  pkg:
    - installed
    - pkgs:
      - getdns
      {% endif %}
