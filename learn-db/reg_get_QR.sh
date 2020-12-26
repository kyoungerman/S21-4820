#!/bin/bash

psql -p 5432 -a -P pager=off -h localhost -U pschlump --dbname=q8s <<XXxx
select setup_2fa_complete from t_ymux_user where real_name = 'philip Jon schlump';
XXxx

jq .qr_url out/xtest1.oo

URL=$(jq .qr_url out/xtest1.oo | sed -e 's/"//' )

wget -o out/,qr.err -O out/qr.png "http://localhost:7001$URL"

qr-decode out/qr.png > out/qr.txt
cat out/qr.txt

psql -p 5432 -a -P pager=off -h localhost -U pschlump --dbname=q8s <<XXxx
select setup_2fa_complete from t_ymux_user where real_name = 'philip Jon schlump';
XXxx
