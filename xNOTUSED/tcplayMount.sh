#!/bin/bash
# manage truecrypt containers using tcplay
# Usage:
# sudo ./tcplayMount open
# sudo ./tcplayMount close
# Note first password is sudo password, but...
# Updated /etc/sudoers file using 'sudo visudo' so no nened to enter sudo password. 
# Still call using sudo but not prompted for pass, but..... 

# If error on no free loop devices.  execute 'losetup -a' to view them.
# Then on each one to remove execute 'losetup -d /dev/loopX'

# ####Auto-Mount and Sync USB ####
#
# I have created two scripts to perform this:
#
# /usr/local/sbin/mountTC - This 'expect' script automounts the TrueCrypt volume, handles pwds
#
# /usr/local/sbin/AutomountActions.sh - This script is called when USB added via udev
#                                       See /etc/udev/rules.d/100-usb-mount
#                                       This mounts TC volume using above script then Syncs
#                                       using /home/iain/bin/rsyncUsb.sh in ~/bin/


user=iain
cryptdev=tc.conf
cryptpath=/media/iain/UUI/"$cryptdev"
loopdev=$(losetup -f)
mountpt=/media/"$cryptdev"

# must be run as root
if (( $EUID != 0 )); then
  printf "%s\n" "You must be root to run this."
  exit 1
fi

#help
if [[ $1 == "-h" ]]; then
	echo "Usage:"
	echo "sudo ./tcplayMount open      To mount the hidden volume"
	echo "sudo ./tcplayMount close     To unmount the hidden volume"
	exit 0
# unecrypt and mount container
elif [[ $1 == open ]]; then
  losetup "$loopdev" "$cryptpath"
  tcplay --map="$cryptdev" --device="$loopdev"

  # read passphrase
  read -r -s passphrase <<EOF
  "$passphrase"
EOF

  # mount container
  [[ -d $mountpt ]] || mkdir "$mountpt"

  # mount options
  userid=$(awk -F"[=(]" '{print $2,$4}' <(id "$user"))
  mount -o nosuid,uid="${userid% *}",gid="${userid#* }" /dev/mapper/"$cryptdev" "$mountpt"

# close and clean up…
elif [[ $1 == close ]]; then
  device=$(awk -v dev=$cryptdev -F":" '/dev/ {print $1}' <(losetup -a))
  umount "$mountpt"
  dmsetup remove "$cryptdev" || printf "%s\n" "demapping failed"
  losetup -d "$device" || printf "%s\n" "deleting $loopdev failed"
else
  printf "%s\n" "Options are open or close."
fi

