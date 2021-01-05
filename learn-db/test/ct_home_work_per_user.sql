-- handle.go: 193
-- added user_id
			select
					  t1.homework_id
					, t1.homework_title
					, t1.homework_no
					, t1.points_avail
					, t1.video_url
					, t1.video_img
					, t1.lesson_body
					, t2.id as homework_seen_id
					, t2.when_seen
					, t2.watch_count
					, case
						when t2.watch_count = 0 then 'n'
						when t2.watch_count is null then 'n'
						else 'y'
					  end as "has_been_seen"
				from ct_homework as t1
					left outer join ct_homework_seen as t2 on ( t1.homework_id = t2.homework_id )
				where exists (
						select 1 as "found"
						from ct_login as t3
						where t3.user_id = '7a955820-050a-405c-7e30-310da8152b6d'::uuid
					)
				order by t1.homework_no
;
