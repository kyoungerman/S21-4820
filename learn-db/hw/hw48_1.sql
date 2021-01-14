
DROP TABLE if exists emp_sal;

CREATE TABLE emp_sal (
	emp_id serial primary key not null,
	dept text not null,
	salary numeric
);

INSERT INTO emp_sal ( dept, emp_id, salary ) values 
	( 'Dev'   	,    11 ,   5200 ),
	( 'Dev'   	,     7 ,   4200 ),
	( 'Dev'   	,     9 ,   4500 ),
	( 'Dev'   	,     8 ,   6000 ),
	( 'Dev'   	,    10 ,   5200 ),
	( 'H.R.' 	,     5 ,   3500 ),
	( 'H.R.' 	,     2 ,   3900 ),
	( 'sales'   ,     3 ,   4800 ),
	( 'sales'   ,     1 ,   5000 ),
	( 'sales'   ,     4 ,   4800 )
;

