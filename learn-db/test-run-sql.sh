

# jwt-token-001.dat
# jwt-token-002.dat
# jwt-token-003.dat
# jwt-token-004.dat

# jwt_token=$( jq .jwt_token out/register.$2.out | sed -e 's/"//g' )
jwt_token="$( cat ./out/test1.jwt )"
echo "jwt_token=${jwt_token}"

#curl  \
#	-H "Authorization: bearer ${jwt_token}"  \
#	-H 'Accept: application/json' \
#	'http://localhost:7001/api/v1/run-sql-in-db?homework_id=7185233a-bc4e-4d5a-7dee-f572ed1cd622&stmt=CREATE%20TABLE%20name2_list%20(%0A%09real_name%20text%2C%09%0A%09age%20int%2C%09%0A%09state%20varchar(2)%0A)%3B&_ran_=5419832.447221793' \
#	-o out/run-sql.2.out \
#	-I -w "http_code=%{http_code}\nerrormsg=%{errormsg}\n%{json}"  \
#	2>,err >,out 

wget -o ./out/run-sql.2.err -O ./out/run-sql.2.out \
	--header="Authorization: bearer ${jwt_token}"  \
	--header='Accept: application/json' \
	'http://localhost:7001/api/v1/run-sql-in-db?lesson_id=01&homework_id=7185233a-bc4e-4d5a-7dee-f572ed1cd622&stmt=%0Adrop%20table%20if%20exists%20name2_list%3B%0Acreate%20table%20name2_list%20%28%20a%20int%20%29%3B%0Ainsert%20into%20name2_list%20%28%20a%20%29%20values%20%28%2012%20%29%2C%20%28%2014%20%29%3B%0Aselect%20%2A%20from%20name2_list%3B%0A&_ran_=3339832.447221793' \

echo "Error ====================="
cat out/run-sql.2.err
echo "Out ====================="
cat out/run-sql.2.out
echo ""

