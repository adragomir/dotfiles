#!/bin/sh

# To use Apple's rsync switch commented lines below
# To use rsyncx:
RSYNC=/usr/local/bin/rsync
# To use built-in rsync (OS X 10.4 and later):
# RSYNC=/usr/bin/rsync -E

# sudo runs the backup as root
# --eahfs enables HFS+ mode
# -a turns on archive mode (recursive copy + retain attributes)
# -x don't cross device boundaries (ignore mounted volumes)
# -S handle sparse files efficiently
# --showtogo shows the number of files left to process
# --delete deletes any files that have been deleted locally
# $* expands to any extra command line options you may give

sudo $RSYNC -a -x -S -v -E --delete --ignore-errors \
  --exclude-from /Users/adragomi/bin/backup_excludes.txt $* /Users/adragomi /Volumes/Backup/rsync/adragomi

# make the backup bootable - comment this out if needed
#sudo bless -folder /Volumes/OSX/System/Library/CoreServices

