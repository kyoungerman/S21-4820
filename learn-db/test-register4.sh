#!/bin/bash

#if [ -f ./out/jwt-token.dat ] ; then
#	JWR="$(cat ./out/jwt-token.dat)"
#else
#	echo "Missing loin info, ./out/jwt-token.dat"
#	exit 1
#fi

# -----------------------------------------------------------------------------------------------------------------
#  5. Register
# -----------------------------------------------------------------------------------------------------------------

function create_user {

	curl -H 'Accept: application/json' "http://localhost:7001/api/v2/register?username=$1@gmail.com&real_name=Test+Login&password=abcdefghi123&again=abcdefghi123&registration_token=${REG_KEY}" \
		-o out/register.$2.out
	cat out/register.$2.out
	echo
	if grep "status.*success" out/register.$2.out ; then
		:
	else
		echo "Failed to register"
		exit 1
	fi

	# "jwt_token": "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRoX3Rva2VuIjoiOWViMDY3ZDQtY2M1Ni00OWE5LTYwNDEtMjRjMzhjMGJhNTI4IiwidXNlcl9pZCI6IjJiMTA4NDM0LWUxNDktNDFmMC00NjExLTg3MWFlYzBiZjlhMCJ9.0UAUBA3GYVBcShLl-NoyPq9xnVxEv0jRvtOEyfKk0Z2kVy6OX69qD4ZoMNI5MDTNtSQJLbGVs8bWdOw3Fmv1dA",
	# "user_id": "2b108434-e149-41f0-4611-871aec0bf9a0",
	jwt_token=$( jq .jwt_token out/register.$2.out | sed -e 's/"//g' )
	user_id=$( jq .user_id out/register.$2.out | sed -e 's/"//g' )
	echo "jwt_token=${jwt_token} user_id=${user_id}"	

	echo "${jwt_token}" >out/jwt-token-$2.dat
	echo "${user_id}" >out/user_id-$2.dat
	
	curl  \
		-H "Authorization: bearer ${jwt_token}"  \
		-H 'Accept: application/json' "http://localhost:7001/api/v1/ct_login?user_id=${user_id}&__method__=POST&pg_acct=acct$2&class_no=$3&lang_to_use=$4" \
		-o out/ct_login.$2.out
	cat out/ct_login.$2.out
	echo
	if grep "status.*success" out/ct_login.$2.out ; then
		:
	else
		echo "Failed to add additional info"
		exit 1
	fi

}


create_user "user1" "001" "4280"     "PostgreSQL"
create_user "user2" "002" "4280"     "PostgreSQL"
create_user "user3" "003" "4010-BC"	 "Go"
create_user "user4" "004" "4010-BC"	 "Go"

#CREATE TABLE ct_login (
#	  user_id					m4_uuid_type() not null primary key -- 1 to 1 to t_ymux_user."id"
#	, pg_acct					char varying (20) not null
#	, class_no					text default '4010-BC' not null				-- 4280 or 4010-BC - one of 2 classes
#	, lang_to_use				text default 'Go' not null				-- Go or PostgreSQL
