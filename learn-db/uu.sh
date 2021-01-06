
value="
drop table if exists name2_list;
create table name2_list ( a int );
insert into name2_list ( a ) values ( 12 ), ( 14 );
select * from name2_list;
"

encoded_value=$(python -c "import urllib.parse; print (urllib.parse.quote('''$value'''))")

echo "encoded_value=->${encoded_value}"

