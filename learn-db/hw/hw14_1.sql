alter table name_list add updated timestamp ;
alter table name_list add created timestamp 
	default current_timestamp not null  ;
