#!/bin/bash
 
echo "This script prints the filenames of any dylibs in your /usr/local/ that depend on the System Python"
for f in `find $1`; do
  otool -L "$f" 2> /dev/null| grep Python | grep System &> /dev/null
  status=$?
  if [ $status -eq 0 ]; then
    echo "$status: $f"
  fi
done
