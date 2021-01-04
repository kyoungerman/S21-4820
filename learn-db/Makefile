
# /home/pschlump/go/src/github.com/Univ-Wyo-Education/S21-4280/learn-db
all: sql mk_doc
	check-json-syntax --ignore-tab-warning ./cfg.json
	check-json-syntax --ignore-tab-warning ./prod-cfg.json
	check-json-syntax --ignore-tab-warning ./db_cfg.json
	rm -f server learn-db
	~/go/src/gitlab.com/pschlump/PureImaginationServer/bin/cmp-local.sh  learn-db

start_watch:
	( cd mtp ; go build )
	./mtp/mtp \
		--comment .../Univ-Wyo-Education/S21-4280/learn-db \
		--watch \
		--cache-burst-override 108 \
		./www-src/index.html \
		&

sql:
	( cd data ; make sql )

mk_code:


# formerly: ValidateTables.go
gen:
	check-json-syntax --ignore-tab-warning cfg.json
	~/go/src/gitlab.com/pschlump/PureImaginationServer/bin/validate_script.sh \
		"t_output" \
		"t_ymux_2fa" \
		"t_ymux_2fa_dev_otk" \
		"t_ymux_2fa_otk" \
		"t_ymux_auth_token" \
		"t_ymux_config" \
		"t_ymux_documents" \
		"t_ymux_origin_ok" \
		"t_ymux_priv" \
		"t_ymux_registration_token" \
		"t_ymux_role" \
		"t_ymux_role_priv" \
		"t_ymux_user" \
		"t_ymux_user_log" \
		"ct_lesson" "ct_login" "ct_lesson_seen" "ct_homework_grade" "ct_homework_list" "ct_lesson_validation"

run: all
	./learn-db




FR=./tmpl/md/

mk_doc: ./www/api-doc.html
.PHONY: mk_doc

./www/api-doc.html: ./tmpl/api-doc.md
	markdown-cli --input=./tmpl/api-doc.md --output=,api-doc.html
	cat ${FR}/css/pre ${FR}/css/markdown.css ${FR}/css/post ./tmpl/md/md.css ${FR}/css/hpre ,api-doc.html ${FR}/css/hpost >/tmp/api-doc.html
	mv /tmp/api-doc.html ./www/api-doc.html





# cleanup and create user.
xtest1:
	mkdir -p out
	cleanup_user.sh 
	wget -o out/xtest1.o -O out/xtest1.oo \
		'http://localhost:7001/api/v2/register?username=pschlump%40gmail.com&password=abcdefghi123&real_name=philip%20Jon%20schlump&again=abcdefghi123&__method__=POST&_ran_=538.396'
	reg_get_QR.sh 

# setup 'acc' to generate for user 2fa key
xtest2:
	( cd ../PureImaginationServer/tools/acc/acc ; go build )
	../PureImaginationServer/tools/acc/acc --import out/qr.png

xtest5:
	( cd ../PureImaginationServer/tools/acc/acc ; go build )
	../PureImaginationServer/tools/acc/acc --get2fa "/app.example.com:pschlump@gmail.com"

# do login using 'acc' and API
xtest3:
	mkdir -p out
	wget -o out/xtest3.o -O out/xtest3.oo \
		'http://localhost:7001/api/v2/login?username=pschlump%40gmail.com&password=abcdefghi123&__method__=POST&_ran_=538.396'

# Validate the 2fa Pin to complete login
#	mux.Handle("/api/v2/2fa-validate-pin", http.HandlerFunc(Handle2FAValidatePin)).DocTag("<h2>/api/v2/2fa-validate-pin").NoDoc(setDocFlag).Inputs([]*ymux.MuxInput{
#		{Name: "pin2fa", Required: true, Lable: "2FA Login PIN", MinLen: 6, MaxLen: 10, Type: "ds"},
xtest4:
	./chk-pin.sh



test: setupTest test001 test002 test003 test004 test011 test012 test014 test015
	@echo PASS

setupTest:
	../bin/cmp-local.sh
	mkdir -p ./out ./ref
	
test001:
	./q8s-service --db_flag "HandleCRUD.cli" --cli /api/v1/conv-60-to-10 base60 20j  >out/test001.out
	diff out/test001.out ref/test001.out

test010:
	./q8s-service --db_flag "HandleCRUD.cli" --cli /api/v2/token un bob pw builder _ran_ 12321223  >out/test010.out
	grep "success" out/test010.out

test014:
	./q8s-service --db_flag "HandleCRUD.cli" --cli /AunAun >out/test014.out
	grep "yes-I-still-love-you" out/test014.out
	diff out/test014.out ref/test014.out

test011:
	./q8s-service --db_flag "HandleCRUD.cli" --cli /api/v2/conv-60-to-10 base60 AA20j  >out/test011.out
	diff out/test011.out ref/test011.out

# Verify the clear GIF will load.
test015:
	./q8s-service --cli /image/lclr.gif >out/test015.out
	grep GIF out/test015.out

# Test decode of an ID - this is the same as the 307 redirect, but w/o the redirect.
test016:
	./q8s-service --db_flag "HandleCRUD.cli" --cli /api/v2/dec base60 AunAun >out/test016.out
	grep "yes-I-still-love-you" out/test016.out
	diff out/test016.out ref/test016.out

# Set, Decode, bulk-load
#	mux.Handle("/api/v2/set", http.HandlerFunc(HandleSetQR)).NoDoc()                                                         
#	mux.Handle("/api/v2/set-data", http.HandlerFunc(HandleSetDataQR)).NoDoc()                                               
test017:
	./q8s-service --cli /api/v2/set base60 AA20k url_to 'http://www.2c-why.com' >out/test017.a.out
	grep "success" out/test017.a.out
	./q8s-service --cli /api/v2/set-data base60 AA20k  data '{"some":"data"}' >out/test017.b.out
	grep "success" out/test017.b.out
	./q8s-service --cli /api/v2/dec base60 AA20k >out/test017.out
	grep "2c-why" out/test017.out

# xyzzy
#	mux.Handle("/api/v2/bulk-load", http.HandlerFunc(HandleBulkLoadQR)).Method("GET","POST").NoDoc()                                              // xyzzy

# xyzzy - Yep
#	mux.Handle("/desc.html", http.HandlerFunc(mux.Desc())).NoDoc()                                                           // Documentation for API (and test run code) v2
test020:
	./q8s-service --cli /desc.html fmt json >out/test020.out
	grep 'Status.*200' out/test020.out
	grep -v '^Status.*200' out/test020.out | check-json-syntax | tail -2 | grep OK

test021:
	./q8s-service --cli /desc.html >out/test021.out
	grep 'Status.*200' out/test021.out

test002:
	./q8s-service --db_flag "HandleCRUD.cli" --cli /api/v1/conv-10-to-60 base10 2612 >out/test002.out
	diff out/test002.out ref/test002.out

test012:
	./q8s-service --db_flag "HandleCRUD.cli" --cli /api/v2/conv-10-to-60 base10 2612 >out/test012.out
	diff out/test012.out ref/test012.out

#	mux.Handle("/gen-qr-url", http.HandlerFunc(HandleGenQRURL))     //
test003:
	./q8s-service --db_flag "HandleCRUD.cli" --cli /api/v1/gen-qr-url base10id 2612 baseUrl 'http://127.0.0.1:9019' >out/test003.out
	grep status out/test003.out >out/test003-pt1.out
	jq .url out/test003-pt1.out
	jq .url out/test003-pt1.out | sed -e 's/"//g' >out/url003.out
	wget -o ,o -O ,oo `cat out/url003.out`
	grep '200 OK' ,o >/dev/null

test004:
	./q8s-service --db_flag "HandleCRUD.cli" --cli /api/v1/parse-qr-url qr_url 'http://127.0.0.1:9019/qr/qr_00026/q02612.4.png' >out/test004.out
	grep status out/test004.out >out/test004-pt1.json
	check-json-syntax out/test004-pt1.json
	diff out/test004.out ref/test004.out

test030:
	./q8s-service --db_flag "HandleCRUD.cli" --cli /api/v2/get-qr nbr 1 >out/test030.out
	diff out/test030.out ref/test030.out

test031:
	./q8s-service --db_flag "HandleCRUD.cli" --cli /api/v2/set url_to "http://www.google.com/" memo "Ya 31" base10 "4201" >out/test031.out
	diff out/test031.out ref/test031.out

# Pull back QR data for 1 users QR Code
test032:
	wget 'http://127.0.0.1:7001/api/v1/h_list_user_qr_codes?user_id=c0b71df9-e258-49ec-b912-bf69ff31481b'

#	Cli := "/api/v2/bulk-load"
test033:
	./q8s-service --db_flag "" --cli /api/v2/bulk-load user_id "c0b71df9-e258-49ec-b912-bf69ff31481b" update '{"Data":[{"url":"http://www.2c-why.com?abc=33","id10":"2000","id60":"","data":"abc=33"},{"url":"http://www.2c-why.com?abc=35","id10":"2001","id60":"","data":"abc=35"}]}' >out/test033.out
	diff out/test033.out ref/test033.out


atat: at001 at002 at005 at003 at008 at009 at004 at006 at007
	@echo ""
	@echo PASS

# Register and pull out token from ./log/log.out -> out/at001.token
at001: 
	./test/cleanup-user.sh 'bob.builder@test.com'
	wget -o out/at001.o -O out/at001.oo 'http://127.0.0.1:7001/api/v2/register?real_name=bob.builder&username=bob.builder@test.com&password=abcdef1234&again=abcdef1234&email=bob.builder@test.com'
	echo "# Status"
	cat out/at001.o
	echo "# Body"
	cat out/at001.oo
	grep '200 OK' out/at001.o >/dev/null								# Verify Success
	jq .status out/at001.oo | grep success >/dev/null					# Verify responce is success
	jq .auth_token out/at001.oo | sed -e 's/"//g' >out/at001.jwt_token	# Save the Token in a file
	# echo - check that the d.b. has email/username etc.

# Extract Email data
at002:
	grep '#EmailData#' log/log.out | tail -1 | sed -e 's/#EmailData#//' | check-json-syntax -p >out/at002.json
	cat out/at002.json
	jq .token out/at002.json | sed -e 's/"//g' >out/at002.token			# Save the email confirmation Token in a file

# Do login - before email confirm (Should fail to login)
at005:
	./test/fail-login.sh "bob.builder@test.com" "abcdef1234" "at005"

# Do login - with incorrect password
at008:
	./test/fail-login.sh "bob.builder@test.com" "3abcdef1234" "at008"

# Do login - with incorrect username
at009:
	./test/fail-login.sh "bob.buiXlder@test.com" "abcdef1234" "at009"

# Perform email confirmation
at003:
	wget -o out/at003.o -O out/at003.oo "http://127.0.0.1:7001/api/v2/confirm-email?token=`cat out/at002.token`"
	jq .status out/at003.oo | grep success >/dev/null					# Verify responce is success
	jq .auth_token out/at003.oo | sed -e 's/"//g' >out/at003.jwt_token	# Save the Token in a file
	# xyzzy - check that the user has been confirmed in the d.b.

# Do login (Should succede)
at004:
	wget -o out/at004.o -O out/at004.oo "http://127.0.0.1:7001/api/v2/login?username=bob.builder@test.com&password=abcdef1234"
	jq .status out/at004.oo | grep success >/dev/null					# Verify responce is success
	jq .auth_token out/at004.oo | sed -e 's/"//g' >out/at004.jwt_token	# Save the Token in a file
	# xyzzy - access the status requiring login - verify that it works with a beearer token.
	wget -o out/at004a.o -O out/at004a.oo --header="Authorization: Bearer `cat out/at004.jwt_token`" "http://127.0.0.1:7001/api/v2/status_login"
	jq .status out/at004a.oo | grep success >/dev/null					# Verify responce is success

# Do Logout
at006:
	wget -o out/at006.o -O out/at006.oo --header="Authorization: Bearer `cat out/at004.jwt_token`" "http://127.0.0.1:7001/api/v2/logout"
	jq .status out/at006.oo | grep success >/dev/null					# Verify responce is success
	# xyzzy - check in d.b. that the auth_token is gone.

# Password Change
# 1. Do Login 
# 2. Change password 
# 3. Verify can not login w/ old
# 4. Can login w/ new passwrod
# 5. Logout w/ old
# 6. Check email sent
at007:
	echo "Login"
	wget -o out/at007.o -O out/at007.oo "http://127.0.0.1:7001/api/v2/login?username=bob.builder@test.com&password=abcdef1234"
	jq .status out/at007.oo | grep success >/dev/null					# Verify responce is success
	jq .auth_token out/at007.oo | sed -e 's/"//g' >out/at007.jwt_token	# Save the Token in a file
	# xyzzy - access the status requiring login - verify that it works with a beearer token.
	echo "Verify JWT Token is good"
	wget -o out/at007d.o -O out/at007d.oo --header="Authorization: Bearer `cat out/at007.jwt_token`" "http://127.0.0.1:7001/api/v2/status_login"
	jq .status out/at007d.oo | grep success >/dev/null					# Verify responce is success
	echo "Use JWT Token to change password"
	wget -o out/at007a.o -O out/at007a.oo --header="Authorization: Bearer `cat out/at007.jwt_token`" \
		"http://127.0.0.1:7001/api/v2/change-password?old_pw=abcdef1234&password=tom.thumb44&confirm=tom.thumb44"
	jq .status out/at007a.oo | grep success >/dev/null					# Verify responce is success
	jq .auth_token out/at007a.oo | sed -e 's/"//g' >out/at007a.jwt_token	# Save the Token in a file
	echo "Verify old password is dead."
	./test/fail-login.sh "bob.builder@test.com" "abcdef1234" "at007c"
	echo "Verify new password is live."
	wget -o out/at007b.o -O out/at007b.oo "http://127.0.0.1:7001/api/v2/login?username=bob.builder@test.com&password=tom.thumb44"
	jq .status out/at007b.oo | grep success >/dev/null					# Verify responce is success

# Recover lost passwrod
# 1. use recover-passwd-pt1 
# 2. verify email data
# 3. follow link to recover-passwd-pt2 - verify page
# 4. send in new un/pw on recovery API - pt3
# 4. Login w/ new udpated password.
at018:
	echo "Request a Recovery Token"
	wget -o out/at018.o -O out/at018.oo "http://127.0.0.1:7001/api/v2/recover-password-pt1?email=bob.builder@test.com"
	jq .status out/at018.oo | grep success >/dev/null					# Verify responce is success
	grep '#EmailData#' log/log.out | tail -1 | sed -e 's/#EmailData#//' | check-json-syntax -p >out/at018.json
	cat out/at018.json
	jq .token out/at018.json | sed -e 's/"//g' >out/at018.token			# Save the email confirmation Token in a file
	wget -o out/at018a.o -O out/at018a.oo "http://127.0.0.1:7001/api/v2/recover-password-pt2?token=`cat out/at018.token`"
	grep "cd24923f-5864-42d3-5a66-7879d7e02b04" out/at018a.oo
	wget -o out/at018b.o -O out/at018b.oo "http://127.0.0.1:7001/api/v2/recover-password-pt3?token=`cat out/at018.token`&password=ben-and-jerries44&confirm=ben-and-jerries44"
	./test/fail-login.sh "bob.builder@test.com" "abcdef1234" "at018c"
	./test/fail-login.sh "bob.builder@test.com" "tom.thumb44" "at018d"
	echo "Login w/ new password"
	wget -o out/at018e.o -O out/at018e.oo "http://127.0.0.1:7001/api/v2/login?username=bob.builder@test.com&password=ben-and-jerries44"
	jq .status out/at018e.oo | grep success >/dev/null					# Verify responce is success
