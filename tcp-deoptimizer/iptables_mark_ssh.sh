#!/bin/bash
iptables -N TOP
iptables -I OUTPUT -j TOP
iptables -A TOP -p tcp --dport 22 -j RETURN
iptables -A TOP -p tcp --sport 22 -j RETURN
iptables -A TOP -j MARK --set-mark 9

service iptables save
