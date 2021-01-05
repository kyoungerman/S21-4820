
value="
drop table if exists name2_list;
create table name2_list ( a int );
"

encoded_value=$(python -c "import urllib.parse; print (urllib.parse.quote('''$value'''))")

echo "encoded_value=->${encoded_value}"

