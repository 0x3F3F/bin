#/bin/bash

# Create a placeholder, so I know last episode watched
rm *.watched
touch "$1.watched"

# Use -b flas as sets screen to black if full screen not displayed
/usr/bin/omxplayer -b -o hdmi "$1"

