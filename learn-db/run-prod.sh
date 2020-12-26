#!/bin/bash

if [ "$(hostname)" == "prod0001" ] ; then
	cp prod-cfg.js ./www/js/cfg.js
else
	cp dev-cfg.js ./www/js/cfg.js
fi

xx=$( ps -ef | grep q8s-service.linux | grep -v grep | awk '{print $2}' )
if [ "X$xx" == "X" ] ; then	
	:
else
	kill $xx
fi

(
while true ; do 
	if [ -f ./set-env.sh ] ; then
		. ./set-env.sh
	fi
	./q8s-service.linux -cfg ./prod-cfg.json -hostport "192.154.97.76:7001,127.0.0.1:7001" 2>&1  >/tmp/q8s-service.out 
	sleep 1 
done
) 2>&1 > /tmp/q8s-service.2.out &
