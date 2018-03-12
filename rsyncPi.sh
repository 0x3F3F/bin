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
RSYNCLOG=/home/iain/.logs/rsyncPi.log
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

####### Sync Wiki Notes
rsync -avz -e "ssh -o LogLevel=quiet -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --itemize-changes /home/iain/Documents/Notes raspberrypi:/home/pi/Documents | egrep '^<' | sed "s|^|$TIMESTAMP |"  >> $RSYNCLOG


####### Sync Keepass
rsync -avz -e "ssh -o LogLevel=quiet -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --itemize-changes /media/iain/Win10/Users/iain/SysVar/cache raspberrypi:/media/wdhd/Backups/SysVar | egrep '^<' | sed "s|^|$TIMESTAMP |" >> $RSYNCLOG


####### Sync Photos - using ignore-existing otherwise will write loads on initial compare due to file dates diff
rsync -avz -e "ssh -o LogLevel=quiet -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --ignore-existing --itemize-changes --exclude '*.mp4'  /home/iain/Photos raspberrypi:/media/wdhd/Backups | egrep '^<' | sed "s|^|$TIMESTAMP |" >> $RSYNCLOG


####### Sync Finances
# Use ignore-existing so as not to propagate corrupt files.  Will check what hasn't been synced at end
# Exclude: Open Office lock documents
rsync -avz -e "ssh -o LogLevel=quiet -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --exclude '.~lock*' --ignore-existing --itemize-changes '/home/iain/Documents/Archived Docs' raspberrypi:/media/wdhd/Backups | egrep '^<' | sed "s|^|$TIMESTAMP |"  >> $RSYNCLOG
# Now sync existing files that we know may have ligitimately changed.  Need include Before exclude.
# inlude '*/' is essential as otherise it doesn't searh in the directories
# Including spreadsheets, this is a risk but generally have pdf's generated from them so should be OK. P.ods done separately as on diff branch.
rsync -avz --include '*/' --include '*.ods' --include '*.odt' --include 'ProofSpanish*' --include '*DaysInUK.txt'  --exclude '*' --size-only --itemize-changes '/home/iain/Documents/Archived Docs/Tax_IncAutonomoDocs' 'raspberrypi:/media/wdhd/Backups/Archived Docs' | egrep '^>' | sed "s|^|$TIMESTAMP |"  >> $RSYNCLOG
rsync -avz --size-only --itemize-changes '/home/iain/Documents/Archived Docs/Shares/Portfolio/P.ods' 'raspberrypi:/media/wdhd/Backups/Archived Docs/Shares/Portfolio' | egrep '^>' | sed "s|^|$TIMESTAMP |"  >> $RSYNCLOG


####### CHECKING MISSED FILES
# Now as used 'safe' option to sync finance docs.  Want to report on existing docs that have been modified but not synced
# using size only and otherwise will write loads on initial compare due to file dates diff.  size-only will  pick up file changes.
###### Exclude: Open Office lock documents, TrueCrypt folder
DT=`date "+%Y-%m-%d"`
STR=$(egrep $DT /home/iain/.logs/rsyncPi.log) 
echo "Latest Updates:"
echo "$STR"
echo ""
echo -e "To avoid propagating corrupt fies, the following \e[7mHAVE NOT BEEN SYNCED\e[27m.  Please review and update manually:"
rsync -avz --exclude '.~lock*' --size-only --dry-run --itemize-changes '/home/iain/Documents/Archived Docs' raspberrypi:/media/wdhd/Backups | egrep '^>f'

