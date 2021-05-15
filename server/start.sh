#!/bin/bash

# ip addresses of zones
IP1='173.20.1.0/24'
IP2='173.20.2.0/24'
IP3='173.20.3.0/24'
IP4='173.20.4.0/24'

# create incoming traffic interface
ip link add dev ifb0 type ifb
ip link set dev ifb0 up

tc qdisc add dev eth0 handle ffff: ingress
# redirect traffic
tc filter add dev eth0 parent ffff: protocol ip u32 match u32 0 0 action mirred egress redirect dev ifb0
tc qdisc add dev ifb0 root handle 1:0 htb default 1

tc qdisc add dev eth0 root handle 1: htb default 900
tc class add dev eth0 parent 1:0 classid 1:1 htb rate 10mbit prio 1

# ignore every icmp packet
tc filter add dev ifb0 protocol ip parent 1:0 prio 1 u32 match ip protocol 1 0xff action drop

# first zone
tc class add dev eth0 parent 1:1 classid 1:11 htb rate 100kbit ceil 4mbit prio 1
tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 match ip dst ${IP1} flowid 1:11

# second zone
tc class add dev eth0 parent 1:1 classid 1:12 htb rate 100kbit ceil 2mbit prio 1
tc class add dev eth0 parent 1:1 classid 1:121 htb rate 100kbit ceil 2mbit prio 2
tc filter add dev eth0 parent 1:0 protocol ip prio 2 u32 match ip dst ${IP2} match ip protocol 17 0xff flowid 1:121
tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 match ip dst ${IP2} flowid 1:12

# third zone
tc class add dev eth0 parent 1:1 classid 1:13 htb rate 100kbit ceil 2mbit prio 1
tc filter add dev eth0 protocol ip parent 1:0 prio 1 u32 match ip dst ${IP3} flowid 1:13
tc filter add dev ifb0 protocol ip parent 1:0 prio 1 u32 match ip src ${IP3} match ip protocol 6 0xff match ip dport 22 0xffff action drop

# fourth zone
tc class add dev eth0 parent 1:1 classid 1:14 htb rate 100kbit ceil 2mbit prio 1
tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 match ip dst ${IP4} flowid 1:14

# others
tc class add dev eth0 parent 1:1 classid 1:900 htb rate 1kbit ceil 1kbit prio 1
tc filter add dev eth0 parent 1:0 protocol ip prio 1 u32 flowid 1:900

#start ssh
service ssh start

# sleep for not exit
sleep infinity