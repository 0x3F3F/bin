#!/bin/bash

# https://www.reddit.com/r/i3wm/comments/8hpjb6/i3_lock_screen/
# https://www.reddit.com/r/i3wm/comments/msg2bm/lock_screen_with_i3lock_when_laptop_lid_is_closed/

revert() {
  rm /tmp/*screen*.png
  xset dpms 0 0 0
}

trap revert HUP INT TERM
xset +dpms dpms 0 0 5
scrot -d 1 /tmp/locking_screen.png
convert -blur 0x8 /tmp/locking_screen.png /tmp/screen_blur.png
convert -composite /tmp/screen_blur.png ~/.config/i3/lock.png -gravity Center -geometry -20x1200 /tmp/screen.png
i3lock -i /tmp/screen.png
revert

