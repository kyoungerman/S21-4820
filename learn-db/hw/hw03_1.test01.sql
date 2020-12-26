SELECT 'PASS' as "test" 
from (
	select count(1) as x
	from name_list
) as t1
where t1.x = 6
;
