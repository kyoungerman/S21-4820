DROP TABLE if exists old_name_list;
ALTER TABLE name_list
	RENAME TO old_name_list;
