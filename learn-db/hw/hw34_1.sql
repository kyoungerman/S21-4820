select
          t1.homework_id
        , t1.homework_no
        , case
            when t3.pts = 0 then 'n'
            when t3.pts is null then 'n'
            else 'y'
          end as "has_been_seen"
        , t1.homework_no::int as i_homework_no
        , coalesce(t3.tries,NULL,0,t3.tries) as tries
    from ct_homework as t1
        left outer join ct_homework_seen as t2 on ( t1.homework_id = t2.homework_id )
        left outer join ct_homework_grade as t3 on ( t1.homework_id = t3.homework_id )
    where exists (
            select 1 as "found"
            from ct_login as t3
            where t3.user_id = '7a955820-050a-405c-7e30-310da8152b6d'
        )
     and ( t3.user_id = '7a955820-050a-405c-7e30-310da8152b6d'
        or t3.user_id is null )
    order by 12 asc
;
