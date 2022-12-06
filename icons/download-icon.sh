#!/bin/bash

url=$1
name=$2

sudo wget $1 -O $2.png

sudo magick $2.png -resize 22x22 $2.png
