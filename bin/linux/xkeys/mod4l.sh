#!/bin/bash
W=`xdotool getactivewindow`                                                     
S1=`xprop -id ${W} |awk '/WM_CLASS/{print $4}'`                                 
if [[ $S1 =~ "chrome" ]]; then
  xdotool key --delay 0 --clearmodifiers "alt+d"
fi
