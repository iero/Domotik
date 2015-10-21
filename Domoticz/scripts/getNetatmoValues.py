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
import logging

def checkIfUpdate(idx,lastmesure) :
	url="http://"+domoticz+"/json.htm?type=devices&rid="+str(idx)
	jsonresult=json.load(urllib2.urlopen(url))
	lstudt=None
	for i, v in enumerate(jsonresult["result"]):
		lastupdate=jsonresult["result"][i]["LastUpdate"]
		#print lastupdate
		lstudt=int(time.mktime(datetime.datetime.strptime(lastupdate, "%Y-%m-%d %H:%M:%S").timetuple()))
	if lstudt is not None and lastmesure is not None :
		delta =  lastmesure-lstudt
		#print delta
		if delta > 0 : return True
	return False

def updateCounterSensor(idx,value,lastmesure) :
	logging.basicConfig(filename='/home/pi/domoticz/www/rain.log',level=logging.DEBUG)
	log=datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")+":"+str(value)

	if checkIfUpdate(idx,lastmesure) :
		url="http://"+domoticz+"/json.htm?type=command&param=udevice&idx="+str(idx)+"&svalue="+str(value)
		json.load(urllib2.urlopen(url))
		log=log+":updated"
	logging.debug(log)
	return

def updateSensor(idx,value,lastmesure) :
	if checkIfUpdate(idx,lastmesure) :
		url="http://"+domoticz+"/json.htm?type=command&param=udevice&idx="+str(idx)+"&nvalue=0&svalue="+str(value)
		json.load(urllib2.urlopen(url))
	return

def updateTempHumSensor(idx,value1,value2,lastmesure) :
	if checkIfUpdate(idx,lastmesure) :
		url="http://"+domoticz+"/json.htm?type=command&param=udevice&idx="+str(idx)+"&nvalue=0&svalue="+str(value1)+";"+str(value2)+";0"
		json.load(urllib2.urlopen(url))
	return

def updateTempHumBaroSensor(idx,value1,value2,value3,lastmesure) :
	if checkIfUpdate(idx,lastmesure) :
		url="http://"+domoticz+"/json.htm?type=command&param=udevice&idx="+str(idx)+"&nvalue=0&svalue="+str(value1)+";"+str(value2)+";2;"+str(value3)+";0"
		json.load(urllib2.urlopen(url))
	return

def updateRainSensor(idx,value,lastmesure) :

	if checkIfUpdate(idx,lastmesure) :
		url="http://"+domoticz+"/json.htm?type=command&param=udevice&idx="+str(idx)+"&nvalue=0&svalue="+str(value)+";"+str(value)
		json.load(urllib2.urlopen(url))
	return

def updateAirQualitySensor(idx,value,lastmesure) :
	if checkIfUpdate(idx,lastmesure) :
		url="http://"+domoticz+"/json.htm?type=command&param=udevice&idx="+str(idx)+"&nvalue="+str(value)
		json.load(urllib2.urlopen(url))
	return

def logMsg() :
	url="http://"+domoticz+"/json.htm?type=command&param=addlogmessage&message=Netatmo_updated"
	json.load(urllib2.urlopen(url))
	return

# get netatmo data

authorization = lnetatmo.ClientAuth()
devList = lnetatmo.DeviceList(authorization)

domoticz = "127.0.0.1:8080"

INDOOR_IDX=81
INDOOR_TEMP=-99
INDOOR_HUM=-99
INDOOR_PRESSURE=-99
INDOOR_PRESSURE_IDX=50
INDOOR_CO2_IDX=55
INDOOR_NOISE_IDX=49

MODULE_TEMP_HUM_IDX=79
MODULE_TEMP=-99
MODULE_HUM=-99
MODULE_CO2_IDX=47

OUTDOOR_IDX=78
OUTDOOR_TEMP=-99
OUTDOOR_HUM=-99

RAIN_IDX=80
RAIN_COUNT_IDX=88

lastindoormesure=None
lastoutdoormesure=None
lastmodulemesure=None

# For each available module in the returned data that should not be older than one hour (3600 s) from now
for module, moduleData in devList.lastData(exclude=3600).items() :
    #print(module)

    lastmesure=None
    for sensor, value in moduleData.items() :
        if sensor == "When" : lastmesure=int(value)

    # List key/values pair of sensor information (eg Humidity, Temperature, etc...)
    for sensor, value in moduleData.items() :
        #print("%30s : %s" % (sensor, value))

	if module == "Indoor" :	
		lastindoormesure=lastmesure
		if sensor == "Temperature" : INDOOR_TEMP=value
		if sensor == "Humidity" : INDOOR_HUM=value
		if sensor == 'Pressure' : INDOOR_PRESSURE=value
		if sensor == 'CO2' : updateAirQualitySensor(INDOOR_CO2_IDX,value,lastmesure)
		if sensor == 'Noise' : updateSensor(INDOOR_NOISE_IDX,value,lastmesure)

	if module == "Module" :
		lastmodulemesure=lastmesure
		if sensor == "Temperature" : MODULE_TEMP=value
		if sensor == "Humidity" : MODULE_HUM=value
		if sensor == 'CO2' : updateAirQualitySensor(MODULE_CO2_IDX,value,lastmesure)

	if module == "Outdoor" :	
		lastoutdoormesure=lastmesure
		if sensor == "Temperature" : OUTDOOR_TEMP=value
		if sensor == "Humidity" : OUTDOOR_HUM=value

	if module == "Pluvio" :	
		if sensor == 'Rain' : 
			v=float(value)*100
			updateCounterSensor(RAIN_COUNT_IDX,v,lastmesure)
		if sensor == 'sum_rain_1' : updateRainSensor(RAIN_IDX,value,lastmesure)

if INDOOR_TEMP != 99 and INDOOR_HUM != 99 and INDOOR_PRESSURE != 99 :
	updateTempHumBaroSensor(INDOOR_IDX,INDOOR_TEMP,INDOOR_HUM,INDOOR_PRESSURE,lastindoormesure)
	#print 'Indoor module updated'

if MODULE_TEMP != 99 and MODULE_HUM != 99 :
	updateTempHumSensor(MODULE_TEMP_HUM_IDX,MODULE_TEMP,MODULE_HUM,lastmodulemesure)
	#print 'Module module updated'

if OUTDOOR_TEMP != 99 and OUTDOOR_HUM != 99 :
	updateTempHumSensor(OUTDOOR_IDX,OUTDOOR_TEMP,OUTDOOR_HUM,lastoutdoormesure)
	#print 'Outdoor module updated'

