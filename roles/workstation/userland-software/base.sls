#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2016-04-09
#   License:        Trivial work, not eligible to copyright
#   Keep in sync:   rOPS roles/shellserver/userland-software/base.sls
#   -------------------------------------------------------------

{% from "map.jinja" import packages, packages_prefixes with context %}

#   -------------------------------------------------------------
#   Shells
#   -------------------------------------------------------------

shells:
  pkg:
    - installed
    - pkgs:
      - bash
      - zsh
      {% if grains['os'] != 'FreeBSD' %}
      - tcsh
      {% endif %}

/usr/local/share/zsh/site-functions/_pm:
  file.managed:
    # At commit 683d331 - 2017-11-05
    - source: https://raw.githubusercontent.com/Angelmmiguel/pm/master/zsh/_pm
    - source_hash: deea33968be713cdbd8385d3a72df2dd09c444e42499531893133f009f0ce0ea

    - makedirs: True

#   -------------------------------------------------------------
#   Editors
#
#   Disclaimer: We don't caution the views of Richard Stallman
#   or the Church of Emacs positions.
#   See http://geekfeminism.wikia.com/wiki/EMACS_virgins_joke
#   -------------------------------------------------------------

editors:
  pkg:
    - installed
    - pkgs:
      - vim
      - nano
      - joe
      - {{ packages.emacs }}

#   -------------------------------------------------------------
#   General UNIX utilities
#   -------------------------------------------------------------

utilities:
  pkg:
    - installed
    - pkgs:
      - mosh
      - cmatrix
      - figlet
      - grc
      - nmap
      - toilet
      - tmux
      - tree
      - whois
      {% if grains['os_family'] == 'Debian' %}
      - bsdmainutils
      - sockstat
      - dnsutils
      - sysvbanner
      - toilet-fonts
      {% endif %}
      {% if grains['os'] == 'FreeBSD' %}
      - figlet-fonts
      - bind-tools
      - sudo
      - coreutils
      - gnugrep
      - gsed
      - wget
      {% endif %}

utilities_xorg:
  pkg:
    - installed
    - pkgs:
      - xclip

utilities_www:
  pkg:
    - installed
    - pkgs:
      - links
      - w3m
      - lynx

#   -------------------------------------------------------------
#   Development
#   -------------------------------------------------------------

dev:
  pkg:
    - installed
    - pkgs:
      - autoconf
      - automake
      - git
      - colordiff
      - cmake
      - valgrind
      - jq
      - {{ packages.cppunit }}
      - {{ packages.ag }}
      {% if grains['os'] == 'FreeBSD' %}
      - arcanist
      - hub
      {% else %}
      - clang
      - llvm
      - strace
      {% endif %}

{% if grains['os_family'] == 'Debian' %}
dev_popular_libs:
  pkg:
    - installed
    - pkgs:
      - libssl-dev
{% endif %}

#   -------------------------------------------------------------
#   Languages
#   -------------------------------------------------------------

{% if grains['os'] == 'Fedora' and not salt['node.has']('rollingRelease') %}

enable_remi_repository:
  cmd.run:
    - name: |
        dnf install -y http://rpms.remirepo.net/fedora/remi-release-{{ grains['osrelease'] }}.rpm
        dnf module -y reset php
        dnf config-manager --set-enabled remi
    - creates: /etc/yum.repos.d/remi.repo
{% endif %}

# TODO: test if dnf install php works or if we need to specify the module:
# dnf module -y install php:remi-8.1

languages_removed:
  pkg:
    - removed
    - pkgs:
      {% if grains['os_family'] == 'Debian' %}
      - php7.0
      {% elif grains['os'] == 'FreeBSD' %}
      - php70
      {% endif %}

languages:
  pkg:
    - installed
    - pkgs:
      - python3
      {% if grains['os_family'] == 'Debian' %}
      - tcl8.6-dev
      - php8.2
      {% elif grains['os'] == 'FreeBSD' %}
      - tcl86
      - php83
      {% endif %}

#   -------------------------------------------------------------
#   De facto standard libraries for languages
#   -------------------------------------------------------------

languages_libs:
  pkg:
    - installed
    - pkgs:
      # PHP
      - {{ packages_prefixes.php }}bcmath
      - {{ packages_prefixes.php }}gd
      - {{ packages_prefixes.php }}intl
      - {{ packages_prefixes.php }}mbstring
      - {{ packages_prefixes.php }}soap
      - {{ packages_prefixes.php }}xml
      - {{ packages.composer }}
      - {{ packages.pear }}
      - {{ packages.phpcs }}

      {% if grains['os_family'] == 'Debian' %}
      - {{ packages_prefixes.php }}curl
      - {{ packages_prefixes.php }}xsl
      {% endif %}

      # TCL
      - tcllib
      - {{ packages.tcltls }}

#   -------------------------------------------------------------
#   Spelling and language utilities
#   -------------------------------------------------------------

spelling:
  pkg:
    - installed
    - pkgs:
        - {{ packages.verbiste }}
        - {{ packages['aspell-fr'] }}
        - {{ packages['aspell-en'] }}

#   -------------------------------------------------------------
#   Media utilities
#   -------------------------------------------------------------

media:
  pkg:
    - installed
    - pkgs:
      - {{ packages.exiftool }}
      - {{ packages.imagemagick }}
      {% if grains['os_family'] == 'Debian' %}
      - cmus
      {% elif grains['os'] == 'FreeBSD' %}
      - cmus
      {% endif %}
