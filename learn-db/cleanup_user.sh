#!/bin/bash

psql -p 5432 -a -P pager=off -h localhost -U pschlump --dbname=q8s <<XXxx
delete from t_ymux_user where real_name = 'philip Jon schlump';
XXxx
