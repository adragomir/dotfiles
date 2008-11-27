#!/usr/bin/env ruby
# get the list of files, separated by spaces
files = `p4 diff -se ./...`.split(/\n/).join(' ');
# open for edit
system("p4 edit #{files}")
exit
