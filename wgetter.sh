#!/bin/bash
UserAgent="Mozilla/5.0 (Windows NT 6.1; rv:45.0) Gecko/20100101 Firefox/57.0"
if [[ "$1" != "" ]]; then
	echo -e "Fetching >> $1 << recursively...\n\n"
	wget -c -e robots=off --random-wait -r -U "$UserAgent" -l inf --no-parent --reject "index.html*" --reject "robots.txt" "$@"
	echo -e "\n\nFetched all files."
fi
			 
# ---------------------
#
# wget parameter explanation:
#
# ---------------------
#
# -c                do not re-download existing files; continue partially finished downloads
# -e robots=off     ignore robots.txt
# --random-wait     wait a random amount of time between two downloads
# -r                download recursively
# -U "$UserAgent"   set useragent to the one specified. Currently matches the Tor Browsers UA.
# -l inf            removes the limit of subdirectories to download (default is 5)
# --no-parent       do not download parent directories
# --reject          do not download the specified files
# "$@"              the URL(s) given as an argument
#
# ---------------------
#
# If you don't like a particular parameter, just delete the part from line 5.
# Probably one of the best Stackoverflow questions regarding recursive downloading:
# https://stackoverflow.com/questions/273743/using-wget-to-recursively-fetch-a-directory-with-arbitrary-files-in-it
#
# ---------------------
#
# USAGE (Assuming a GNU/Linux based OS):
#
# ---------------------
#
# 1. Create a file (e. g. called 'download.sh') with this content in an empty directory on your hard drive
# 2. Open the folder in a terminal and make the file executable (e. g. 'chmod 744 download.sh' )
# 3. Initiate the download by entering something like this: ./download.sh http://example.com/open/directory/
#
# Caution:
#
# Make sure to enter the URL with a / at the end!
#
#----------------------
