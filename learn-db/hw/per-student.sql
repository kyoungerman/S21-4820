select t2.real_name, substr(t2.username,17) as email_address, t2.cnt, t2.ssum, t2.mark 
	from (
		select uuu.real_name, uuu.username, t1.user_id, count(t1.homework_id) as cnt, sum(t1.pts) as ssum,
			case 
				when sum(t1.pts) < 200 then '*'
				else ' '
			end as mark
		from ct_homework_grade as t1
			join ct_login as login on ( login.user_id = t1.user_id )
			join t_ymux_user as uuu on ( uuu.id = login.user_id )
		group by uuu.real_name, uuu.username, t1.user_id
	) as t2
union 
	select t5.real_name, substr(t5.username,17) as email_address, 0 as cnt, 0 as ssum, '!' as mark 
	from t_ymux_user as t5
	where not exists (
		select 'found'
		from ct_homework_grade as t4
		where t4.user_id = t5.id
	) and (
		t5.real_name not in ( 'Test Login', 'user 1 aaa', ' Tamara Thalia Linse', ' Test A Schlump', ' Test B Schlump')
	)
order by 1 asc
;
