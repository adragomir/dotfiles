#! /bin/bash
wget -q -O- www.showmyip.com/xml | xml2 | grep '/ip_address/ip=' | cut -d= -f2
