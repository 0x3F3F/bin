# Plays youtube video using mpv.
# Dmenu can't take params, so I'll read video from the clipboard
# Playing on small window so keep format small too, but good audio.
#
# Usage:	Copy Youtube Url		('y' if use vimpranator)
#			Execute ./ytplay.sh		(REcomment binding to a hotkey)

VID=`xclip -selection clipboard -o`
#echo "$VID"
mpv --really-quiet --ytdl-format="bestvideo[height<=?480][vcodec!=vp9]+bestaudio/best" "$VID"


# Need Cookies set to play
# youtube-dl does 2 things:
# 1 fetches cookies store them in temp file that mpv picks up
# 2 the -g option outputs the actual video link
#mpv -really-quiet -cookies -cookies-file /tmp/cookies.txt $(youtube-dl -g --cookies /tmp/cookies.txt "$(echo $1)")  2 > /dev/null
# UPDATE: mpv noow allears to have youtube dl incorporated.



