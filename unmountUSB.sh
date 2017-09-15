#!/bin/bash

#First unmount Truecrypt caintainer
truecrypt -d
sleep 2

#Flag if issue.  Ret value in $?
if [ $? -ne 0 ]; then
	/usr/bin/notify-send -u normal -t 6000 "ERROR UNMOUNTING TRUECRYPT"
	exit 1
fi

#Next unmount USB
sudo umount /dev/sdb1
sleep 2

if [ $? -ne 0 ]; then
	/usr/bin/notify-send -u normal -t 6000 "ERROR UNMOUNTING USB DRIVE"
	exit 2
fi

# Echo tail of logs, only those Synced today
DT=`date "+%Y-%m-%d"`
STR=$(egrep $DT /home/iain/.logs/rsyncUsb.log | tail) 
/usr/bin/notify-send -u normal -t 6000 "UNMOUNT COMPLETED" "$STR"

