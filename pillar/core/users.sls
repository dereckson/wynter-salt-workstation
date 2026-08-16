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

    system_pictures:
      wallpapers_apps:
        collection: Wallpapers/Apps
        items:
          dark-muted-grunge-scifi.jpg: https://raw.githubusercontent.com/dereckson/assets.dereckson.be/refs/heads/main/img/terminal/dark-muted-grunge-scifi-02.jpg
          futuristic.jpg: https://raw.githubusercontent.com/dereckson/assets.dereckson.be/refs/heads/main/img/terminal/futuristic.jpg

      avatar:
        collection: Avatars/LoupDereckson
        items:
          loup_avatar-225.jpg: https://raw.githubusercontent.com/dereckson/assets.dereckson.be/refs/heads/main/img/avatar/loup_avatar-225.jpg
          OeilDeNuit.jpg: https://raw.githubusercontent.com/dereckson/assets.dereckson.be/refs/heads/main/img/avatar/OeilDeNuit.jpg
