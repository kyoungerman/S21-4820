INSERT INTO name_list ( real_name, age, state ) 
	SELECT real_name, age, state 
	FROM old_name_list;
