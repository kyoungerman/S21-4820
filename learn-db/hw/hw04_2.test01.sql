
SELECT 'PASS' as "test" 
from (
	select count(1) as x
	from name_list
	where lower(real_name) = real_name
) as t1
where t1.x = 0
;
