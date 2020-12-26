#!/bin/bash

# -----------------------------------------------------------------------------------------------------------------
#  9. Login
# -----------------------------------------------------------------------------------------------------------------

JWR=""

function login_user {

	if [ -f ./out/login.$2.dat ] ; then
		JWR="$(jq .jwt_token | sed -e 's/"//g' )"
	else

		curl -H 'Accept: application/json' "http://localhost:7001/api/v2/login?username=$1@gmail.com&password=abcdefghi123" \
			-o out/login.$2.out
		cat out/login.$2.out
		echo
		if grep "status.*success" out/register.$2.out ; then
			:
		else
			echo "Failed to login"
			exit 1
		fi

		JWR="$(jq .jwt_token | sed -e 's/"//g' )"

	fi
}

function login_user {
}

login_user "user1" 201

get_lesson_s02


