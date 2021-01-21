select 
		  homework_id
		, homework_no::int as homework_no
	from ct_homework as t1
	where exists (
		select 'found'
		from ct_tag as t3
			join ct_tag_homework as t2 on ( t3.tag_id = t2.tag_id )
		where t2.homework_id = t1.homework_id
		  and t3.tag_word = 'insert'
	)
	order by homework_no asc
;
