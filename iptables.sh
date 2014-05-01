#!/bin/bash

#backup
iptables-save > ~/iptables.bak

/etc/init.d/iptables stop

#rule delete
iptables -F

#ssh setting
SSH_ACCEPT_IP[0]=192.168.56.1

for IP in ${SSH_ACCEPT_IP[@]}
do
iptables -A INPUT -s $IP -p tcp --dport 22 -j ACCEPT
done

iptables -A INPUT -p tcp --dport 22 -j LOG --log-level debug --log-prefix [IPTABLES_SSH_DROP]:
iptables -A INPUT -p tcp --dport 22 -j DROP

/etc/init.d/iptables save
/etc/init.d/iptables start
