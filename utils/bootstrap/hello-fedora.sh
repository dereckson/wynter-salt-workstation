#!/bin/sh

#   -------------------------------------------------------------
#   Salt :: install on Fedora system
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   Reference:      https://saltproject.io/blog/salt-project-package-repo-migration-and-guidance/
#   Requires:       dnf5
#   Tested:         Fedora 42
#   Files touched:  /etc/dnf/repos.override.d/99-config_manager.repo
#                   /etc/yum.repos.d/salt.repo
#   Packages:       salt-minion
#   -------------------------------------------------------------

DEFAULT_SALT_REPO_ID=salt-repo-3006-lts
SALT_REPO_ID=salt-repo-latest

GIT_REPO_URL=https://github.com/dereckson/wynter-salt-workstation.git

#   -------------------------------------------------------------
#   Ensure user is root
#
#   Note: POSIX shells don't always define $UID or $EUID.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# shellcheck disable=SC3028
if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    echo "This command must be run as root." >&2
    exit 1
fi

#   -------------------------------------------------------------
#   Salt software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.repo > /etc/yum.repos.d/salt.repo
dnf clean expire-cache

if [ "$DEFAULT_SALT_REPO_ID" != "$SALT_REPO_ID" ]; then
    dnf config-manager setopt "$SALT_REPO_ID.enabled=1" "$DEFAULT_SALT_REPO_ID.enabled=0"
fi

dnf -y install salt-minion

#   -------------------------------------------------------------
#   Salt repository
#
#   Source: if run from repository, this repository as symlink
#           if not, a fresh clone
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ ! -d /srv/salt ] && [ ! -L /srv/salt ]; then
    command -v git >/dev/null 2>&1 || dnf install git
    if GIT_REPO_ROOT=$(git rev-parse --show-toplevel); then
        ln -s "$GIT_REPO_ROOT" /srv/salt
    else
        git clone "$GIT_REPO_URL" /srv/salt
    fi
fi

#   -------------------------------------------------------------
#   Salt configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

hostname -s > /etc/salt/minion_id

{
    echo "# Salt auto-generated configuration"
    echo "# Source: Wynter :: salt-workstation :: utils :: hello-fedora"
    echo ""
    echo "file_roots:"
    echo "  base:"
    echo "    - /srv/salt"
    echo ""
    echo "pillar_roots:"
    echo "  base:"
    echo "    - /srv/salt/pillar"
} > /etc/salt/minion
