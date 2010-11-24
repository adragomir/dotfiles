#!/bin/bash
PLAYER_LIBS=$FLEX_HOME/frameworks/libs/player/
FILENAME=$1
CLASSNAME=`echo $FILENAME | sed 's/.*\///' | sed 's/\.as$//'`

asc -import $PLAYER_LIBS/Global.abc -import $PLAYER_LIBS/playerglobal.abc -swf $CLASSNAME,500,400 $FILENAME
