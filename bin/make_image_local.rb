#!/usr/bin/env ruby

require 'uri'
require 'nokogiri'

doc = Nokogiri::HTML::Document.parse File.open(ARGV[0])
current_index = 1
doc.xpath("//img").each { |img|
  path = img["src"]
  fn = URI(path).path.split('/').last
  if File.exists?(fn)
    ext = File.extname(fn)
    new_file_name = "#{current_index.to_s}#{ext}"
    File.rename(fn, new_file_name)
    img["src"] = ARGV[1] + "/" + new_file_name
    current_index += 1
  end
}
puts doc.to_html
