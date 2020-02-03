#!/bin/bash
set -e -o pipefail -x

apt-get install -y debootstrap
dest=$HOME/chroots/planck
if ! mountpoint -q $dest/var/cache/apt/archives ; then
    mkdir -p var-cache-apt-archives $dest/var/cache/apt/archives
    mount --bind var-cache-apt-archives $dest/var/cache/apt/archives
fi
if [ ! -e $dest/bin ] ; then
    mkdir -p $HOME/chroots/debootstrap-cache
    debootstrap --cache-dir=$HOME/chroots/debootstrap-cache buster $dest
fi
if ! mountpoint -q $dest/proc ; then
    mount -t proc proc $dest/proc
fi
if ! mountpoint -q $dest/sys ; then
    mount -t sysfs sysfs $dest/sys
fi
cp -a /etc/fstab /etc/hosts $dest/etc/
cp -a /proc/mounts $dest/etc/mtab
cp -a planck-build-buster-i386.sh $dest/root/

set +e
if [ -n "$1" ] ; then
    chroot $dest $1
else
    chroot $dest /root/planck-build-buster-i386.sh
fi
ret=$?
umount $dest/var/cache/apt/archives
umount $dest/sys
umount $dest/proc
set -e

exit $ret
