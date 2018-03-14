########################################################################
#
# NAme:		playUrl.sh
# Author:	Iain Benson
# DEsc:		Plays current firefox url using mpv.
#
# Usage:	Bind to key
#			Press key to listen/play media from current firefox url
#
########################################################################


# Copy Current link URL to clipboard
wmctrl -a "firefox"
sleep 0.5
xdotool key ctrl+l
sleep 0.5
xdotool key ctrl+c


# Start playing
VID=`xclip -selection clipboard -o`
mpv --really-quiet --ytdl-format="bestvideo[height<=?480][vcodec!=vp9]+bestaudio/best" "$VID"

