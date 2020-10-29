#!/bin/bash 

# The utool installer 1st stage

# Assumes the Target is already mounted like in production

TARGET=/mnt/gentoo

echo "[$0] URBAN TOOL INSTALLER"

echo "[SETS] dsk, srv or usb ?"
read SETTINGS

USET=sets/$SETTINGS

echo "[$0] COPYING INSTALLER FILES TO DISK"

cp $USET/chroot.sh $TARGET
cp $USET/pkg.lst $TARGET
cp -f $USET/make.conf $TARGET/etc/portage/

echo "[$0] EXTRACTING BASE SYSTEM"

tar xpvf $USET/stage3* --xattrs-include='*.*' --numeric-owner -C $TARGET
 
echo "[$0] 1ST STAGE CONFIGURATION"

# Adjust System Clock [leaks ip]
ntpd -q -g

# Copying portage net info
mkdir -p $TARGET/etc/portage/repos.conf
cp $TARGET/usr/share/portage/config/repos.conf $TARGET/etc/portage/repos.conf/gentoo.conf

./genfstab.sh $TARGET
cat fstab.gen >> $TARGET/etc/fstab

echo "[$0] CHROOTING"

cp --dereference /etc/resolv.conf $TARGET/etc/resolv.conf

mount --types proc /proc $TARGET/proc
mount --rbind /sys $TARGET/sys
mount --make-rslave $TARGET/sys
mount --rbind /dev $TARGET/dev
mount --make-rslave $TARGET/dev 

chroot $TARGET chroot.sh

echo "[$0] EXITING CHROOT"

umount -l $TARGET/dev{/shm,/pts,}
umount -R $TARGET{/proc,/sys}

echo "[$0] REMOVING INSTALLER FILES"

rm $TARGET/chroot.sh
rm $TARGET/pkg.lst

