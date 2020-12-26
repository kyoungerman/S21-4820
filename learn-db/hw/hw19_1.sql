DELETE FROM employee as t0
	WHERE exists (
		SELECT t1.name as "Employee Name", t2.dept_name as "Department Name", t1.pay "Year Pay"
		FROM employee as t1
			LEFT OUTER join department as t2 on ( t1.department_id = t2.department_id )
		WHERE t1.department_id is null
          AND t0.employee_id = t1.employee_id
	)
;
