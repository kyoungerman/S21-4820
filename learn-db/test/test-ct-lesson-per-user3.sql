	select
			  t1.lesson_id
			, t1.video_raw_file
			, t1.video_title
			, t1.url
			, t1.img_url
			, t1.lesson
			, t1.lesson_name
			, t2.id as video_seen_id
			, t2.when_seen
			, t2.watch_count
			, case
				when t2.watch_count = 0 then 'n'
				when t2.watch_count is null then 'n'
				else 'y'
			  end as "has_been_seen"
			, t1.lang_to_use				
		from ct_lesson as t1
			left outer join ct_lesson_seen as t2 on ( t1.lesson_id = t2.lesson_id )
		where exists (
				select 1 as "found"
				from ct_login as t3
				where t3.user_id = '1673ae13-3f7a-4a6d-7830-a05ddecb4e0f'
				  and t3.lang_to_use = t1.lang_to_use
			)
;
