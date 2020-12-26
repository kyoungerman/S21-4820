#!/bin/bash

mkdir -p out

# ../PureImaginationServer/tools/ac/ac --get2fa "/app.example.com:testlogin@gmail.com" --output out/pin.txt
~/bin/acc --get2fa "/app.example.com:testlogin@gmail.com" --output out/pin.txt

PIN=$(cat out/pin.txt)

curl --request GET -o out/xtest4.oo -s -w "%{http_code}\n" \
	"http://localhost:7001/api/v2/2fa-validate-pin?username=testlogin%40gmail.com&pin2fa=$PIN&__method__=POST&_ran_=538.396" \
	> out/xtest4.status_code

#curl --request GET -v -o out/xtest4.oo -s -I \
#	"http://localhost:7001/api/v2/2fa-validate-pin?username=testlogin%40gmail.com&pin2fa=$PIN&__method__=POST&_ran_=538.396" \
#	> out/xtest4.status_code

if [ "$( cat out/xtest4.status_code )" == "200" ] ; then
	echo "PASS"
else
	echo "FAILED"
fi
