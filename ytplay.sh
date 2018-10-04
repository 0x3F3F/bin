#!/bin/bash

############################################################################################## 
#	
#		Script: ytplay.sh
#		Author:	Iain Benson
#		Desc:	Stream Youtube using omxplayer (HW acceleration)
#				Caters for Playlists as well as single URLs.
#
#		Some Notes:
#				*Sound*
#				omxplayer doesn't use ALSA or Raspi confib setting, but detects automagically
#				Can force with -o flag that has options: hdmi, local, both
#
#				*Launch from Phone (via Share manu)*
#				Use Termux.  Create script in bin called 'termux-url-opener'
#				VID=$1
#				ssh pi@raspberrypi -t "/home/pi/bin/ytplay.sh $VID"
#
#		Dependencies:
#				omxplayer
#				youtube-dl
#				jq
#				A Raspberry Pi :)
#
############################################################################################## 

PlayVid()
{
	# If specify diff audio/video streams they're not being multiplexed (ffmpeg issue?) => No sound
	# Use old youtube-dl behaviour specifying only quality results in single file - See github page.
	# Try for mp4 first (so wont get vp9).  If no mp4 then default to best that is avilable.
	omxplayer $(youtube-dl -g -f 'mp4[height <=? 720]/best[height <=? 720]' "$1")

	# Backup option was MPV, but no Hw Acceleation and couldn't compile it on Pi
	#mpv  --quiet --osd-level=1 --volume-max=130 --volume=115 --autofit="100%x100%" --ytdl-format="bestvideo[vcodec!=vp9][height<=?720][fps<=30]+bestaudio[ext=m4a]" "$1"
}



# Clear terminal which could be visible at sides of video
sudo sh -c "TERM=linux setterm  -foreground black -clear all >/dev/tty0"	

# Kill existing omxplayer/feh instances.
if pgrep -x "omxplayer" > /dev/null
then
	killall omxplayer 
fi

# fbi processes may be running. kill 'em
sudo killall fbi

# Determine if playing single video or playlist
if [[ $1 = *"list="* ]]; then

	# Issue with url containing playlist not working.  fix it
	FIXED=$(echo "$1"|sed 's/watch.\+list=/playlist?list=/g')

	# If playlist download with youtube-dl it as json
	PLAYLIST_JSON=$(youtube-dl -j --flat-playlist "$FIXED" )
	
	# All on same line.  Split onto separate for easy processing. Note \n doesn't work.
	PLAYLIST_JSON=$(echo $PLAYLIST_JSON | sed 's/} {/}\r{/g')

	# For loop uses whitespace.  Use Internal File Separator to use \r instead
	IFS=$'\r'
	RED='\033[0;31m'
	NO_COL='\033[0m'
	for line in $PLAYLIST_JSON
	do
		# Get the Title and Url.  Use sq ro process json
		TITLE=$(echo $line | jq -r '.title')
		URL=$(echo $line | jq -r '.url')

		# Output what we're playing to terminal
		clear
		#echo $TITLE
		#echo $URL
		echo -e "Playing: ${RED}$TITLE${NO_COL}"

		# Create Url from id and play using our function above
		PlayVid "https://www.youtube.com/watch?v=$URL"

		# Once video terminate, give user ability to quit out of playlist
		read -p "Press q to quit playlist " -t 2 -n 1 key <&1
		if [[ $key = q ]] ; then
			break
		fi

	done

else

	# Easy, Playing Single Video
	PlayVid "$1"

fi


# Restore normal terminal colours
sudo sh -c "TERM=linux setterm  -foreground white -clear all >/dev/tty0"	


# Actually, lets display something instead of a black screen
# X not running so use framebuffer. Neaeds sudo as virit console owned by root
PHOTODIR=~/Pictures/Wallpaper/Rasp 
sudo fbi -a --noverbose -T 1 -t 80 -u `find $PHOTODIR -iname "*.jpg"`

