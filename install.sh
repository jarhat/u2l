#!/bin/bash 

# The utool installer 1st stage

# Assumes the Target is already mounted like in production

CHROOT_INSTALL=chroot_install.sh
TARBALL=files/stage3*
TARGET=/mnt/gentoo

echo "[$0] URBAN TOOL INSTALLER"

echo "[SETS] dsk, srv or usb ?"
read SETTINGS
PKG_LIST=sets/$SETTINGS/pkg.lst

echo "[$0] COPYING INSTALLER FILES TO DISK"

cp $CHROOT_INSTALl $TARGET
cp $PKG_LIST $TARGET/pkg.lst

echo "[$0] EXTRACTING BASE SYSTEM"

tar xpvf $TARBALL --xattrs-include='*.*' --numeric-owner -C $TARGET
 
echo "[$0] 1ST STAGE CONFIGURATION"

# Adjust System Clock [leaks ip]
ntpd -q -g

mount --types proc /proc $TARGET/proc
mount --rbind /sys $TARGET/sys
mount --make-rslave $TARGET/sys
mount --rbind /dev $TARGET/dev
mount --make-rslave $TARGET/dev 

echo "[$0] CHROOTING"

chroot $TARGET $CHROOT_INSTALL

echo "[$0] EXITING CHROOT"



echo "[$0] REMOVING INSTALLER FILES"

rm $TARGET/stage3*
rm $TARGET/pkg.lst












