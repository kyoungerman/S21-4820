DROP TABLE if exists name_list2 ;
CREATE TABLE name_list2 (
	name_list_id UUID NOT NULL DEFAULT uuid_generate_v4() primary key,
	real_name text check ( length(real_name) >= 1 ) not null,
	age int check ( age > 0 and age < 154 ) not  null,	
	state char varying (2) not null,
	pay numeric(10,2) 
);
