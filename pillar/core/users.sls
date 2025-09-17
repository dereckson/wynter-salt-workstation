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
