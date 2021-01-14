
SELECT 'PASS' as "test" 
	FROM (
		select count(1) as x
		from name_list
		where lower(real_name) = real_name
	) as t1
	WHERE t1.x = 0
;
