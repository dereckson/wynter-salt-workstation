#!/bin/sh

#   -------------------------------------------------------------
#   ZFS :: import pools on rescue live CD
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   Description:    A pool can be used as root filesystem and then
#                   imported to another system, overwriting it.
#                   To avoid that, mount automatically on altroots.
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

set -e

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
#   Parse arguments
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

if [ $# -eq 0 ]; then
    echo "Usage: $(basename "$0") <pool>" >&2
    exit 1
fi

POOL=$1

#   -------------------------------------------------------------
#   Try to recover pool
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mkdir -p "/mnt/$POOL"
zpool import -R "/mnt/$POOL" "$POOL"
