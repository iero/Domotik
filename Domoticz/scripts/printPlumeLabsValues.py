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

PLUME_zone='PARIS'

url_prediction="https://api.plumelabs.com/0.1/prediction.php?zone="+PLUME_zone
json_result=json.load(urllib2.urlopen(url_prediction))

# Actual date
now = datetime.datetime.now()
h=str(now.year)+'-'+str(now.month)+'-'+str(now.day)+' '+str(now.hour)+':00:00'
t=int(time.mktime(datetime.datetime.strptime(h, '%Y-%m-%d %H:%M:%S').timetuple()))
print t

# Make houry a dictionary
json_result['hourly'] = OrderedDict((item['timestamp'], item) for item in json_result['hourly'])

pol_val=0
pol_level=0
pol_date=""

for id, item in json_result['hourly'].iteritems():
	dt = time.strftime("%Y-%m-%d_%H:%M:%S",time.localtime(id))
	ho = time.strftime("%H:%M",time.localtime(id))
	#print id
	print dt
	for it, type in item.iteritems(): 
		if it=="avg" :
			for s, value in type.iteritems(): 
				if (s=='overall'): 
					if (value['pi'] > pol_val) :
						pol_val = value['pi']
						pol_date=ho
						if (pol_val < 20) : pol_level=1
						elif (pol_val >= 150) : pol_level=5
						elif (pol_val >= 100) : pol_level=4
						elif (pol_val >= 50) : pol_level=3
						else : pol_level=2

print(pol_date)
print(pol_val)
print(pol_level)
