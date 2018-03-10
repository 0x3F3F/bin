#!/bin/sh
# This closes all terminal windows as all seem to share same process

# Below minimises but... when start with shift pressed doesn't work, either does kill
dbus-send --type=method_call --dest=org.onboard.Onboard /org/onboard/Onboard/Keyboard org.onboard.Onboard.Keyboard.Hide
#killall onboard


