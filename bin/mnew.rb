#!/usr/bin/env ruby
if (ARGV.length < 1)
	puts "Error: show, do"
	exit
end
command = ARGV[0]
# get the list of files, separated by spaces
files = `find . -type f | p4 -x- have 2>&1`
collect = []
files.split("\n").each { |l|
	next unless l[" - file(s) not on client."] != nil
	l = l.gsub(" - file(s) not on client.", "")
	if l =~ /.*\.DS_Store*/ then
	else
		collect.push(l)
	end
}
# open for edit
if (command == "show")
	puts collect
end

if (command == "do")
	system("p4 add #{collect.join(' ')}")
end
exit

