#/bin/bash

# Create a placeholder, so I know last item wathced
rm *.watched
touch "$1.watched"

# This is playing mp3s on one off basis: don't loop, which is the default.
mpv --no-audio-display --loop=no "$1"

