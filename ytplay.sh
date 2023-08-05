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
#				Leave it to that script to kill existing ytplay instances
#
#		Dependencies:
#				omxplayer
#				youtube-dl
#				jq
#				A Raspberry Pi :)
#
############################################################################################## 

# Warning: going to use colour. Sunglasses on.
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NO_COL='\033[0m'




PlayVid()
{
	# Slow ytdl due to importing extractors for sites:
	# https://github.com/rg3/youtube-dl/issues/3029

	# Fetch 'real' video link (-g) and title (-e) with youtube-dl
	# If specify diff audio/video streams they're not being multiplexed (ffmpeg issue?) => No sound
	# Use old youtube-dl behaviour specifying only quality results in single file - See github page.
	# Try for mp4 first (so wont get vp9).  If no mp4 then default to best that is avilable.
	clear; echo "Fetching video info"
	TITLEURL=$(youtube-dl -e  -g -f 'mp4[height <=? 480]/best[height <=? 480]' "$1")

	# Sometimes title is followed by newline which breaks sed regex
	FIXEDTITLEURL=$(echo $TITLEURL | tr '\n' ' ' | tr '\r' ' ')

	# Title followed by link.  Split on http
	LINK=$(echo $FIXEDTITLEURL | sed 's/.*http/http/')
	TITLE=$(echo $FIXEDTITLEURL | sed 's/http.*//')
	#DURATION=$(echo $FIXEDTITLEURL | sed 's/http.*//')

	# Output Title to shell
	clear; 
	[[ $2 == 'local' ]] &&  AUDIO_COL=$GREEN || AUDIO_COL=$CYAN
	echo -e "Playing: ${AUDIO_COL}$TITLE${NO_COL}"
	[[ $2 == 'local' ]] && echo -e "Audio Out: ${AUDIO_COL}Hifi${NO_COL}" || echo -e "Audio Out: ${AUDIO_COL}Telly${NO_COL}"

	# Use the -r flag to clear display prior to changing resolution.
	# Was using -b, but this caused issues when pausing videos on new tv
	# Need these otherwise terminal/wallpaper may be visible in background
	# User has selected output audio device via $2
	omxplayer -o $2  --aspect-mode fill -r "$LINK" > /dev/null

	# Backup option was MPV, but no Hw Acceleation and couldn't compile it on Pi
	#mpv  --quiet --osd-level=1 --volume-max=130 --volume=115 --autofit="100%x100%" --ytdl-format="bestvideo[vcodec!=vp9][height<=?720][fps<=30]+bestaudio[ext=m4a]" "$1"
}




###############################################################################################################
#	ENTRY POINT
###############################################################################################################


# Choose where want audio sent to
echo -e "Press ${CYAN}t for TV${NO_COL}, or ${GREEN}h for Hifi${NO_COL} " 
if [[ -e .ytplay_DefaultTelly ]] ; then	
	echo -e "${CYAN}Defaulting to Telly${NO_COL}"
else
	echo -e "${GREEN}Defulting to Hi-Fi${NO_COL}"
fi

read -t 2 -n 1 key <&1
clear; printf "Audio output selected: "

if [[ $key = h ]] ; then
	echo -e "${GREEN}Hi-Fi${NO_COL}"
	OUTPUTTO='local'	# omxplayer -o input

	# Use a temp file to flag default
	rm .ytplay_Default*

elif [[ $key = t ]] ; then
	echo -e "${CYAN}Telly${NO_COL}"
	OUTPUTTO='hdmi'		# omxplayer -o input

	# Use a temp file to flag default
	touch .ytplay_DefaultTelly

else

	# Use same as last selected
	if [[ -e .ytplay_DefaultTelly ]] ; then	
		echo -e "${CYAN}Telly${NO_COL}"
		OUTPUTTO='hdmi'		# omxplayer -o input
	else
		echo -e "${GREEN}Hi-Fi${NO_COL}"
		OUTPUTTO='local'	# omxplayer -o input
	fi
fi


# Determine if playing single video or playlist
if [[ $1 = *"list="* ]]; then

	echo "Reading Youtube Playlist."

	# Issue with url containing watch not working.  fix it
	FIXED=$(echo "$1"|sed 's/watch.\+list=/playlist?list=/g')

	# If playlist download with youtube-dl it as json
	PLAYLIST_JSON=$(youtube-dl -j --flat-playlist "$FIXED" )
	
	# All on same line.  Split onto separate for easy processing. Note \n doesn't work.
	PLAYLIST_JSON=$(echo $PLAYLIST_JSON | sed 's/} {/}\r{/g')

	# For loop uses whitespace.  Use Internal File Separator to use \r instead
	IFS=$'\r'
	for line in $PLAYLIST_JSON
	do
		# Get the Title and Url.  Use jq to process json
		#TITLE=$(echo $line | jq -r '.title')
		URL=$(echo $line | jq -r '.url')

		# Create Url(web url not extracted omx compatable one) from id and play using our function above
		PlayVid "https://www.youtube.com/watch?v=$URL" "$OUTPUTTO"

		# Once video terminate, give user ability to quit out of playlist
		echo -e "${RED}"
		read -p "Press q to quit playlist " -t 2 -n 1 key <&1
		echo -e "${NO_COL}"
		if [[ $key = q ]] ; then
			break
		fi

	done

else

	# Easy, Playing Single Video
	PlayVid "$1" "$OUTPUTTO"

fi

# As we've cleared display, lets put back wallpaper
sudo fbi -a --noverbose --fitwidth -T 1 /home/pi/Pictures/Wallpaper/Rasp/RaspiWallpaper2.jpg

