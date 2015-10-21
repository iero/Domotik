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

def updateSensor(idx,level,text) :
        url="http://"+domoticz+"/json.htm?type=command&param=udevice&idx="+str(idx)+"&nvalue="+str(level)+"&svalue="+str(text)
        json.load(urllib2.urlopen(url))
        return

domoticz="127.0.0.1:8080"
alert_idx=97
zone='9205000'

url="http://www.meteo-france.mobi/ws/getPluie/"+zone+".json"
js=json.load(urllib2.urlopen(url))

# Actual date
now = time.time()

# Parse

firstRainDelta=9999
firstRainForce=""
firstRainValue=0

logging.basicConfig(filename='/home/pi/domoticz/www/meteo.log',level=logging.DEBUG)
log=datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")+":"

for result in js['result']['intervalles'] :
	d = int(result['date'])/1000
	t = time.strftime("%H:%M:%S",time.localtime(d))
	v = int(result['value'])
	log=log+str(v)+":"
	if (v >=2 ) :
		if (firstRainValue < v) : firstRainValue=v
		delta = int(round((d - now)/60))
		#print str(delta) + " minutes"
		if (firstoRainDelta > delta) : 
			log=log+str(delta)+" min:"
			firstRainDelta = delta
			if (v==2) : firstRainForce="faible"
			elif (v==3) : firstRainForce="modéree"
			elif (v==4) : firstRainForce="forte"

if (firstRainDelta < 9999 ) :
	msg="Pluie%20"+firstRainForce+"%20dans%20"+firstRainDelta+"%20minutes"
	updateSensor(alert_idx,firstRainValue,msg)
else :
	updateSensor(alert_idx,1,"Pas%20de%20pluie")

logging.debug(log)
