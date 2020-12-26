SELECT t1.name as "Employee Name", t2.dept_name as "Department Name", t1.pay "Year pay"
FROM employee as t1
	FULL JOIN  department as t2 on ( t1.department_id = t2.department_id )
;
