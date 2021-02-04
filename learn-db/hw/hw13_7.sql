
CREATE TABLE name_list (
	name_list_id UUID NOT NULL DEFAULT uuid_generate_v4() primary key,
	real_name text check ( length(real_name) >= 1 ) not null,
	age int check ( age > 0 and age < 154 ) not  null,	
	state char varying (2) not null,
	pay numeric(10,2) 
);

CREATE INDEX name_list_idx1 on name_list ( real_name );
CREATE INDEX user_real_name_ci_idx1 ON name_list ((lower(real_name)));

ALTER TABLE name_list
	ADD CONSTRAINT name_list_state_fk
	FOREIGN KEY (state)
	REFERENCES us_state (state)
;

INSERT INTO name_list ( real_name, age, state, pay ) values
	( 'Bob True',            22, 'WY', 31000 ),
	( 'Jane True',           20, 'WY', 28000 ),
	( 'Tom Ace',             31, 'NJ', 82500 ),
	( 'Steve Pen',           33, 'NJ', 89400 ),
	( 'Laura Jean Alkinoos', 34, 'PA', 120000 ),
	( 'Philip Schlump',      62, 'WY', 101200 ),
	( 'Liz Trubune',         30, 'WY', 48000 ),
	( 'Lary Smith',          58, 'NJ', 48000 ),
	( 'Dave Dave',           21, 'NJ', 48000 ),
	( 'Laura Ann Alkinoos',  34, 'PA', 48000 )
;

