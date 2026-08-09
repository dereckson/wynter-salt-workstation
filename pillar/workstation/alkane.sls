#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

alkane:
  domains:
    - lostwoods.drake

  sites:
    nasqueron-design-refresh.lostwoods.drake:
      domain: lostwoods.drake
      subdomain: nasqueron-design-refresh

      scripts:
        init: |
          #!/bin/sh
          set -e
          mkdir -p "$ALKANE_SITE_PATH"
          rsync -av --delete /home/dereckson/dev/nasqueron/sandbox/design-refresh/ "$ALKANE_SITE_PATH/"

        update: |
          #!/bin/sh
          set -e
          rsync -av /home/dereckson/dev/nasqueron/sandbox/design-refresh/ "$ALKANE_SITE_PATH/"
