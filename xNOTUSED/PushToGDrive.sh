#!/bin/bash

# Uses GO program 'drive' from here https://github.com/odeke-em/drive#installation
# GO installed directly as synaptice version not suffueuent http://golang.org/doc/install

# In google dive right cick to get link which has id:    0B-xgljudYJ33cFl0eWktak1HOE0
# Created .gdrive dir then did 'drive init' IN THAT DIR
# Retrieved file using drive pull --id 0B-xgljudYJ33cFl0eWktak1HOE0

#BUG with Android prog;
#After update need to remove then re-add Db,It must cache it and not reload when it should

#Push KeePass Db
#cp '/media/iain/Data/SysVar/cache/MZXD5GJ3F55FGH8IBP' /home/iain/.gdrive/SysVar/cache/MZXD5GJ3F55FGH8IBP
#cd /home/iain/.gdrive/SysVar/cache
#yes | /home/iain/go/bin/drive push MZXD5GJ3F55FGH8IBP

#Push encrypted Archived Docs folder
#First issue with .encfs6.xml as program appears to no see hidden files
#cd /media/iain/Vista/Users/Iain/Desktop/GDrive/SysVar/Archive
#cp .encfs6.xml encfs6.xml
#yes | /home/iain/go/bin/drive push 

#NOT GOING TO USE GDRIVE SOLUTION FOR THIS AS PROBLEMS SYNCING ENCFS FILE AND ALSO ONLY APPEARED TO SYNC 400MB OF 700MB
#OTHER PEOPLE REPORTED ISSUES OF FILES GING MISSING ETC.  WILL GO WITH OWN SOLUTION
#FTP on my server https://www.linux.com/community/blogs/133-general-linux/10459
#Bittorrent, but keep temp files it creatres in diff dir as interferes with encfs

