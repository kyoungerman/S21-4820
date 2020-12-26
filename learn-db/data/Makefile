
all: ct.sql

run:
	~/bin/89-http-server --dir . &


ct.sql: ct.m4.sql Makefile
	m4 -P ct.m4.sql >ct.sql

