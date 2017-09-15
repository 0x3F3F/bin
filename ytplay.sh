# NOTE youtoube-dl WORKS WITH OTHER SITES TOO
# This method was found on website
# It used mplayer, but that failed due to https.  mpv is form of mplayer that supports https

# Need Cookies set to play
# youtube-dl does 2 things:
# 1 fetches cookies store them in temp file that mpv picks up
# 2 the -g option outputs the actual video link

mpv -really-quiet -cookies -cookies-file /tmp/cookies.txt $(youtube-dl -g --cookies /tmp/cookies.txt "$(echo $1)")  2 > /dev/null



