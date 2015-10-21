#!/usr/bin/python
# encoding=utf-8
# -*- coding: utf-8 -*-

import math
import time
import datetime
import locale # http://docs.python.org/library/locale.htmls
import json
import urllib2
import logging

def updateSensor(idx,value1,value2) :
	if (value1 is None or value2 is None) : return
	url="http://"+domoticz+"/json.htm?type=command&param=udevice&idx="+str(idx)+"&nvalue=0&svalue="+str(value1)+";"+str(value2)+";0"
	json.load(urllib2.urlopen(url))
	return

def updateSimpleSensor(idx,value) :
	if (value is None) : return
	url="http://"+domoticz+"/json.htm?type=command&param=udevice&idx="+str(idx)+"&nvalue=0&svalue="+str(value)+";0"
	json.load(urllib2.urlopen(url))
	return

def getSensorValue(ip,tag) :
	url="http://"+ip+"/"+tag
	try:
                result=urllib2.urlopen(url,timeout=5)
                v=result.read()
		if (v==85) : return None
		else : return v
        except IOError:
                return None
	
def processTSensor(name,ip,idx):
	t=getSensorValue(ip,"temp")
	if (t is None) : return
	print name+" : "+t+" deg"
	updateSimpleSensor(idx,t)

def processTHSensor(name,ip,idx):
	t=getSensorValue(ip,"temp")
	h=getSensorValue(ip,"humidity")
	if (t is None or h is None) : return
	print name+" : "+t+" deg and "+h+"%"
	updateSensor(idx,t,h)

def processTMSensor(name,ip,idx):
	t=getSensorValue(ip,"temp")
	h=getSensorValue(ip,"moist")
	if (t is None or h is None) : return
	print name+" : "+t+" deg and "+h+"%"
	updateSensor(idx,t,h)

domoticz = "127.0.0.1:8080"

processTHSensor("Cave","10.0.1.51",76)
processTSensor("Entree","10.0.1.54",99)
processTMSensor("Tiare","10.0.1.52",90)
processTMSensor("Mimosa","10.0.1.53",98)
processTSensor("Marion","10.0.1.55",101)

