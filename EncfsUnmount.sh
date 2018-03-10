#!/bin/bash
# Usage:
#       EncfsUnmount <path to unmount>
#   
# eg EncfsUnmount /home/iain/Encfs/Private
# Note that ~ appears not to work


# Copied from web.  Check if EncFs mounted, if so then unmount.
if gnome-encfs-manager is_mounted "$1" >/dev/null; then

	# Set the message we want to display in the manager while we are busy
	# and save the message ID so we can properly remove it later
	busy_id=$(gnome-encfs-manager indicate "(kill-unmount) `basename "$1"`: Killing processes...")

	# Search for processes and kill them
	pids=$(lsof | grep "$1" | awk '{print $2}' | sort -u)
	for pid in $pids; do
	    kill -9 $pid
	done

	# remove the message from the message stack
	gnome-encfs-manager indicate $busy_id

	# Call unmount again, it should now succeed
	gnome-encfs-manager unmount "$1"
fi
