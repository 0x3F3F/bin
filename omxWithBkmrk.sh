#/bin/bash

# Create a placeholder, so I know kast episode watched
rm *.watched
touch $1.watched

# Use -b flas as sets screen to black if full screen bot displayed
/usr/bin/omxplayer -b -o hdmi "$1"

