#!/opt/local/bin/ruby
require 'rexml/document'
include REXML

doc = Document.new File.new("#{ARGV[0]}")
require 'pp'

output = "<html><head>"
output += "<title>~#{doc.elements.to_a("//dc:Title")[0].text}</title>"

doc.elements.each("package/manifest/item") { |el|
  html_fname = el.attributes["href"]
  puts "converting #{html_fname}...\n"
  if html_fname.match(/\.html$/)
    doc_xhtml = Document.new File.new("#{html_fname}")
    doc_xhtml.elements.each("//a") { |link|
      if link.attributes["href"].to_s.match(/.*#.*/)
        hr = link.attributes["href"].to_s
        puts ("replacing: #{hr}")
        new_href = hr.gsub(/([^#]*)#([^#]*)/, '#\2')
        puts ("replacing link: #{hr} with #{ARGV[1] + new_href}")
        link.attributes["href"] = ARGV[1] + new_href
      end
    }
    body_content = doc_xhtml.elements.to_a("//body")[0].to_s
    puts "body content for `#{html_fname}: #{body_content.length} "
    output += body_content#doc_xhtml.elements.to_a("//body")[0].to_s
  end
}

output_f = File.new(ARGV[1], "wb+")
output_f.write(output)
output_f.close()