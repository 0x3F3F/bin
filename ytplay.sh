#!/bin/bash

# Stream youtube without downloading.  Use omxplayer as has hardware acceleration

# Kill existing omxplayer that might be runnning.  Can only watch one vid at a time!
if pgrep -x "omxplayer" > /dev/null
then
	killall omxplayer
fi

# Clear terminal which could be visible at sides of video
sudo sh -c "TERM=linux setterm  -foreground black -clear all >/dev/tty0"	

# Was having issue with vids with no sounds.  
# If specify diff audio/video streams they're not being multiplexed (ffmpeg issue?)
# Use old youtube-dl behaviour specifying only quality results in single file - See github page.
# Try for mp4 first (so wont get vp9).  If no mp4 then default to best that is avilable.
#omxplayer $(youtube-dl -g -f best "$1")
omxplayer $(youtube-dl -g -f 'mp4[height <=? 720]/best[height <=? 720]' "$1")


# Restore normal terminal colours
sudo sh -c "TERM=linux setterm  -foreground white -clear all >/dev/tty0"	


# Launching from mobile (via Share menu) using Termux:
# Create:		termux-url-opener script
# Add:			VID=$1
#				ssh pi@raspberrypi -t "/home/pi/bin/ytplay.sh $VID"


#################################################################################
# Backup Option was to use MPV:
# default mpv doesn't use rpi hardware acceleration, so tried to re-install by compiling it and ffmpeg manually:
# https://nwgat.ninja/quick-easy-compiling-mpv-for-raspberry-pi/
# https://raspberrypi.stackexchange.com/questions/57847/no-opengl-hardware-rendering-using-mpv
# This didn't work, hit issue when compiling ffmpeg.  
# Re-installed ffmpeg/mpv from repo, stick to 480p for now as that plays without issues. sometimes 720p too.
#mpv  --quiet --osd-level=1 --volume-max=130 --volume=115 --autofit="100%x100%" --ytdl-format="bestvideo[vcodec!=vp9][height<=?720][fps<=30]+bestaudio[ext=m4a]" "$1"

