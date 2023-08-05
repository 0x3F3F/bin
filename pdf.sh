#!/bin/bash

pdf () { convert $1 -background white -apha remove -alpha off $1 ; /usr/bin/img2pdf -o ${1%.*}pdf $1 ; } 

