ALTER TABLE name_list add updated timestamp ;
ALTER TABLE name_list add created timestamp 
	default current_timestamp not null  ;
