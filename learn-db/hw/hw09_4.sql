ALTER TABLE name_list 
	ADD CONSTRAINT name_list_state_fk
	FOREIGN KEY (state) 
	REFERENCES us_state (state)
;
