#!/bin/bash

YUNSERVER="ieroYun.local"
YUNUSER="root"
YUNPWD="arduin0yun"

DOMOTICZ="127.0.0.1:8080"
DEVICEIDX="36"
UPTIMEIDX="72"

TEMP=$(curl -u ${YUNUSER}:${YUNPWD} -s http://${YUNSERVER}/arduino/temperature)
HUM=$(curl -u ${YUNUSER}:${YUNPWD} -s http://${YUNSERVER}/arduino/humidity)
UPTIME=$(curl -u ${YUNUSER}:${YUNPWD} -s http://${YUNSERVER}/arduino/uptime)

if [ $TEMP ] && [ $HUM ] ; then
	curl -s -i -H "Accept: application/json" "http://${DOMOTICZ}/json.htm?type=command&param=udevice&idx=${DEVICEIDX}&nvalue=0&svalue=$TEMP;$HUM;2"
fi

if [ $UPTIME ] ; then
	curl -s -i -H "Accept: application/json" "http://${DOMOTICZ}/json.htm?type=command&param=udevice&idx=${UPTIMEIDX}&nvalue=0&svalue=$UPTIME"
fi
