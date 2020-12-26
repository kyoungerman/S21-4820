select t1.name as "Employee Name", t2.dept_name as "Department Name", t1.pay "Year Pay"
from employee as t1
	left outer join department as t2 on ( t1.department_id = t2.department_id )
where t1.department_id is null
;
