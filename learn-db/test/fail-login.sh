#!/bin/bash

#
# return success for a failed login.
# return failure (exit 1) for a successful login.
#
# $1 - username
# $2 - password
# $3 - outputFn
#

wget -o out/$3.o -O out/$3.oo "http://127.0.0.1:7001/api/v2/login?username=$1&password=$2"
if jq .status out/$3.oo | grep success >/dev/null	; then				# Verify responce is success
	exit 1
else
	exit 0
fi

