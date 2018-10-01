#!/bin/bash

# stream youtube without downloading

# omxplayer preferable as uses gpu, but cant handle yt streams. Site suggested this was as ffmpeg not complied with openssl.

# default mpv doesn't use rpi hardware acceleration, so tried to re-install by compiling it and ffmpeg manually:
# https://nwgat.ninja/quick-easy-compiling-mpv-for-raspberry-pi/
# https://raspberrypi.stackexchange.com/questions/57847/no-opengl-hardware-rendering-using-mpv
# This didn't work, hit issue when compiling ffmpeg.  
# Re-installed ffmpeg/mpv from repo, stick to 480p for now as that plays without issues. sometimes 720p too.
#mpv  --quiet --osd-level=1 --volume-max=130 --volume=115 --autofit="100%x100%" --ytdl-format="bestvideo[vcodec!=vp9][height<=?720][fps<=30]+bestaudio[ext=m4a]" "$1"


# Was having issue with vids with no sounds.  
# If specify diff audio/video streams they're not being multiplexed (ffmpeg issue?)
# Use old youtube-dl behaviour specifying only quality in single file - See github page.
# Try for mp4 first (so wont get vp9).  If no mp4 then default to best that is avilable.
#omxplayer $(youtube-dl -g -f best "$1")
sudo sh -c "TERM=linux setterm  -foreground black -clear all >/dev/tty0"		# Clear terminal whoch xould be visible
omxplayer $(youtube-dl -g -f 'mp4[height <=? 720]/best[height <=? 720]' "$1")
sudo sh -c "TERM=linux setterm  -foreground white -clear all >/dev/tty0"		# Restore normal terminal colour

