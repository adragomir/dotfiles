#!/usr/bin/env ruby
require 'rubygems'
require 'active_rdf'
exit unless $ARGV.length >= 2

command = $ARGV.shift
db = $ARGV.shift
rest = $ARGV

adapter = ConnectionPool.add_data_source(:type => :redland, :location => db)

case command
  when 'del', 'delete', 'rm' then 
  when 'load' then
    adapter.load(rest[0], (rest[0] =~ /\.xml/ ? 'rdfxml' : 'ntriples' ))
    adapter.save
  when 'empty' then
    adapter.delete(nil, nil, nil)
    adapter.save
  when 'dump' then
    puts adapter.dump
  when 'size' then
    puts adapter.size
end

