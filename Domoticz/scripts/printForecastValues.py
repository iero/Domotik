#!/usr/bin/python
# encoding=utf-8
# -*- coding: utf-8 -*-

import math
import time
import datetime
import locale # http://docs.python.org/library/locale.htmls
import forecastio

# get forecast io weather

api_key = "FORECAST API"
lat = 40.8827
lng = 2.4998
units = "si"

forecast = forecastio.load_forecast(api_key, lat, lng, time=None, units="si")
by_day = forecast.daily()

# forecast data
print "-- Now --"
print'Icon : {0}'.format(forecast.hourly().data[0].icon)
print'Summary : {0}'.format(forecast.hourly().data[0].summary)
print'Temperature actuelle : {0}'.format(forecast.hourly().data[0].temperature)
print'Temperature resentie : {0}'.format(forecast.hourly().data[0].apparentTemperature)

print "-- Today --"
print by_day.data[0].summary
print by_day.data[0].icon
print'Proba de pluie : {0}'.format(by_day.data[0].precipProbability)
print'Temp(Min/Max) : {0}degC a {1}degC'.format(by_day.data[0].temperatureMin, by_day.data[0].temperatureMax)
print'Humidite : {0}%'.format(by_day.data[0].humidity)
print'Pression : {0}%'.format(by_day.data[0].pressure)

print'Vent : {0}'.format(by_day.data[0].windSpeed)
print'sunrise : {0}'.format(by_day.data[0].sunriseTime)
print'sunset : {0}'.format(by_day.data[0].sunsetTime)
print'Lune : {0}'.format(by_day.data[0].moonPhase)

print "-- Tomorrow --"
print by_day.data[1].summary
print by_day.data[1].icon
print'Proba de pluie : {0}'.format(by_day.data[1].precipProbability)
print'Temp(Min/Max) : {0}degC a {1}degC'.format(by_day.data[1].temperatureMin, by_day.data[1].temperatureMax)
print'ApparentTemp(Min/Max) : {0}degC a {1}degC'.format(by_day.data[1].apparentTemperatureMin, by_day.data[1].apparentTemperatureMax)
print'Humidite : {0}%'.format(by_day.data[1].humidity)
print'Pression : {0}%'.format(by_day.data[1].pressure)

print "--Pluie heure par heure--"
#print'Proba de pluie {0}'.format(forecast.minutely().data[0].temperature)
print'Proba de pluie {0}'.format(len(forecast.minutely().data))
print'Proba de pluie {0}'.format(len(forecast.hourly().data))
for i in range(5) :
	print'{0}'.format(i)
	print'Proba de pluie {0}h : {1}'.format(i,forecast.hourly().data[i].precipProbability)


