#   -------------------------------------------------------------
#   Salt — Fedora dev environment
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-11-13
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Software required
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

packages_build_software:
  pkg.installed:
    - pkgs:
      - perl-generators
