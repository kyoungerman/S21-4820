			select
					  t1.homework_id
					, t1.homework_title
					, t1.homework_no
					, t1.points_avail
					, t1.video_url
					, t1.video_img
					, t1.lesson_body
					, t2.id as homework_seen_id
					, substring(date(greatest(t3.created,t3.updated))::text from 1 for 10) when_seen
					, t2.watch_count
					, case
						when t3.pts = 0 then 'n'
						when t3.pts is null then 'n'
						else 'y'
					  end as "has_been_seen"
					, t1.homework_no::int as i_homework_no
					, coalesce(t3.tries,NULL,0,t3.tries) as tries
					, coalesce(t3.pass,NULL,'no',t3.pass) as pass
					, coalesce(greatest(t3.pts,0),null,0,greatest(t3.pts,0)) as pts
				from ct_homework as t1
					left outer join ct_homework_seen as t2 on ( t1.homework_id = t2.homework_id )
					left outer join ct_homework_grade as t3 on ( t1.homework_id = t3.homework_id )
				where exists (
						select 1 as "found"
						from ct_login as t3
						where t3.user_id = $1
					)
			     and ( t3.user_id = $1
					or t3.user_id is null )
				order by 12 asc
;
