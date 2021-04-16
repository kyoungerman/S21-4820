<<<<<<< HEAD
=======

drop table if exists i_state cascade;
drop table if exists i_severity cascade;

>>>>>>> 5bcc917bfc441247748c35ac958d9067eb0f328a
CREATE table i_state (
	id serial not null primary key,
	state text not null
);
CREATE unique index i_state_u1 on i_state ( state );

CREATE table i_severity (
	id serial not null primary key,
	severity text not null
);
CREATE unique index i_severity_u1 on i_severity ( severity );

ALTER TABLE i_issue
	ADD CONSTRAINT i_issue_fk2
	FOREIGN KEY (state_id)
	REFERENCES i_state (id)
;
ALTER TABLE i_issue
	ADD CONSTRAINT i_issue_fk3
	FOREIGN KEY (severity_id)
	REFERENCES i_severity (id)
;

INSERT INTO i_state ( id, state ) values
	( 1, 'Created' ),
	( 2, 'Verified' ),
	( 3, 'In Progress' ),
	( 4, 'Development Complete' ),
	( 5, 'Unit Test' ),
	( 6, 'Integration Test' ),
	( 7, 'Tests Passed' ),
	( 8, 'Documentation' ),
	( 9, 'Deployed' ),
	( 10, 'Closed' ),
	( 11, 'Deleted' )
;
ALTER SEQUENCE i_state_id_seq RESTART WITH 12;

INSERT INTO i_severity ( id, severity ) values
	( 1, 'Unknown' ),
	( 2, 'Ignore' ),
	( 3, 'Minor' ),
	( 4, 'Documentation Error' ),
	( 6, 'Code Chagne' ),
	( 6, 'User Interface Change' ),
	( 7, 'Severe - System down' ),
	( 8, 'Critial - System down' )
;
ALTER SEQUENCE i_severity_id_seq RESTART WITH 9;

insert into i_config ( name, value ) values 
	( 'language', 'english' )
;


