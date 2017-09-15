#!/bin/bash

# Uses GO program 'drive' from here https://github.com/odeke-em/drive#installation
# GO installed directly as synaptice version not suffueuent http://golang.org/doc/install

#Push everything in AndridTfr directory to GDrive
cd /home/iain/.gdrive/AndroidTfr
yes | /home/iain/go/bin/drive push

