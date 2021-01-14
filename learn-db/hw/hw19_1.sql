SELECT t0.name as "Employee Name", t0.dept_name as "Department Name", t0.pay "Year Pay"
	FROM  (
			SELECT t1.name, t2.dept_name, t1.pay, t1.employee_id
			FROM employee as t1
				LEFT OUTER join department as t2 on ( t1.department_id = t2.department_id )
			WHERE t1.department_id is null
			ORDER BY 1, 3 desc, 4
		) as t0
	WHERE 
		exists (
			SELECT 'found'
			FROM employee as t5
			WHERE t5.pay > 65000
			  and t5.employee_id = t0.employee_id
		)
;
