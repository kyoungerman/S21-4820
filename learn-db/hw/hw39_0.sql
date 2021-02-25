CREATE EXTENSION if not exists "uuid-ossp";
CREATE EXTENSION if not exists pgcrypto;

CREATE TABLE name_list if not exists (
	name_list_id UUID NOT NULL DEFAULT uuid_generate_v4() primary key,
	real_name text check ( length(real_name) >= 1 ) not null,
	age int check ( age > 0 and age < 154 ) not  null,	
	state char varying (2) not null,
	pay numeric(10,2) 
);

CREATE INDEX if not exists name_list_idx1 on name_list ( real_name );
CREATE INDEX if not exists user_real_name_ci_idx1 ON name_list ((lower(real_name)));
