#!/usr/bin/env ruby

require 'rubygems'
require 'active_record'

# Connect to MySQL 'flightlog_development' database
database_spec = {
  :adapter  => 'mysql',
  :host     => 'localhost',
  :database => 'flexpoll',
  :username => 'root',
  :password => ''
}
ActiveRecord::Base.establish_connection database_spec

class Poll < ActiveRecord::Base
	set_table_name "poll_pol"
end

for i in 0..100 do 
  pn = Poll.new
  pn.name_pol = "poll #{i}"
  pn.question_pol = "poll question #{i} ?"
  pn.hasother_pol = false
  pn.save
end

for i in 0..100 do 
  pn = Poll.new
  pn.name_pol = "another poll #{i}"
  pn.question_pol = "another poll question #{i} ?"
  pn.hasother_pol = true
  pn.save
end

a = Poll.find(:all)
require 'pp';
pp a;
