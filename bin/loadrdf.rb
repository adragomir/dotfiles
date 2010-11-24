#!/usr/bin/env ruby
require 'rubygems'
require 'active_rdf'
exit unless $ARGV.length >= 2
adapter = ConnectionPool.add_data_source(:type => :redland, :location => $ARGV[0])
adapter.load($ARGV[1], ($ARGV[1] =~ /\.xml/ ? 'rdfxml' : 'ntriples' ))
