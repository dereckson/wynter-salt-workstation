#!/bin/sh

#   -------------------------------------------------------------
#   ZFS :: install OpenZFS on Fedora system
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Wynter
#   License:        Trivial work, not eligible to copyright
#   Reference:      https://openzfs.github.io/openzfs-docs/Getting%20Started/Fedora/
#   -------------------------------------------------------------

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
#   OpenZFS
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

DIST=$(rpm --eval "%{dist}")
KERNEL_VERSION=$(uname -r | awk -F'-' '{print $1}')

rpm -e --nodeps zfs-fuse

dnf install -y "https://zfsonlinux.org/fedora/zfs-release-2-8$DIST.noarch.rpm"
dnf install -y "kernel-devel-$KERNEL_VERSION"
dnf install -y zfs

modprobe zfs
zpool import
