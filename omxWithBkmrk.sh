#/bin/bash

# Create a placeholder, so I know last episode watched
rm *.watched
touch "$1.watched"

echo "$1"

# Use the -r flag to clear display prior to changing resolution.
# Was using -b, but this caused issues when pausing videos on new tv
# Need these otherwise terminal/wallpaper may be visible in background
/usr/bin/omxplayer -r -o hdmi "$1"

# As we've cleared display, lets put back wallpaper
sudo fbi -a --noverbose --fitwidth -T 1 /home/pi/Pictures/Wallpaper/Rasp/RaspiWallpaper2.jpg


