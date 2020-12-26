DELETE FROM employee as t0
	WHERE t0.employee_id in (
		SELECT t1.employee_id
		FROM employee as t1
			LEFT OUTER join department as t2 on ( t1.department_id = t2.department_id )
		WHERE t1.department_id is null
	)
;
