#!/bin/bash

############# VIDEO ##############################
xrandr --output HDMI1 --mode 1024x768 --pos 0x0

# local display is eDP1 but changing HDMI1 screws that up
# user xrandr -q to view supported resolutions.


############# SOUND ##############################
#speaker-test -D hdmi:CARD=PCH,DEV=0 -c 2 -r 44100
# For Sound Change type 'pavucontrol'
# Click right arrow for configuration and change setting to "Digital stereo (HDMI) output + Analog Stero Input"


