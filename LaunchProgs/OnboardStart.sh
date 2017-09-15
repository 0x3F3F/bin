#!/bin/sh


a=`ps ax | grep onboard | wc -l`

if [ "$a" -ne 1 ]
then
	# Already open, just maximise it
	dbus-send --type=method_call --dest=org.onboard.Onboard /org/onboard/Onboard/Keyboard org.onboard.Onboard.Keyboard.Show
else
	# Not running yet, start it
	onboard
fi
	
# Want to start with shift pressed as that's usually what is needed
# Only work if Onboard hasnt been moved
xdotool mousemove --sync 854 814
sleep 0.25
xdotool click 1 

