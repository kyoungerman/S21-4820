------------------------------------------------------
--This file inserts the default data into the tables--
------------------------------------------------------

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


INSERT INTO i_severity ( id, severity ) values
	( 1, 'Unknown' ),
	( 2, 'Ignore' ),
	( 3, 'Minor' ),
	( 4, 'Documentation Error' ),
	( 6, 'Code Chagne' ),
	( 7, 'User Interface Change' ),
	( 8, 'Severe - System down' ),
	( 9, 'Critial - System down' )
;

INSERT INTO i_issue (
	id,
	title,	
	body,				
	state_id, 		
	severity_id 
) values 
	( 'adcc6ae9-a1db-456a-aa49-427a7111c93e', 'Sample Issue 1', 'This is a sample of an issue', 6, 2 ),
	( '2de76413-d746-4941-886a-a8ef99255956', 'Sample Issue 2', 'This is a 2nd Samle, sample of an issue', 1, 1 )
;

INSERT INTO i_note (
	id,
	issue_id,
	title,
	body 
) values	
	( '819c288e-966e-4cfd-a079-c1c10ad23dfa', 'adcc6ae9-a1db-456a-aa49-427a7111c93e', 'Note 1 on Issue 1', 'Body of Note 1' ),
	( 'fc9fb22c-d80e-433f-8510-65fb524d02d8', 'adcc6ae9-a1db-456a-aa49-427a7111c93e', 'Note 2 on Issue 1 John Smith is an Englisman', 'John Smith Speeks English' )
;
