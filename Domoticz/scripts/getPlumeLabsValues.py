#!/usr/bin/python
# encoding=utf-8
# -*- coding: utf-8 -*-

import math
import time
import datetime
import locale # http://docs.python.org/library/locale.htmls
import json
import urllib2
from collections import OrderedDict

def updateSensor(idx,value) :
        url="http://"+domoticz+"/json.htm?type=command&param=udevice&idx="+str(idx)+"&nvalue="+str(value)
        json.load(urllib2.urlopen(url))
        return

def updateAlertSensor(idx,level,text) :
        url="http://"+domoticz+"/json.htm?type=command&param=udevice&idx="+str(idx)+"&nvalue="+str(level)+"&svalue="+str(text)
        json.load(urllib2.urlopen(url))
        return

PLUME_zone='PARIS'

domoticz="127.0.0.1:8080"

overall_idx=91
pm2_5_idx=92
pm10_idx=93
o3_idx=94
no2_idx=95
alert_idx=102

pol_val=0
pol_level=0
pol_date=""

url_prediction="https://api.plumelabs.com/0.1/prediction.php?zone="+PLUME_zone
json_result=json.load(urllib2.urlopen(url_prediction))

# Actual date
now = datetime.datetime.now()
h=str(now.year)+'-'+str(now.month)+'-'+str(now.day)+' '+str(now.hour)+':00:00'
t=int(time.mktime(datetime.datetime.strptime(h, '%Y-%m-%d %H:%M:%S').timetuple()))
#print t

# Make houry a dictionary
json_result['hourly'] = OrderedDict((item['timestamp'], item) for item in json_result['hourly'])

for id, item in json_result['hourly'].iteritems():
	dt = time.strftime("%Y-%m-%d_%H:%M:%S",time.localtime(id))
	ho = time.strftime("%H",time.localtime(id))
	#print id
	#print dt
	for it, type in item.iteritems(): 
		if it=="avg" :
			for s, value in type.iteritems(): 
				if (value['pi'] > pol_val) :
					pol_val = value['pi']
					pol_date=ho
					if (pol_val < 20) : pol_level=1
					elif (pol_val >= 150) : pol_level=5
					elif (pol_val >= 100) : pol_level=4
					elif (pol_val >= 50) : pol_level=3
					else : pol_level=2
				if (id==t):
					if (s=='overall'): updateSensor(overall_idx,value['pi'])
					if (s=='PM2_5'): updateSensor(pm2_5_idx,value['value_upm'])
					if (s=='PM10'): updateSensor(pm10_idx,value['value_upm'])
					if (s=='O3'): updateSensor(o3_idx,value['value_upm'])
					if (s=='NO2'): updateSensor(no2_idx,value['value_upm'])

if (pol_level==1) : msg="Air%20pur%20toute%20la%20journee"
elif (pol_level==2) : msg="Pollution%20moderee%20aujourdhui"
elif (pol_level==2) : msg="Forte%20pollution%20a%20"+pol_date+"%20h"
elif (pol_level==3) : msg="Forte%20pollution%20a%20"+pol_date+"%20h"
elif (pol_level==4) : msg="Tres%20forte%20pollution%20a%20"+pol_date+"%20h"
elif (pol_level==5) : msg="Pollution%20extreme%20a%20"+pol_date+"%20h"
updateAlertSensor(alert_idx,pol_level,msg)
