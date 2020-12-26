#!/bin/bash

# -----------------------------------------------------------------------------------------------------------------
#  9. Login
# -----------------------------------------------------------------------------------------------------------------

function login_user {

	curl -H 'Accept: application/json' "http://localhost:7001/api/v2/login?username=$1@gmail.com&password=abcdefghi123" \
		-o out/register.$2.out
	cat out/register.$2.out
	echo
	if grep "status.*success" out/register.$2.out ; then
		:
	else
		echo "Failed to login"
		exit 1
	fi

}


login_user "user1" 201
login_user "user2" 202
login_user "user3" 203
login_user "user4" 204

