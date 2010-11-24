#!/bin/bash
sudo /usr/sbin/pppd /dev/tty.bt 115200 noauth local passive proxyarp asyncmap 0 silent persist :192.168.1.100 &
sudo /usr/sbin/sysctl -w net.inet.ip.forwarding=1
sudo /usr/sbin/natd -same_ports -use_sockets -log -deny_incoming -interface en1
sudo /sbin/ipfw add divert natd ip from any to any via en1
