#!/bin/bash

mkdir -p /home/pschlump/learn-db
cd /home/pschlump/learn-db

mkdir -p log

echo "PID: $$" >pidfile.leardb

while true ; do
	if [ -f ./set-env.sh ] ; then
		. ./set-evn.sh
	fi
	./learn-db >./log/stdout.out  2>&1
	sleep 1
done

