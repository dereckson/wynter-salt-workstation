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
      - cmocka
      - {{ packages.librabbitmq }}

#   -------------------------------------------------------------
#   Java
#   -------------------------------------------------------------

devserver_software_dev_java:
  pkg:
    - installed
    - pkgs:
      - openjdk8
      - apache-ant
      - maven
      - openjfx8-devel
      - openjfx8-scenebuilder
      - glassfish

#   -------------------------------------------------------------
#   .Net languages
#   -------------------------------------------------------------

devserver_software_dev_dotnet:
  pkg:
    - installed
    - pkgs:
      - mono

#   -------------------------------------------------------------
#   Node
#   -------------------------------------------------------------

devserver_software_dev_node:
  pkg:
    - installed
    - pkgs:
      - {{ packages.node }}
      - npm

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
    - source: https://getcomposer.org/download/2.2.5/composer.phar
    - source_hash: 81ef304a70c957d6f05a7659f03b00eb50df6155195f51118459b2e49c96c3f3
    - mode: 0755

/usr/local/bin/composer:
  file.symlink:
    - target: /opt/composer.phar

#   -------------------------------------------------------------
#   Python
#   -------------------------------------------------------------

devserver_software_dev_python:
  pkg:
    - installed
    - pkgs:
      - {{ packages_prefixes.python2 }}nltk
      - {{ packages_prefixes.python2 }}numpy
      - {{ packages_prefixes.python2 }}virtualenv

#   -------------------------------------------------------------
#   Ruby
#   -------------------------------------------------------------

devserver_software_dev_ruby:
  pkg:
    - installed
    - pkgs:
      - {{ packages_prefixes.rubygem }}rubocop

#   -------------------------------------------------------------
#   Rust
#   -------------------------------------------------------------

devserver_software_dev_rust:
  pkg:
    - installed
    - pkgs:
      - rust

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
      - hs-ShellCheck

#   -------------------------------------------------------------
#   TCL
#   -------------------------------------------------------------

devserver_software_dev_tcl:
  pkg:
    - installed
    - pkgs:
      - rlwrap
      - tcllib
      - tclsoap
      - {{ packages.tcltls }}
      - {{ packages.tdom }}

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
      - git-review
