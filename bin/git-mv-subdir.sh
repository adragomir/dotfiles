#!/bin/bash

NEWDIR=$1

if [ -z "$NEWDIR" ]; then
   echo "Specifiy NEWDIR"
   exit 1
fi

git filter-branch -f --index-filter \
    'git ls-files -s | gsed -n -e "s#\t\(.*\)#\t'$NEWDIR'/\1#p" |
        GIT_INDEX_FILE=$GIT_INDEX_FILE.new \
            git update-index --index-info &&
     ( test ! -f "$GIT_INDEX_FILE.new" \
            || mv -f "$GIT_INDEX_FILE.new" "$GIT_INDEX_FILE" )' HEAD
