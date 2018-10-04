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

# Kill existing omxplayer that might be runnning.  Can only watch one vid at a time!
if pgrep -x "omxplayer" > /dev/null
then
	killall omxplayer
fi


# Determine if playing single video or playlist
if [[ $1 = *"list="* ]]; then

	# If playlist download it as json, use jq to get list of id's
	PL_IDS=$(youtube-dl -j --flat-playlist "$1" | jq -r '.id')

	# Parse line at a time
	for line in $PL_IDS
	do
		# Create Url from id and play using our function above
		PlayVid "https://www.youtube.com/watch?v=$line"
	done

else

	# Playing Single Video
	PlayVid "$1"

fi



# Restore normal terminal colours
sudo sh -c "TERM=linux setterm  -foreground white -clear all >/dev/tty0"	

