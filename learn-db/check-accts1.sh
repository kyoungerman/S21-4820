#!/bin/bash

# -----------------------------------------------------------------------------------------------------------------
#  Check each login - validate jwt tokens
# -----------------------------------------------------------------------------------------------------------------

function check_user {

	jwt_token=$( jq .jwt_token out/register.$1.out | sed -e 's/"//g' )
	user_id=$( jq .user_id out/register.$1.out | sed -e 's/"//g' )
	echo "jwt_token=${jwt_token} user_id=${user_id}"	

	echo "${jwt_token}" >out/jwt-token-$1.dat
	echo "${user_id}" >out/user_id-$1.dat
	
	curl  \
		-H "Authorization: bearer ${jwt_token}"  \
		-H 'Accept: application/json' "http://localhost:7001/api/v1/ct_login?pg_acct=$5" \
		-o out/ct_login_test.$1.out
	cat out/ct_login_test.$1.out
	echo
	if grep "status.*success" out/ct_login_test.$1.out ; then
		:
	else
		echo "Failed to login"
		exit 1
	fi

}

check_user "ubalogun@uwyo.edu" "Balogun Mohammed, Umar" "pw1881094sa01a" "x" sa01
check_user "tbourque@uwyo.edu" "Bourque, Timothy S" "pw1844740sa02a" "x" sa02
check_user "wbrant@uwyo.edu" "Brant, William Raymond" "pw1870840sa03a" "x" sa03
check_user "tbrown64@uwyo.edu" "Brown, Trent T" "pw1851099sa04a" "x" sa04
check_user "dcaruthe@uwyo.edu" "Caruthers, Duncan" "pw1850749sa05a" "x" sa05
check_user "cchave12@uwyo.edu" "Chavez, Courtney Lauryn" "pw1836865sa06a" "x" sa06
check_user "pday2@uwyo.edu" "Day, Peter" "pw1842839sa07a" "x" sa07
check_user "adelaura@uwyo.edu" "Delaurante, Anthony F" "pw1879174sa08a" "x" sa08
check_user "rdurnan@uwyo.edu" "Durnan, Ryan Andrew" "pw1836421sa09a" "x" sa09
check_user "afinch2@uwyo.edu" "Finch, Alexander C" "pw1057479sa10a" "x" sa10
check_user "wfrost2@uwyo.edu" "Frost, William" "pw1859002sa11a" "x" sa11
check_user "afulle12@uwyo.edu" "Fuller, Andrew Lukas" "pw1843915sa12a" "x" sa12
check_user "jgegax@uwyo.edu" "Gegax, Jessa Riley" "pw1846642sa13a" "x" sa13
check_user "egorman2@uwyo.edu" "Gorman, Emily Elizabeth" "pw1836045sa14a" "x" sa14
check_user "jhanse25@uwyo.edu" "Hansen, Jacob Howard" "pw552001sa15a" "x" sa15
check_user "chutson1@uwyo.edu" "Hutson, Carly Samantha" "pw1852422sa16a" "x" sa16
check_user "sjimerso@uwyo.edu" "Jimerson, Sharolyn M." "pw652600sa17a" "x" sa17
check_user "ikelly@uwyo.edu" "Kelly, Ian Lee" "pw1844453sa18a" "x" sa18
check_user "ikiefer1@uwyo.edu" "Kiefer, Isaiah" "pw1851962sa19a" "x" sa19
check_user "jkilpat1@uwyo.edu" "Kilpatrick, Joseph C" "pw1866842sa20a" "x" sa20
check_user "yleong@uwyo.edu" "Leong, Yun Chi" "pw1859846sa21a" "x" sa21
check_user "tlinse@uwyo.edu" "Linse, Tamara Thalia" "pw538093sa22a" "x" sa22
check_user "jlucid@uwyo.edu" "Lucid, James" "pw1881173sa23a" "x" sa23
check_user "amaljani@uwyo.edu" "Maljanian, Aram D" "pw1870717sa24a" "x" sa24
check_user "jmalone9@uwyo.edu" "Malone, Joshua Dillon" "pw1855705sa25a" "x" sa25
check_user "wmalone1@uwyo.edu" "Malone, William A" "pw1854208sa26a" "x" sa26
check_user "smeel@uwyo.edu" "Meel, Siddharth" "pw1834261sa27a" "x" sa27
check_user "mmoore52@uwyo.edu" "Moore, Mariah L" "pw1850839sa28a" "x" sa28
check_user "zmoore5@uwyo.edu" "Moore, Zachary" "pw1860466sa29a" "x" sa29
check_user "cmyers18@uwyo.edu" "Myers, Charles David" "pw1852966sa30a" "x" sa30
check_user "jogirima@uwyo.edu" "Ogirima, Joseph Anda" "pw1845549sa31a" "x" sa31
check_user "bostrem@uwyo.edu" "Ostrem, Bryce" "pw1841809sa32a" "x" sa32
check_user "lpinter@uwyo.edu" "Pinter, Letitia A" "pw1856938sa33a" "x" sa33
check_user "tredding@uwyo.edu" "Redding, Tristan" "pw1872117sa34a" "x" sa34
check_user "areiche1@uwyo.edu" "Reichert, Adeline N" "pw1864844sa35a" "x" sa35
check_user "croach1@uwyo.edu" "Roach, Colton N" "pw1852973sa36a" "x" sa36
check_user "tselvig@uwyo.edu" "Selvig, Tanner" "pw1867808sa37a" "x" sa37
check_user "pspires@uwyo.edu" "Spires, Parker W" "pw1861210sa38a" "x" sa38
check_user "astepehn@uwyo.edu" "Stephen, Austin James" "pw1862878sa39a" "x" sa39
check_user "asummer5@uwyo.edu" "Summers, Asher C." "pw1867972sa40a" "x" sa40
check_user "zswope1@uwyo.edu" "Swope, Zebulon W" "pw1867412sa41a" "x" sa41
check_user "jtuttle5@uwyo.edu" "Tuttle, Jacob" "pw1852263sa42a" "x" sa42
check_user "gtvedt@uwyo.edu" "Tvedt, Garrett J" "pw990457sa43a" "x" sa43
check_user "evanwig@uwyo.edu" "Van Wig, Eric" "pw1849994sa44a" "x" sa44
check_user "bwabscha@uwyo.edu" "Wabschall, Benjamin E" "pw1847970sa45a" "x" sa45
check_user "rwallac7@uwyo.edu" "Wallace, Romello" "pw1854722sa46a" "x" sa46
check_user "nwhitham@uwyo.edu" "Whitham, Nathaniel D" "pw1851762sa47a" "x" sa47
check_user "kyounge1@uwyo.edu" "Youngerman, Kevin J." "pw584417sa48a" "x" sa48
