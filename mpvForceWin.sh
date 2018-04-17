#!/bin/bash

# Using force window default has issues with mps-yt.  
# So create this one that I can call from firefox
mpv --force-window "$1"
