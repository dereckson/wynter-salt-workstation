#   -------------------------------------------------------------
#   Salt — Provision a small local network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Created:        2017-10-25
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Users oo apply the userland states to
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

users:
  dereckson:
    tasks:
      # Shell
      - install_pm

      # Rust
      - install_rustup
      - install_diesel

    wallpapers:
      apps:
        collection: Apps
        items:
          dark-muted-grunge-scifi.jpg: https://raw.githubusercontent.com/dereckson/assets.dereckson.be/refs/heads/main/img/terminal/dark-muted-grunge-scifi-02.jpg
          futuristic.jpg: https://raw.githubusercontent.com/dereckson/assets.dereckson.be/refs/heads/main/img/terminal/futuristic.jpg
