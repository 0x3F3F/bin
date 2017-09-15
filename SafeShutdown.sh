#!/bin/bash

# First try to unmount private folders, in case still mounted and issues with corruption
/home/iain/bin/EncfsUnmount.sh /home/iain/Encfs/PrivateVista
/home/iain/bin/EncfsUnmount.sh /home/iain/Encfs/Private

#Perform Shutdown
dbus-send --system --print-reply --system --dest=org.freedesktop.ConsoleKit /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Stop













