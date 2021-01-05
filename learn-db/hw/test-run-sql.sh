

# wget -o out/run-sql.err -O out/run-sql.out \
jwt_token=$( jq .jwt_token out/register.$2.out | sed -e 's/"//g' )
echo "jwt_token=${jwt_token}"

curl  \
	-H "Authorization: bearer ${jwt_token}"  \
	-H 'Accept: application/json' \
	'http://localhost:7001/api/v1/run-sql-in-db?homework_id=7185233a-bc4e-4d5a-7dee-f572ed1cd622&stmt=CREATE%20TABLE%20name2_list%20(%0A%09real_name%20text%2C%09%0A%09age%20int%2C%09%0A%09state%20varchar(2)%0A)%3B&_ran_=5419832.447221793' \
	-i \
	-o out/run-sql.2.out 2>,err >,out

cat out/run-sql.2.out

