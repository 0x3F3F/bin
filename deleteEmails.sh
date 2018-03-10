#!/bin/sh

# To run on Cron
# Delete emails from Hotmail/Gmail folders as stored on server anyway and don't wan't to keep duplicates
# Keep most recent Hotmail/Gmail messages only so can refer ack if need be
# Keep emails from IainBenson server though
#find /home/iain/.mail/read_Gmail/cur/* -mtime +28 -exec rm {} \;
find /home/iain/.mail/read_Hotmail/cur/* -mtime +28 -exec rm {} \;
