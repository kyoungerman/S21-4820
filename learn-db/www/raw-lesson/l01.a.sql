CREATE TABLE teachers (
	id 			serial not null PRIMARY KEY,
	first_name 	text,
	last_name 	text not null,
	school 		varchar(50) not null,
	state 		varchar(2) not null
);
