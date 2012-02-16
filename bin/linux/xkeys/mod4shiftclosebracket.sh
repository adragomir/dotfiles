#!/bin/bash
W=`xdotool getactivewindow`
S1=`xprop -id ${W} |awk '/WM_CLASS/{print $4}'`
xdotool key --delay 0 --clearmodifiers "ctrl+Next"
