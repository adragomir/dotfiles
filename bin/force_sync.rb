#!/usr/bin/ruby
# get the list of files, separated by spaces
files = `p4 diff -sd ./...`.split(/\n/).join(' ');
# open for delete
system("p4 sync -f #{files}")
exit

