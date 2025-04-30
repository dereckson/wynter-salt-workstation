#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages, packages_prefixes with context %}

#   -------------------------------------------------------------
#   C/C++
#   -------------------------------------------------------------

devserver_software_dev_c:
  pkg:
    - installed
    - pkgs:
      - {{ packages.boost }}
      - {{ packages.cmocka }}
      - {{ packages.librabbitmq }}

#   -------------------------------------------------------------
#   Java
#   -------------------------------------------------------------

devserver_software_dev_java:
  pkg:
    - installed
    - pkgs:
      - {{ packages.openjdk }}
      - {{ packages.ant }}
      - maven
      - openjfx

#   -------------------------------------------------------------
#   .Net languages
#   -------------------------------------------------------------

devserver_software_dev_dotnet:
  pkg:
    - installed
    - pkgs:
      - {{ packages.mono }}

      {% if grains['os_family'] == 'RedHat' %}
      - mono-tools
      {% endif %}


#   -------------------------------------------------------------
#   Node
#   -------------------------------------------------------------

devserver_software_dev_node:
  pkg:
    - installed
    - pkgs:
      - {{ packages.node }}
      - {{ packages.npm }}

devserver_node_packages:
  npm.installed:
    - pkgs:
      - bower
      - browserify
      - gulp
      - grunt
      - jsonlint
      - react-tools
    - require:
      - pkg: devserver_software_dev_node

#   -------------------------------------------------------------
#   PHP
#   -------------------------------------------------------------

devserver_software_dev_php:
  pkg:
    - installed
    - pkgs:
      - {{ packages.phpunit }}

/opt/composer.phar:
  file.managed:
    - source: https://getcomposer.org/download/2.8.8/composer.phar
    - source_hash: fb2bdaa0b59572c8b07b3b4d64af72bf223beaf62b4a8ffdfe5c863d28fdd08a0e2c006db19e0fb988b4f05be4a61e56
    - mode: 0755

/usr/local/bin/composer:
  file.symlink:
    - target: /opt/composer.phar

#   -------------------------------------------------------------
#   Ruby
#   -------------------------------------------------------------

{% if grains['os_family'] != 'RedHat' %}

devserver_software_dev_ruby:
  pkg:
    - installed
    - pkgs:
      - {{ packages.rubocop }}

{% endif %}

#   -------------------------------------------------------------
#   Rust
#   -------------------------------------------------------------

devserver_software_dev_rust:
  pkg:
    - installed
    - pkgs:
      - {{ packages.rust }}

      # Needed by diesel
      - {{ packages.libpq }}
      - {{ packages.sqlite }}

#   -------------------------------------------------------------
#   Shell
#   -------------------------------------------------------------

devserver_software_dev_shell:
  pkg:
    - installed
    - pkgs:
      - bats
      - {{ packages.shellcheck }}

#   -------------------------------------------------------------
#   TCL
#   -------------------------------------------------------------

devserver_software_dev_tcl:
  pkg:
    - installed
    - pkgs:
      - rlwrap
      - tcllib
      - {{ packages.tcltls }}
      - {{ packages.tdom }}
      {% if grains['os'] == 'FreeBSD' %}
      - tclsoap
      {% endif %}

#   -------------------------------------------------------------
#   Web development
#   -------------------------------------------------------------

devserver_software_dev_web:
  pkg:
    - installed
    - pkgs:
      - memcached

#   -------------------------------------------------------------
#   Tools like code review utilities
#
#   Arcanist is installed in the Phabricator states
#   -------------------------------------------------------------

devserver_software_dev_misctools:
  pkg:
    - installed
    - pkgs:
      - colordiff
      - git-review
