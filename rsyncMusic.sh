#!/bin/bash
#
# SyncUpPi.sh
# ONE WAY sync from laptop to pi
# If decide want 2 way sync, then can switch over to unison
#
# Assumptions:
# - Assumes that raspberrypi ssh set up in .ssh/config file
# - Run this on a cron
#
# See this site for explanation of known hosts file
# https://www.digitalocean.com/community/tutorials/how-to-copy-files-with-rsync-over-ssh 

# Notes:
# egrep line only picks out lines with uploads ie start with  < to be output to log file
# >> appends to log file rather than overwrites it.  I'll just keep doing that as I can periodically review it then delete - or do once a month using CRON

# Set the log file
RSYNCLOG=/home/iain/.logs/rsyncMusic.log
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`



# Try to connect to ssh to see if available
# Exit code stored in $? - 0 if host up, 255 if down
ssh -q raspberrypi exit

# Output to log file
if [ $? -eq 0 ]
then
	echo "${TIMESTAMP} - RaspberryPi ssh server UP" >> $RSYNCLOG
else
	echo "${TIMESTAMP} - RaspberryPi ssh server DOWN - not rsync-ing" >> $RSYNCLOG
	exit 2
fi

#
# Now sync up folders with rsync
# a note on flags:
# I'm not using the-delete flag to delete remote items that were deleted locally.
# If I accidentally delete something locally, I don't want that acidentally propagating to remove backup!
# The StrictHostKeyChecking/USerKnownHostsFile stops host key checking, which we don't want apparently 

####### Sync Music - using ignore-existing otherwise will write loads on initial compare due to file dates diff
rsync -avz -e "ssh -o LogLevel=quiet -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --ignore-existing --itemize-changes --exclude '*.mp4'  /home/iain/Music raspberrypi:/media/wdhd/ | egrep '^<' | sed "s|^|$TIMESTAMP |" >> $RSYNCLOG

