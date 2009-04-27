#!/usr/bin/env ruby
# get the list of files, separated by spaces
files = `p4 diff -se ./...`.split(/\n/)
parsed_files = []
files.each { |f|
  parsed_files.push("\"#{f}\"")
}

# open for edit
system("p4 edit #{parsed_files.join(' ')}")
exit
