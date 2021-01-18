
ALTER TABLE name_list2
	ADD CONSTRAINT name_list_state_fk
	FOREIGN KEY (state_2letter_code)
	REFERENCES us_state (state)
;
