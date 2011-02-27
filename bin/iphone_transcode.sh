#!/bin/bash
INFILE="$1"
OUTFILE="$2"
ffmpeg -i "$INFILE" -strict experimental -f mp4 -vcodec mpeg4 -acodec aac  -maxrate 1000 -b 700 -qmin 3 -qmax 5 -bufsize 4096 -g 300 -ab 65535 -s 480x320 -aspect 4:3 "$OUTFILE"
