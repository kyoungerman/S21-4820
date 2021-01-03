
all:
	~/go/src/gitlab.com/pschlump/PureImaginationServer/bin/cmp-local.sh bulk-load

local_test_000:
	mkdir -p out
	( cd out ; wget 'http://127.0.0.1:7001/status' )

local_test_001:
	./bulk-load --data test1.csv

local_test_002:
	./bulk-load --data test2.csv --zip test2.zip
	unzip -l test2.zip | grep index.json

t3:
	mkdir -p out
	( cd out ; wget 'http://127.0.0.1:7001/status' )
	~/go/src/gitlab.com/pschlump/PureImaginationServer/bin/cmp-local.sh bulk-load
	./bulk-load --data test4.csv --zip test4.zip  
