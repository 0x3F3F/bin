#!/bin/bash
#
# rsyncUsb.sh - Syncs Docs from machine to Usb stick.  Includes data insode truecrypt volume.
#				usage:
#						sudo rsyncUsb.sh	-	Mounts TrueCrypt container, syncs, unmounts
#						sudo rsyncUsb.sh XXX -	As above but does not dismount Truecrypt comainer.
#												truecrypt -d should be manually ran.
#					
#
# Notes:
# egrep line only picks out lines with uploads ie start with  < to be output to log file
# >> appends to log file rather than overwrites it.  I'll just keep doing that as I can periodically review it then delete - or do once a month using CRON

# Note on sudoers
# Added this script to sudoers file with 'sudo visudo' but I founf that it only worked if called vis:
# sudo ./rsyncUsb or sudo /home/iain/bin/NoAutoBAckup/rsuncUsb.sh IF EXECUTE rsyncUsb.sh STILL GET PASSWORD PROMPT
# Think this is realted to that dir not being in path for sudo user.  Think it best I put this in /usr/local/bin
# IMPORTANT: I've up this script in /usr/local/bin (with relevant permissions). This copy (with _) is just to have a backup of it.
#
# Set the log file
RSYNCLOG=/home/iain/.logs/rsyncUsb.log
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
#Get year so we know what photo folder to update, we're not storing all photos just those of current year
YEAR=`date "+%Y"`

# Note --dry-run option to test changes out


###### Test if the directories exist, only continue if the do.  Notify user if not!
if [ ! -d "/media/iain/usb1/SysVar" ]; then
	echo "${TIMESTAMP} **ERROR** - No /media/iain/usb1 directory - Is USB connected??" >> $RSYNCLOG
	/usr/bin/notify-send -u normal -t 4000 "**ERROR** Is USB Connected?"
	exit 2
fi

# OK fist mount the truecrypt volume
# IMPORTANT PERMISSIONS ON THIS SCRIPT 700 AS HAS PASSWORD
mkdir -p /media/iain/TrueCrypt
/usr/bin/truecrypt --password="XXXXXXXXXXXXXXXXXxx" /media/iain/usb1/SysVar/containers/baks.tc  /media/iain/TrueCrypt
chown -R iain:iain /media/iain/TrueCrypt

#### Test that Truecrypt Volume mounted correctly.  
if [ ! -d "/media/iain/TrueCrypt/Archived Docs" ]; then
	echo "${TIMESTAMP} **ERROR** - No /media/iain/TrueCrypt directory - Has TrueCrype volume been mounted?" >> $RSYNCLOG
	/usr/bin/notify-send -u normal -t 4000 "**ERROR** - Has TrueCrypt been mounted?"
	exit 3
fi


####### Sync Keepass
# Note that I'm using checksum as udiskie mounts with diff permissions and always get copy, I only want to overwrigt if changed.
# Checksum is safer than size-only but slower=> only select specific file.
rsync -avz  --checksum --itemize-changes /media/iain/Data/SysVar/cache/TRUECRIPT_FILENAME_GOES_HERE /media/iain/usb1/SysVar/cache | egrep '^>' | sed "s|^|$TIMESTAMP |" >> $RSYNCLOG


###### Sync Finances 
# Use ignore-existing so as not to propagate corrupt files.  Will check what hasn't been synced at end
# Exclude: Open Office lock documents, TrueCrypt folder
rsync -avz --exclude '.~lock*' --exclude TrueCrypt --ignore-existing --itemize-changes '/media/iain/Data/Archived Docs' /media/iain/TrueCrypt | egrep '^>' | sed "s|^|$TIMESTAMP |"  >> $RSYNCLOG
# Now sync existing files that we know may have ligitimately changed.  Need include Before exclude.
# inlude '*/' is essential as otherise it doesn't searh in the directories
# Including spreadsheets, this is a risk but generally have pdf's generated from them so should be OK. P.ods done separately as on diff branch.
rsync -avz --include '*/' --include '*.ods' --include '*.odt' --include 'ProofSpanish*' --include '*DaysInUK.txt'  --exclude '*' --size-only --itemize-changes '/media/iain/Data/Archived Docs/Tax_IncAutonomoDocs' '/media/iain/TrueCrypt/Archived Docs' | egrep '^>' | sed "s|^|$TIMESTAMP |"  >> $RSYNCLOG
rsync -avz --size-only --itemize-changes '/media/iain/Data/Archived Docs/Shares/Portfolio/P.ods' '/media/iain/TrueCrypt/Archived Docs/Shares/Portfolio' | egrep '^>' | sed "s|^|$TIMESTAMP |"  >> $RSYNCLOG


####### Sync Photos - again using ignore-existing 
####### Sync ONLY CURRENT YEAR, does this automatically.  Exluding Videos as they're huge.
rsync -avz --ignore-existing --itemize-changes --exclude '*.mp4' "/media/iain/Data/Photos/${YEAR}" /media/iain/TrueCrypt/Photos | egrep '^>' | sed "s|^|$TIMESTAMP |" >> $RSYNCLOG

####### CHECKING MISSED FILES
# Now as used 'safe' option to syn finance docs.  Want to report on existing docs that have been modified but not synced
# using size only and otherwise will write loads on initial compare due to file dates diff.  size-only will  pick up file changes.
###### Exclude: Open Office lock documents, TrueCrypt folder
DT=`date "+%Y-%m-%d"`
STR=$(egrep $DT /home/iain/.logs/rsyncUsb.log) 
echo "Latest Updates:"
echo "$STR"
echo ""
echo -e "To avoid propagating corrupt fies, the following \e[7mHAVE NOT BEEN SYNCED\e[27m.  Please review and update manually:"
rsync -avz --exclude '.~lock*' --exclude TrueCrypt --size-only --dry-run --itemize-changes '/media/iain/Data/Archived Docs' /media/iain/TrueCrypt | egrep '^>f'

# If argument passed, then we do't want to unmount
if [ -z "$1" ]; then
	#First unmount Truecrypt caintainer
	sleep 2
	truecrypt -d
	sleep 2

	#Flag if issue.  Ret value in $?
	if [ $? -ne 0 ]; then
		/usr/bin/notify-send -u normal -t 6000 "ERROR UNMOUNTING TRUECRYPT"
		exit 1
	fi

	# Should be safe to now delete TrueCrypt dir, but.....
	# Double check so don't delete everything accidentally.
	if [ ! -d "/media/iain/TrueCrypt/Archived Docs" ]; then
		rm -r /media/iain/TrueCrypt
	fi
fi

#/usr/bin/notify-send -u normal -t 6000 "FILES SYNCED TO USB" "$STR"










