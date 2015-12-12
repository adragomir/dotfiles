#!/bin/bash

[[ -f ~/.Xdefaults ]] && xrdb -merge ~/.Xdefaults
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

xrandr --dpi 140

PATH=$PATH:/usr/local/bin
xsetroot -solid '#4a525a'
xsetroot -cursor_name left_ptr
xsetroot general

xset fp+ /opt/local/share/fonts/
xset fp+ /Users/adr/Library/Fonts/
xset fp rehash

urxvtd --quiet --opendisplay --fork
urxvtc &

cd ~
while true
do
  xsetroot -name "`date +"%Y-%m-%d %H:%M"`"
  xset r rate 250 30
  xset b off
  sleep 5
done &

exec /usr/local/bin/dwm

exec >>~/.xsession-errors 2>&1
