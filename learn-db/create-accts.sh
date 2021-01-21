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

	last_name="$( echo "$2" | cut -d , -f 1 )"
	first_name="$( echo "$2" | cut -d , -f 2 )"
	real_name="$( echo "${first_name} ${last_name}" | sed -e 's/ /+/g' )"

	curl -H 'Accept: application/json' "http://localhost:7001/api/v2/register?username=$1&real_name=${real_name}&password=$3&again=$3&registration_token=${REG_KEY}" \
		-o out/register.$1.out
	cat out/register.$1.out
	cat out/register.$1.out >>out/register.all.out
	echo
	if grep "status.*success" out/register.$1.out ; then
		:
	else
		echo "Failed to register"
		exit 1
	fi

	# "jwt_token": "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRoX3Rva2VuIjoiOWViMDY3ZDQtY2M1Ni00OWE5LTYwNDEtMjRjMzhjMGJhNTI4IiwidXNlcl9pZCI6IjJiMTA4NDM0LWUxNDktNDFmMC00NjExLTg3MWFlYzBiZjlhMCJ9.0UAUBA3GYVBcShLl-NoyPq9xnVxEv0jRvtOEyfKk0Z2kVy6OX69qD4ZoMNI5MDTNtSQJLbGVs8bWdOw3Fmv1dA",
	# "user_id": "2b108434-e149-41f0-4611-871aec0bf9a0",
	jwt_token=$( jq .jwt_token out/register.$1.out | sed -e 's/"//g' )
	user_id=$( jq .user_id out/register.$1.out | sed -e 's/"//g' )
	echo "jwt_token=${jwt_token} user_id=${user_id}"	

	echo "${jwt_token}" >out/jwt-token-$1.dat
	echo "${user_id}" >out/user_id-$1.dat
	
	curl  \
		-H "Authorization: bearer ${jwt_token}"  \
		-H 'Accept: application/json' "http://localhost:7001/api/v1/ct_login?__method__=POST&pg_acct=$5" \
		-o out/ct_login.$1.out
	cat out/ct_login.$1.out
	echo
	if grep "status.*success" out/ct_login.$1.out ; then
		:
	else
		echo "Failed to add additional info"
		exit 1
	fi

}


#             1                   2            3              4   5
#create_user "user1aad@uwyo.edu" "user 1 aaa" "552211sa99a"  "x" "stmpl" 

#sa01,"Balogun Mohammed, Umar",1881094,pw1881094,ubalogun
#while IFS=, read -r database real_name idno password_raw username
#do
#	password="${password_raw}${database}a"
#    echo "real_name=->${real_name}<- and ${username_raw} and ${password_raw} password=${password} username=${username}"
#	echo create_user "${username}" "${real_name}" "${password}"  "x" "${database}" 
#done < ../instructor/accts-passwords.csv

create_user "ubalogun@uwyo.edu" "Balogun Mohammed, Umar" "pw1881094sa01a" "x" sa01
create_user "tbourque@uwyo.edu" "Bourque, Timothy S" "pw1844740sa02a" "x" sa02
create_user "wbrant@uwyo.edu" "Brant, William Raymond" "pw1870840sa03a" "x" sa03
create_user "tbrown64@uwyo.edu" "Brown, Trent T" "pw1851099sa04a" "x" sa04
create_user "dcaruthe@uwyo.edu" "Caruthers, Duncan" "pw1850749sa05a" "x" sa05
create_user "cchave12@uwyo.edu" "Chavez, Courtney Lauryn" "pw1836865sa06a" "x" sa06
create_user "pday2@uwyo.edu" "Day, Peter" "pw1842839sa07a" "x" sa07
create_user "adelaura@uwyo.edu" "Delaurante, Anthony F" "pw1879174sa08a" "x" sa08
create_user "rdurnan@uwyo.edu" "Durnan, Ryan Andrew" "pw1836421sa09a" "x" sa09
create_user "afinch2@uwyo.edu" "Finch, Alexander C" "pw1057479sa10a" "x" sa10
create_user "wfrost2@uwyo.edu" "Frost, William" "pw1859002sa11a" "x" sa11
create_user "afulle12@uwyo.edu" "Fuller, Andrew Lukas" "pw1843915sa12a" "x" sa12
create_user "jgegax@uwyo.edu" "Gegax, Jessa Riley" "pw1846642sa13a" "x" sa13
create_user "egorman2@uwyo.edu" "Gorman, Emily Elizabeth" "pw1836045sa14a" "x" sa14
create_user "jhanse25@uwyo.edu" "Hansen, Jacob Howard" "pw552001sa15a" "x" sa15
create_user "chutson1@uwyo.edu" "Hutson, Carly Samantha" "pw1852422sa16a" "x" sa16
create_user "sjimerso@uwyo.edu" "Jimerson, Sharolyn M." "pw652600sa17a" "x" sa17
create_user "ikelly@uwyo.edu" "Kelly, Ian Lee" "pw1844453sa18a" "x" sa18
create_user "ikiefer1@uwyo.edu" "Kiefer, Isaiah" "pw1851962sa19a" "x" sa19
create_user "jkilpat1@uwyo.edu" "Kilpatrick, Joseph C" "pw1866842sa20a" "x" sa20
create_user "yleong@uwyo.edu" "Leong, Yun Chi" "pw1859846sa21a" "x" sa21
create_user "tlinse@uwyo.edu" "Linse, Tamara Thalia" "pw538093sa22a" "x" sa22
create_user "jlucid@uwyo.edu" "Lucid, James" "pw1881173sa23a" "x" sa23
create_user "amaljani@uwyo.edu" "Maljanian, Aram D" "pw1870717sa24a" "x" sa24
create_user "jmalone9@uwyo.edu" "Malone, Joshua Dillon" "pw1855705sa25a" "x" sa25
create_user "wmalone1@uwyo.edu" "Malone, William A" "pw1854208sa26a" "x" sa26
create_user "smeel@uwyo.edu" "Meel, Siddharth" "pw1834261sa27a" "x" sa27
create_user "mmoore52@uwyo.edu" "Moore, Mariah L" "pw1850839sa28a" "x" sa28
create_user "zmoore5@uwyo.edu" "Moore, Zachary" "pw1860466sa29a" "x" sa29
create_user "cmyers18@uwyo.edu" "Myers, Charles David" "pw1852966sa30a" "x" sa30
create_user "jogirima@uwyo.edu" "Ogirima, Joseph Anda" "pw1845549sa31a" "x" sa31
create_user "bostrem@uwyo.edu" "Ostrem, Bryce" "pw1841809sa32a" "x" sa32
create_user "lpinter@uwyo.edu" "Pinter, Letitia A" "pw1856938sa33a" "x" sa33
create_user "tredding@uwyo.edu" "Redding, Tristan" "pw1872117sa34a" "x" sa34
create_user "areiche1@uwyo.edu" "Reichert, Adeline N" "pw1864844sa35a" "x" sa35
create_user "croach1@uwyo.edu" "Roach, Colton N" "pw1852973sa36a" "x" sa36
create_user "tselvig@uwyo.edu" "Selvig, Tanner" "pw1867808sa37a" "x" sa37
create_user "pspires@uwyo.edu" "Spires, Parker W" "pw1861210sa38a" "x" sa38
create_user "astepehn@uwyo.edu" "Stephen, Austin James" "pw1862878sa39a" "x" sa39
create_user "asummer5@uwyo.edu" "Summers, Asher C." "pw1867972sa40a" "x" sa40
create_user "zswope1@uwyo.edu" "Swope, Zebulon W" "pw1867412sa41a" "x" sa41
create_user "jtuttle5@uwyo.edu" "Tuttle, Jacob" "pw1852263sa42a" "x" sa42
create_user "gtvedt@uwyo.edu" "Tvedt, Garrett J" "pw990457sa43a" "x" sa43
create_user "evanwig@uwyo.edu" "Van Wig, Eric" "pw1849994sa44a" "x" sa44
create_user "bwabscha@uwyo.edu" "Wabschall, Benjamin E" "pw1847970sa45a" "x" sa45
create_user "rwallac7@uwyo.edu" "Wallace, Romello" "pw1854722sa46a" "x" sa46
create_user "nwhitham@uwyo.edu" "Whitham, Nathaniel D" "pw1851762sa47a" "x" sa47
create_user "kyounge1@uwyo.edu" "Youngerman, Kevin J." "pw584417sa48a" "x" sa48
