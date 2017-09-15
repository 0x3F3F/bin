#!/bin/bash

# This script automounts encrypted Truecrypt volume then syncs it when usb inserted.
# It runs via a udev rule new file /etc/udev/rules.d/89-mount-TCvol.rules:
#ACTION=="add", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="0781", ATTRS{idProduct}=="5571", RUN+="/home/iain/bin/MountSyncTrueCrypt.sh
# the lsusb command was used to determine unique usb idVenfor and idProduct values
# DEVTYPE important as otherwise the rule may run multiple times, I guess till mounted.

# This Script is placed in /usr/local/sbin directory as 'sbin' runs it as root
# Nneeded for mountTC and tcplayMount.sh


#Some logging
MOUNTLOG=/home/iain/.logs/MountSyncTrueCrypt.log
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
echo "${TIMESTAMP} - /usr/local/sbin/MountSyncTrueCrypt.sh running" >> $MOUNTLOG


# udiskie is v slow sometimes, best to mount manually here
# useful commmands   'df -h' to see mounted drives.
#                    'umount /dev/sdb1' to unmount
# First create mount dir -p won't give error if already exists
/bin/mkdir -p /media/iain/TrueCrypt
/bin/mkdir -p /media/iain/PUP

sleep 5
# Mounting by uuid doesnt work in script but does manually. 
#/bin/mount -t vfat -o uid=1000,gid=1000,umask=022 /dev/disk/by-uuid/7496-8E53  /media/iain/TrueCrypt >> $MOUNTLOG

# Mounting by Label does workm but....
#/bin/mount -t vfat -o uid=1000,gid=1000,umask=022 -L PUP  /media/iain/PUP

# As Truecrypt uses sdb methos, I'll go with that  as better if both mount / both dont
# As FAT I'll use gid,uid umaks to set permissions - 1000=iain
/bin/mount -t vfat -o uid=1000,gid=1000,umask=022 /dev/sdb1  /media/iain/PUP


#
# UPDATE
# Gave up on this as couldn't mount truecrypt when script ran via udev
# Decided to update rsyncUsb script to instead mount then dismount
#

# Mount TrueCrypt
# Think only way to mount this is by hard wriring sdb2
# Poss probs if multiple stuff plugged in, then I'll have to do via gui PERMS ON THIS SHOULD BE 710
/usr/bin/truecrypt --password="ENTER PASSWORD HERE" /dev/sdb2 /media/iain/TrueCrypt 

# Change permissions to match other folders ie iain.  PUP should be OK already.
/bin/chown -R iain:iain /media/iain/PUP
/bin/chown -R iain:iain /media/iain/TrueCrypt

# Was using this to mount Truecrypt but not beeded now
#/usr/local/sbin/mountTC

# Now done, we should be OK to backup data. First wait a bit to allow TrueCrypt to settle
sleep5 
/home/iain/bin/rsyncUsb.sh

# Notify finished - NOT WORKING
#/usr/bin/notify-send -u normal -t 4000 "USB Data has been Synced & TrueCrypt volume unmounted"

# Not going to unmount, in case want to check things.  Leave that to user to exectire unmount script.

