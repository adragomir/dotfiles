#!/usr/bin/env ruby
require 'pcaplet'
require 'cgi'
httpdump = Pcaplet.new('-s 400000')

HTTP_REQUEST  = Pcap::Filter.new('tcp and dst port 8900', httpdump.capture)
HTTP_RESPONSE = Pcap::Filter.new('tcp and src port 8900', httpdump.capture)

next_is_raw_post = false;

httpdump.add_filter(HTTP_REQUEST | HTTP_RESPONSE)
httpdump.each_packet {|pkt|
  data = pkt.tcp_data

  if (next_is_raw_post && data != nil)

    puts "\tPOST: " + CGI.unescape(data) + "\n\n"
    next_is_raw_post = false;
  else
    case pkt
      when HTTP_REQUEST
        if data and data =~ /^GET\s+(\S+)/
          path = $1
          host = pkt.dst.to_s
          #host << ":#{pkt.dst_port}" if pkt.dport != 80
          s = "#{pkt.src}:#{pkt.sport} > GET http://#{host}#{path}"
        end
        if data and data =~ /^POST\s+(\S+)/
          path = $1
          host = pkt.dst.to_s
          #host << ":#{pkt.dst_port}" if pkt.dport != 80
          s = "#{pkt.src}:#{pkt.sport} > POST http://#{host}#{path}\n"
          data.each_line { |line|
            s += "\t" + line
          }
          next_is_raw_post = true;
        end
      when HTTP_RESPONSE
        if data and data =~ /^(HTTP\/.*)\r\n(.*)/
          status = $1
          body = $2
          s = "#{pkt.dst}:#{pkt.dport} < #{status}"
          data.each_line { |line|
            s += "\t" + line
          }
          s += body
        end
    end
  end
  puts s if s
}

