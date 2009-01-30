#!/usr/bin/env ruby
# get the list of files, separated by spaces
files = `find . -type f | p4 -x- have 2>&1`
collect = []
files.split("\n").each { |l|
	next unless l[" - file(s) not on client."] != nil
	l = l.gsub(" - file(s) not on client.", "")
	collect.push(l)
}
# open for edit
system("p4 add #{collect.join(' ')}")
exit

