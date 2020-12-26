	SELECT t1.name as "Employee Name", 'No Departmnt' "Department Name", t1.pay "Year Pay"
	FROM employee as t1
UNION
	SELECT 'No Name' as "Employee Name", t2.dept_name as "Department Name", 0.0 "Year Pay"
	FROM department as t2 
ORDER BY 1
;
