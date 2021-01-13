create table name_list (
	name_list_id UUID NOT NULL DEFAULT uuid_generate_v4() primary key,
	real_name text,
	age int check ( age > 0 and age < 154 ),	
	state char varying (2)
);
