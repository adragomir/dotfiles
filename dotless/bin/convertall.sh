#!/bin/sh
ls *.JPG | xargs -n1 sh -c 'convert $0 -resize 1024x768 pictures_output/$0.gif'

