#!/usr/bin/python
# encoding=utf-8
# -*- coding: utf-8 -*-

from scapy.all import *

def arp_display(pkt):
  if pkt[ARP].op == 1: #who-has (request)
    if pkt[ARP].psrc == '0.0.0.0': # ARP Probe
      if pkt[ARP].hwsrc == '74:75:48:4a:0b:e8': # But 1
        print "Pushed Button 1"
      elif pkt[ARP].hwsrc == '10:ae:60:00:4d:f3': # Elements
        print "Pushed Elements"
      else:
        print "ARP Probe from unknown device: " + pkt[ARP].hwsrc

print sniff(prn=arp_display, filter="arp", store=0, count=10)
