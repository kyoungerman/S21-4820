#!/bin/bash
	

# -----------------------------------------------------------------------------------------------------------------
#  9. Login
# -----------------------------------------------------------------------------------------------------------------

function login_user {

	curl -H 'Accept: application/json' "http://localhost:7001/api/v2/login?username=$1@gmail.com&password=abcdefghi123" \
		-o out/login.$2.out
	cat out/login.$2.out
	echo
	if grep "status.*success" out/login.$2.out ; then
		:
	else
		echo "Failed to login"
		exit 1
	fi

}


if [ -f ./out/login.802.out ] ; then
	# curl -H 'Accept: application/json' "http://localhost:7001/api/v2/register?username=testlogin@gmail.com&real_name=Test+Login&password=abcdefghi123&again=abcdefghi123&registration_token=${REG_KEY}" -o out/register.1.out
	login_user "testlogin" 801
	echo Login Completed
fi

jwt_token=$( jq .jwt_token out/login.801.out | sed -e 's/"//g' )



# mux.Handle("/api/v1/run-sql-in-db", http.HandlerFunc(HandleRunSQLInDatabase)).DocTag("<h2>/api/v1/status")

curl \
	-H "Authorization: bearer ${jwt_token}"  \
	-H 'Accept: application/json' \
	"http://localhost:7001/api/v1/run-sql-in-db?stmt=select%20n%20as%20ttt%20from%20tat&homwork_no=02" \
		-o out/run-button.out

echo
cat out/run-button.out

