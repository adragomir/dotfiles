#!/usr/bin/env ruby
require 'rubygems'
require 'active_rdf'
exit unless $ARGV.length >= 1
adapter = ConnectionPool.add_data_source(:type => :redland, :location => $ARGV[0])
puts adapter.dump

