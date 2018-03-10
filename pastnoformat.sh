#!/bin/bash

# Assigning this to a hotkey - eg Ctrl-Shift-V
# This script removes foramatting andplain text, eg from a website

xclip -selection clipboard -o | xclip -selection clipboard
sleep 0.5
xdotool key ctrl+v

#if using a clipboard manager then uncomment lines below
# sleep 0.5
# killall xclip


