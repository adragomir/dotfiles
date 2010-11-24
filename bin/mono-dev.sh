#!/bin/bash
MONO_PREFIX=/opt/mono
GNOME_PREFIX=/opt/gnome
export LD_LIBRARY_PATH=$MONO_PREFIX/lib:/sw/lib:$LD_LIBRARY_PATH
export C_INCLUDE_PATH=$MONO_PREFIX/include:$GNOME_PREFIX/include:/sw/include:/Library/Frameworks/Mono.framework/Versions/Current/include/libpng
export ACLOCAL_PATH=$MONO_PREFIX/share/aclocal
export PKG_CONFIG_PATH=$MONO_PREFIX/lib/pkgconfig:$GNOME_PREFIX/lib/pkgconfig:/sw/lib/pkgconfig:/usr/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/X11R6/lib/pkgconfig:/Library/Frameworks/Mono.framework/Versions/Current/lib/pkgconfig
export PATH=$MONO_PREFIX/bin:$PATH:/sw/bin
export PS1="[mono] \w @ "
