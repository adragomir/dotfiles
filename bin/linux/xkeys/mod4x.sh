#!/bin/bash
W=`xdotool getactivewindow`                                                     
S1=`xprop -id ${W} |awk '/WM_CLASS/{print $4}'`                                 
if [[ $S1 =~ "Terminator" ]]; then
  xdotool key --clearmodifiers ctrl+shift+c
elif [[ $S1 =~ "Gnome-terminal" ]]; then
  xdotool key --clearmodifiers ctrl+shift+c
else
  xdotool key --clearmodifiers ctrl+x
fi

