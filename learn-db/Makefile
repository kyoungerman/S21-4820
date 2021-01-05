
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
		"ct_homework" "ct_login" "ct_homework_seen" "ct_homework_grade" "ct_homework_list" "ct_homework_validation" \
			"ct_file_list" "ct_val_homework"

run: all
	./learn-db




FR=./tmpl/md/

mk_doc: ./www/api-doc.html
.PHONY: mk_doc

./www/api-doc.html: ./tmpl/api-doc.md
	markdown-cli --input=./tmpl/api-doc.md --output=,api-doc.html
	cat ${FR}/css/pre ${FR}/css/markdown.css ${FR}/css/post ./tmpl/md/md.css ${FR}/css/hpre ,api-doc.html ${FR}/css/hpost >/tmp/api-doc.html
	mv /tmp/api-doc.html ./www/api-doc.html



l_test: l_test_pre l_test1 l_test2 l_test3 l_test4 l_test5 l_test6

l_test_pre:
	mkdir -p out
.PHONY: l_test_pre

# URIPath:   "/api/v1/ct_homework_seen",
l_test1:
	wget -o out/ct_homework_seen.err -O out/ct_homework_seen.out "http://127.0.0.1:7001/api/v1/ct_homework_seen"

# URIPath:   "/api/v1/ct_file_list",
l_test2:
	wget -o out/ct_file_list.err -O out/ct_file_list.out "http://127.0.0.1:7001/api/v1/ct_file_list"

# URIPath:   "/api/v1/ct_val_homework",
l_test3:
	wget -o out/ct_val_homework.err -O out/ct_val_homework.out "http://127.0.0.1:7001/api/v1/ct_val_homework"

# URIPath:   "/api/v1/ct_file_list",
l_test4:
	wget -o out/ct_file_list.err -O out/ct_file_list.out "http://127.0.0.1:7001/api/v1/ct_file_list"

# Test where capability
l_test5:
	wget -o out/ct_file_list.2.err -O out/ct_file_list.2.out "http://127.0.0.1:7001/api/v1/ct_file_list?homework_no=26"

# Test where capability
l_test6:
	wget -o out/ct_file_list.3.err -O out/ct_file_list.3.out "http://127.0.0.1:7001/api/v1/ct_file_list?homework_no=13"





# Test the API for getting the list of lessons
l_test7:
	wget -o out/ct_homework.err -O out/ct_homework.out "http://127.0.0.1:7001/api/v1/ct_homework"




