CREATE EXTENSION if not exists "uuid-ossp";
CREATE EXTENSION if not exists pgcrypto;

DROP TABLE if exists name_list ;

CREATE TABLE name_list (
	name_list_id UUID NOT NULL DEFAULT uuid_generate_v4() primary key,
	real_name text check ( length(real_name) >= 1 ) not null,
	age int check ( age > 0 and age < 154 ) not  null,	
	state char varying (2) not null,
	pay numeric(10,2) 
);

CREATE INDEX name_list_idx1 on name_list ( real_name );
CREATE INDEX user_real_name_ci_idx1 ON name_list ((lower(real_name)));
