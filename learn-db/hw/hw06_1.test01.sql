SELECT 'PASS' as "test" 
	FROM (
		select count(1) as x, real_name
		from name_list
		group by real_name
	) as t1
	WHERE t1.x = 9
;
