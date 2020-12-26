
DROP TABLE if exists employee;
DROP TABLE if exists department;

CREATE TABLE employee (
	employee_id serial not null primary key,
	name text not null,
	department_id  int,
	pay numeric(12,2) not null default 0
);

CREATE TABLE department (
	department_id  serial not null primary key,
	dept_name text not null
);

INSERT INTO department ( department_id, dept_name ) values
	( 1, 'Sales' ),
	( 2, 'Development' ),
	( 3, 'Execuatie' ),
	( 4, 'Maintenance' )
;

INSERT INTO employee (  name, department_id, pay ) values	
	( 'Bob', 1, 36000 ),
	( 'Jane', 1, 140000 ),
	( 'Sally', 2, 121000 ),
	( 'Liz', 2, 101000 ),
	( 'Dave', 1, 51000 ),
	( 'CEO Kelly', 3, 1 ),
	( 'Uncle Bob', NULL, 96000 ),
	( 'Brother Charley', NULL, 48000 )
;


