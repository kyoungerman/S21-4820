DELETE FROM name_list
	WHERE real_name = 'Jane True'
	  AND name_list_id::text not in (
		SELECT min(name_list_id::text)
		FROM name_list 
		WHERE real_name = 'Jane True'
	)
;
