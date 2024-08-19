#!/bin/bash
#FLUSH ALL
iptables -t nat -F PREROUTING
iptables -t nat -F POSTROUTING
iptables -F
##############################
	#filter#
##############################
### INPUT RULES ###
#Règles INPUT
iptables -A INPUT -p icmp -i enp0s9 -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
#Bloquer le reste
iptables -A INPUT -j REJECT

### FORWARD RULES ###
#Règles forward
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
#iptables -A FORWARD -p icmp -j ACCEPT
iptables -A FORWARD -p tcp --dport 443 -o enp0s3 -i enp0s8 -j ACCEPT
iptables -A FORWARD -p tcp --dport 80 -o enp0s9 -i enp0s8 -j ACCEPT
iptables -A FORWARD -p tcp --dport 22 -i enp0s3 -d 172.16.1.2 -j ACCEPT
iptables -A FORWARD -p udp --dport 53 -o enp0s3 -i enp0s8 -j ACCEPT
iptables -A FORWARD -p tcp --dport 53 -o enp0s3 -i enp0s8 -j ACCEPT
#Bloquer le reste
iptables -A FORWARD -j REJECT

### OUTPUT RULES ###
#Règle output
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
#Bloquer le reste
iptables -A OUTPUT -j REJECT

### NAT RULES ###
#dnat
#iptables -t nat -A PREROUTING -p tcp --dport 61337 -d 192.168.1.12 -j DNAT --to 172.16.1.2:22
#snat
iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE

#iptables -L -v -n
