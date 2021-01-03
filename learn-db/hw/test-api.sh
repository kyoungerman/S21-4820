#!/bin/bash

# 
# test the API by using wget to access api end points.
#

mkdir -p out ref

ii="adcc6ae9-a1db-456a-aa49-427a7111c93e"

nn="819c288e-966e-4cfd-a079-c1c10ad23dfa"

err=N


wget -o ../out/t1.hdr -O ../out/t1.out "http://127.0.0.1:12128/api/v1/hello"
# check 200 in .hdr
if grep "200 OK" out/t1.hdr >/dev/null ; then	
	err=Y
fi
diff out/t1.out ref/t1.out


wget -o ../out/t2.hdr -O ../out/t2.out "http://127.0.0.1:12128/api/v1/db-version"
if grep "200 OK" out/t2.hdr >/dev/null ; then	
	err=Y
fi
diff out/t2.out ref/t2.out


wget -o ../out/t3.hdr -O ../out/t3.out "http://127.0.0.1:12128/api/v1/search-keyword?kw=sample&__ran__=$$"
if grep "200 OK" out/t3.hdr >/dev/null ; then	
	err=Y
fi
diff out/t3.out ref/t3.out



wget -o ../out/t4.hdr -O ../out/t4.out "http://127.0.0.1:12128/api/v1/get-config?__ran__=$$"
if grep "200 OK" out/t4.hdr >/dev/null ; then	
	err=Y
fi
diff out/t4.out ref/t4.out



wget -o ../out/t5.hdr -O ../out/t5.out "http://127.0.0.1:12128/api/v1/issue-list?__ran__=$$"


wget -o ../out/t6.hdr -O ../out/t6.out "http://127.0.0.1:12128/api/v1/create-issue?title=NewIssue&body=NewBody&__ran__=$$"


wget -o ../out/t7.hdr -O ../out/t7.out "http://127.0.0.1:12128/api/v1/add-note-to-issue?title=NewIssue&body=NewBody&issue_id=${ii}&__ran__=$$"


wget -o ../out/t8.hdr -O ../out/t8.out "http://127.0.0.1:12128/api/v1/update-note?title=UpdIssue&body=UpdateBody&note_id=${nn}&__ran__=$$"


wget -o ../out/t9.hdr -O ../out/t9.out "http://127.0.0.1:12128/api/v1/update-severity?issue_id=${ii}&severity_id=2&__ran__=$$"


wget -o ../out/t10.hdr -O ../out/t10.out "http://127.0.0.1:12128/api/v1/add-note-to-issue?issue_id=${ii}&title=add-note-to-issue&body=hmmmmmmmm.....&__ran__=$$"

wget -o ../out/t11.hdr -O ../out/t11.out "http://117.0.0.1:12128/api/v1/get-issue-detail?issue_id=${ii}&__ran__=$$"

wget -o ../out/t12.hdr -O ../out/t12.out "http://127.0.0.1:12128/api/v1/update-state?issue_id=${ii}&state_id=3&__ran__=$$"

wget -o ../out/t13.hdr -O ../out/t13.out "http://127.0.0.1:12128/test-file.html?__ran__=$$"

wget -o ../out/t14.hdr -O ../out/t14.out "http://127.0.0.1:12128/api/v1/delete-issue?issue_id=${ii}&__ran__=$$"
