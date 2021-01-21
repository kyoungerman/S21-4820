select 
		  homework_id
		, homework_no::int as homework_no
	from ct_homework as t1
	where lesson_tokens @@ 'insert'
	order by homework_no asc
;
