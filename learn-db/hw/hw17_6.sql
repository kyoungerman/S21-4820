SELECT sum(t0.pay) as "Total Pay"
FROM (
	SELECT t1.name, t2.dept_name, t1.pay 
	FROM employee as t1
		left outer join department as t2 on ( t1.department_id = t2.department_id )
	WHERE t1.department_id is null
) t0
;
