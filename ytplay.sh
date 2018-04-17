#!/bin/bash

# stream youtube without downloading

# omxplayer preferable as uses gpu, but cant handle yt streams. Site suggested this was as ffmpeg not complied with openssl.

# default mpv doesn't use rpi hardware acceleration, so tried to re-install by compiling it and ffmpeg manually:
# https://nwgat.ninja/quick-easy-compiling-mpv-for-raspberry-pi/
# https://raspberrypi.stackexchange.com/questions/57847/no-opengl-hardware-rendering-using-mpv
# This didn't work, hit issue when compiling ffmpeg.  
# Re-installed ffmpeg/mpv fropm repo, stick to 480p for now as that plays without issues. sometimes 720p too.
mpv  --ytdl-format="bestvideo[vcodec!=vp9][height<=?720][fps<=30]+bestaudio[ext=m4a]" "$1"

# OMX does play if supply video stream url so can handle https. it must use ffmpeg to multiplex audio
# focus on installing ffmpeg with openssl and then switch to omx



