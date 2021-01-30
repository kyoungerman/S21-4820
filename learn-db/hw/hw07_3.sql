insert into name_list ( real_name, age, state ) 
	select real_name, age, state 
	from old_name_list;
