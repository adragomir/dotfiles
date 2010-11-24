#!/usr/bin/perl

# this script switches between the TUN drivers needed for Cisco and the drivers
# needed for OpenVPN on Mac OSX.

# usage: "vpnswitch cisco" or "vpnswitch open"

# written by Josh Berkus 2009.  Freely offered to the public domain.
# If your jurisdiction doesn't support that, then it is also available under the
# BSD License.

my ( $mode ) = @ARGV;

if ( $mode =~ /^c/i ) {
   system ("sudo kextunload /Library/Extensions/tun.kext");
   system ("sudo kextunload /Library/Extensions/tap.kext");
   system ("sudo /System/Library/StartupItems/CiscoTUN/CiscoTUN start");
} elsif ( $mode =~ /^o/i ) {
   system ("sudo /System/Library/StartupItems/CiscoTUN/CiscoTUN stop");
   system ("sudo kextload /Library/Extensions/tun.kext");
   system ("sudo kextload /Library/Extensions/tap.kext");
} else {
  print "missing parameter\n";
}

exit(0);
