SELECT 'PASS' as "test" 
	FROM (
		select count(1) as x
		from name_list
	) as t1
	WHERE t1.x = 10
;
