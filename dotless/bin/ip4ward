#!/bin/sh
#
# rc.firewall-2.4
FWVER=0.70

echo -e "\n\nLoading simple rc.firewall version $FWVER..\n"

IPTABLES=/usr/sbin/iptables
DEPMOD=/sbin/depmod
INSMOD=/sbin/insmod

EXTIF="eth0"
INTIF="tun0"
echo " External Interface:  $EXTIF"
echo " Internal Interfaces: $INTIF"

echo -e " loading modules: "

echo "  - Verifying that all kernel modules are ok"
$DEPMOD -a

echo -en "	"
for mod in ip_tables ip_conntrack ip_conntrack_ftp ip_conntrack_irc iptable_nat ip_nat_ftp ip_nat_irc ipt_filter iptable_filter iptable_nat ipt_state ipt_LOG ipt_MASQUERADE iptable_mangle ipt_MARK sch_cbq cls_fw ; do
	$INSMOD $mod >/dev/null 2>/dev/null
	echo -en "$mod, "
done


echo -e ".\n Done loading modules."

echo " enabling forwarding.."
echo "1" > /proc/sys/net/ipv4/ip_forward

echo " enabling DynamicAddr.."
echo "1" > /proc/sys/net/ipv4/ip_dynaddr

echo " clearing any existing rules and setting default policy.."
$IPTABLES -P INPUT ACCEPT
$IPTABLES -F INPUT
$IPTABLES -P OUTPUT ACCEPT
$IPTABLES -F OUTPUT
$IPTABLES -P FORWARD DROP
$IPTABLES -F FORWARD
$IPTABLES -t nat -F

echo -n " Closing some Ports on $EXTIF: "
for x in rpc2portmap sunrpc shilp filenet-nch filenet-tms 809 3306 4000 6000 ; do
	$IPTABLES -A INPUT -i $EXTIF -p tcp --dport $x -j DROP
	echo -n "$x "
done
echo

echo " FWD: Allow all connections OUT and only existing and related ones IN"
for x in $INTIF ; do
$IPTABLES -A FORWARD -i $EXTIF -o $x -m state --state ESTABLISHED,RELATED -j ACCEPT
$IPTABLES -A FORWARD -i $EXTIF -o $x -j ACCEPT
$IPTABLES -A FORWARD -i $x -o $EXTIF -j ACCEPT
done
echo " FWD: Logging all forwarded connections"
$IPTABLES -A FORWARD -j LOG

echo " Enabling SNAT (MASQUERADE) functionality on $EXTIF"
$IPTABLES -t nat -A POSTROUTING -o $EXTIF -j MASQUERADE
