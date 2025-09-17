#   -------------------------------------------------------------
#   Install AMD ROCm Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages, packages_prefixes with context %}

{% if grains["os_family"] == "RedHat" %}
rocm_repo:
  pkgrepo.managed:
    - name: 'https://repo.radeon.com/rocm/fedora/rocm.repo'
    - file: '/etc/yum.repos.d/rocm.repo'
    - gpgcheck: 1
    - gpgkey: 'https://repo.radeon.com/rocm/rocm.gpg.key'
    - refresh: True

rocm_path:
  file.append:
    - name: /etc/profile.d/rocm.sh
    - text: |
        export PATH=/opt/rocm/bin:$PATH
        export LD_LIBRARY_PATH=/opt/rocm/lib:$LD_LIBRARY_PATH
{% endif %}

rocm_packages:
  pkg.installed:
    - pkgs:
      - {{ packages.rocm }}
      - rocm-opencl
      - hipblas
      - cmake
      - git
      - make
      - gcc-c++
      - python3
      - {{ packages_prefixes.python3 }}pip
