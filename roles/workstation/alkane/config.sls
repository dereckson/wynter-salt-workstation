#   -------------------------------------------------------------
#   Salt — Alkane
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/usr/local/etc/alkane.conf:
  file.managed:
    - contents: |
        roots:
          db: /var/db/alkane
          sites: /var/wwwroot
          recipes: /usr/local/libexec/alkane

        site_directory_template: "%domain%.%tld%/%subdomain%"
    - makedirs: True
    - mode: 644

/var/db/alkane:
  file.directory
