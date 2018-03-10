#!/bin/bash    

# Tried running Xmodmap from .profile / .Xdefaulrs / .Xresources / .bashrc
# The key binings did not take affect.  Issue appears to be they get overwritten with xkb
# Usually worke when ran from i3 config, but not 100%.  Instead I'll run this script  with delay.

sleep 5
/usr/bin/xmodmap /home/ain/.Xmodmap &

