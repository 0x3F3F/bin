# Converts a youtube video to mp3
youtube-dl -x --audio-format mp3 --audio-quality 9 --output "/home/iain/%(title)s.%(ext)s" "$1"  


