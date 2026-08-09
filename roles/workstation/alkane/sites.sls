#   -------------------------------------------------------------
#   Salt — Alkane
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Directories for web domains
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/wwwroot:
  file.directory:
    - makedirs: True
    - gid: web
    - mode: 755

/var/log/www/:
  file.directory:
    - makedirs: True
    - gid: web
    - mode: 775

{% for domain in pillar["alkane"]["domains"] %}
/var/wwwroot/{{ domain }}:
  file.directory:
    - gid: web
    - mode: 755

/var/log/www/{{ domain }}:
  file.directory:
    - gid: web
    - mode: 775
{% endfor %}

#   -------------------------------------------------------------
#   Alkane recipes
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/libexec/alkane:
  file.directory:
    - makedirs: True
    - mode: 755

{% for site_name, site in pillar["alkane"]["sites"].items() %}
/usr/local/libexec/alkane/{{ site_name }}:
  file.directory:
    - mode: 755

/usr/local/libexec/alkane/{{ site_name }}/init:
  file.managed:
    - contents_pillar: alkane:sites:{{ site_name }}:scripts:init
    - mode: 755

/usr/local/libexec/alkane/{{ site_name }}/update:
  file.managed:
    - contents_pillar: alkane:sites:{{ site_name }}:scripts:update
    - mode: 755
{% endfor %}
