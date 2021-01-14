SELECT 
		dept,
		emp_id,
		salary,
		sum(salary) OVER (PARTITION BY dept)  as  dept_total
	FROM emp_sal
;

