#!/bin/bash

if [[ "$1" == *.mp3 ]] ;
then 
	# Create a placeholder, so I know last item wathced
	rm *.watched
	touch "$1.watched"

	# This is playing mp3s on one off basis: don't loop, which is the default.
	mpv --no-audio-display --loop=no "$1"
else
	mpv --loop=inf "$1"
	#mpv --loop=no "$1"
fi
