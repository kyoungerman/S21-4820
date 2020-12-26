
all: ct.sql sql

run:
	~/bin/89-http-server --dir . &

sql: setup_make \
	t_output.sql \
	v1_user.sql \
	ct.sql \
	s_nvl.sql

.PHONY: sql

ct.sql: ct.m4.sql Makefile setup.m4
	m4 -P ct.m4.sql >ct.sql
	echo "\i ct.sql" >>all.sql


setup_make:
	echo "" >all.sql
	cat setup.sql >>all.sql

v1_avail_qr.sql: v1_avail_qr.m4.sql setup.m4
	m4 -P setup.m4 v1_avail_qr.m4.sql >v1_avail_qr.sql
	echo "\i v1_avail_qr.sql" >>all.sql

v1_user.sql: v1_user.m4.sql setup.m4
	m4 -P setup.m4 v1_user.m4.sql >v1_user.sql
	echo "\i v1_user.sql" >>all.sql

t_output.sql: t_output.m4.sql setup.m4
	m4 -P setup.m4 t_output.m4.sql >t_output.sql
	echo "\i t_output.sql" >>all.sql

s_nvl.sql: s_nvl.m4.sql setup.m4
	m4 -P setup.m4 s_nvl.m4.sql >s_nvl.sql
	echo "\i s_nvl.sql" >>all.sql

