create table name_list (
	real_name text,
	age int check ( age > 0 and age < 154 ),	
	state char varying (2)
);
