#!/bin/bash

# Play podcasts with mpv.  First switching to Main workspace.

# Switch to web workspace
i3-msg "workspace 1:Web "

# Deal with handelling of specific sites:

if [[ $1 == *"youtube"* ]]
then
	# If youtube try and select lower quality as it's only a wee window
	echo "Playing: Youtube"
	# Use nohuip to disconnect from terminal, output directed to nohup.out
	nohup mpv --really-quiet --osd-level=1 --ytdl-format="bestvideo[height<=?480][vcodec!=vp9]+bestaudio/best" "$1"  > /dev/null 2>&1 &

elif [[ $1 == *"investorfieldguide"* || $1 == *"rationallyspeaking"* ]]
then
	# Issue with these sites as links to page not podcast url.  Open website
	echo "Opening with firefox"
	firefox "$1"

else
	# This is probably MP3, force it to open a window
	echo "Playing: MP3"
	# Use nohuip to disconnect from terminal, output directed to nohup.out
	nohup mpv --force-window --no-video --osd-level=3 "$1" > /dev/null 2>&1 &
fi

# Can't get it to switch back, not huge issue.
#i3-msg "workspace 3:Bash "

