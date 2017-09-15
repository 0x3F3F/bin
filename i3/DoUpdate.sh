#!/bin/bash
sudo apt-get update && sudo apt-get upgrade

if [ -f /var/run/reboot-required ]; then
     echo 'A system restart is required.'
fi

