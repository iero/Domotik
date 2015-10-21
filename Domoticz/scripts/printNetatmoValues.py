#!/usr/bin/python
# encoding=utf-8
# -*- coding: utf-8 -*-

import math
import time
import datetime
import locale # http://docs.python.org/library/locale.htmls
import lnetatmo
import json
import urllib2

# get netatmo data

authorization = lnetatmo.ClientAuth()
devList = lnetatmo.DeviceList(authorization)

domoticz="127.0.0.1:8080"
idx=80

url="http://"+domoticz+"/json.htm?type=devices&rid="+str(idx)
jsonresult=json.load(urllib2.urlopen(url))
for i, v in enumerate(jsonresult["result"]):
       lastupdate=jsonresult["result"][i]["LastUpdate"] 
       lstudt=time.mktime(datetime.datetime.strptime(lastupdate, "%Y-%m-%d %H:%M:%S").timetuple())
       

# For each available module in the returned data that should not be older than one hour (3600 s) from now
for module, moduleData in devList.lastData(exclude=3600).items() :

    # Name of the module (or station embedded module), the name you defined in the web netatmo account station management
    print(module)
    lastmesure=None
    for sensor, value in moduleData.items() :
        if sensor == "When" : lastmesure=value

    print'Last updated {0}'.format(lastmesure)
    # List key/values pair of sensor information (eg Humidity, Temperature, etc...)
    for sensor, value in moduleData.items() :
	t=time.time()
        #if sensor == "When" : value = time.strftime("%H:%M:%S",time.localtime(value))
        if sensor == "When" : 
		delta = t- value 
        	value = time.strftime("%H:%M:%S",time.localtime(value))
        	print("%30s : %s sec" % (sensor, delta))
        print("%30s : %s" % (sensor, value))

TOTO=-99
TATA=-99

if TOTO != -99 and TATA != -99 :
  print OK
