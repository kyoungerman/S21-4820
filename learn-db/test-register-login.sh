#!/bin/bash

# 
# Creates a user `testlogin@gmail.com` with a password of `abcdefghi123` with 2fa enabled.
# 
# Use tool to generate a 2fa auth key.
#

# To port to a new system you need to change `learndb` to a new value. 

#  *1. Cleanup user / auth-tokens etc.  testlogin@gmail.com
#  *2. Get key from d.b. - pull out form link
#  3. Register - using "link" to bring up page
#  4. Check that "key" is filled in - that it is real
#  5. Register
#  6. Get QR URL from Log file
#  7. Get QR .png 
#  8. Setup login with ../.../.../ac --import X.png
#  9. Login 




mkdir -p out

# -----------------------------------------------------------------------------------------------------------------
#  1. Cleanup user / auth-tokens etc.  testlogin@gmail.com
# -----------------------------------------------------------------------------------------------------------------

psql -p 5432 -a -P pager=off -h localhost -U pschlump --dbname=pschlump <<XXxx
\c learndb
delete from t_ymux_auth_token where user_id in (
	select id from t_ymux_user where username = 'app.example.com:testlogin@gmail.com'
);
delete from t_ymux_2fa where user_id in (
	select id from t_ymux_user where username = 'app.example.com:testlogin@gmail.com'
);
delete from t_ymux_2fa_otk where user_id in (
	select id from t_ymux_user where username = 'app.example.com:testlogin@gmail.com'
);
delete from t_ymux_2fa_dev_otk where user_id in (
	select id from t_ymux_user where username = 'app.example.com:testlogin@gmail.com'
);
delete from t_ymux_user where username = 'app.example.com:testlogin@gmail.com';
\q
XXxx

# -----------------------------------------------------------------------------------------------------------------
#  2. Get key from d.b. - pull out form link
# -----------------------------------------------------------------------------------------------------------------

#                token
#--------------------------------------
# ce7bce69-3b77-44ad-85dd-ef2229d2bff5

psql -p 5432 -a -P pager=off -h localhost -U pschlump --dbname=pschlump >./out/reg-tok.log <<XXxx 
\c learndb
\o ./out/reg-tok.out
select token from t_ymux_registration_token where user_id in (
	select id
		from t_ymux_user 
		where username = 'app.example.com:pschlump@gmail.com'
);
\q
XXxx

REG_KEY=$( tail -n +3 <./out/reg-tok.out | head -1 | sed -e 's/ //g' )
echo "REG_KEY= ->$REG_KEY<-"

# -----------------------------------------------------------------------------------------------------------------
#  3. Register - using "link" to bring up page
#  4. Check that "key" is filled in - that it is real
# -----------------------------------------------------------------------------------------------------------------

# wget .../index.html?register_key=${REG_KEY}
# How to do this - this is a front-end question.





# -----------------------------------------------------------------------------------------------------------------
#  5. Register
# -----------------------------------------------------------------------------------------------------------------

curl -H 'Accept: application/json' "http://localhost:7001/api/v2/register?username=testlogin@gmail.com&real_name=Test+Login&password=abcdefghi123&again=abcdefghi123&registration_token=${REG_KEY}" -o out/register.1.out
cat out/register.1.out
echo
if grep "status.*success" out/register.1.out ; then
	:
else
	echo "Failed to register"
	exit 1
fi

# -----------------------------------------------------------------------------------------------------------------
#  6. Get QR URL from Log file -- url is returned in registration - use that... 	"qr_url": "/qrr/28871815.png",
#  7. Get QR .png 
# -----------------------------------------------------------------------------------------------------------------
#    Note: /qrr/... procuces a moved permanenlty redirect - instead of just generate the QR directly - why?  Fix?
# -----------------------------------------------------------------------------------------------------------------
PNG=$(jq .qr_url out/register.1.out | sed -e 's/"//g')
echo "PNG= ->$PNG<-"
curl -L "http://localhost:7001/${PNG}" -o out/register.2fa.png


# -----------------------------------------------------------------------------------------------------------------
#  8. Setup login with ../.../.../acc --import X.png
# -----------------------------------------------------------------------------------------------------------------
LOC=$(pwd)
# ( cd ~/go/src/gitlab.com/pschlump/htotp/tools/acc ; ./acc --import ${LOC}/out/register.2fa.png >${LOC}/out/import-to-ac.out )
~/bin/acc --import ${LOC}/out/register.2fa.png >${LOC}/out/import-to-ac.out 
if grep Success out/import-to-ac.out ; then
	:
else
	echo "Failed to setup authenticator"
	exit 1
fi





# -----------------------------------------------------------------------------------------------------------------
#  9. Login 
# -----------------------------------------------------------------------------------------------------------------
























