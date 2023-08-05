#!/bin/bash
########################################################################
#
# NAme:		playUrl.sh
# Author:	Iain Benson
# Desc:		Plays current firefox url using mpv.
#
# Usage:	Bind to key
#			Press key to listen/play media from current firefox url
#
# Dependcy:	mpv, xdotool, xclip, firefox
#
########################################################################


# Copy Current link URL to clipboard susing firefox shortcuts
wmctrl -a "firefox"
sleep 0.6
xdotool key ctrl+l
sleep 0.4
xdotool key ctrl+c

# Grab the URL from the clipboard
VID=`xclip -selection clipboard -o`

# Start playing
if [[ $VID == *"youtube"* ]]
then
	# If youtube try and select lower quality as it's only a wee window
	echo "Playing: Youtube"
	mpv --really-quiet --osd-level=1 --ytdl-format="bestvideo[height<=?480][vcodec!=vp9]+bestaudio/best" "$VID"
	#mpv  --osd-level=1 --ytdl-format="bestvideo[height<=?480][vcodec!=vp9]+bestaudio/best" "$VID" > /home/iain/debug_playUrl.log
	#echo "Playing youtube" >> /home/iain/debug_playUrl.log
else
	# This is probably MP3, force it to open a window
	echo "Playing: MP3"
	mpv --force-window --osd-level=3 "$VID"
	#echo "Playing MP3" > /home/iain/debug_playUrl.log
fi


