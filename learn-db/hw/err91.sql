select t0.homework_title, t0.tag_word
from(
	select t1.homework_title, t1.homework_no::int, t3.tag_word
	from ct_homework as t1
	join ct_tag_homework as t2 on (t1.homework_id = t2.homework_id)
	join ct_tag as t3 on (t2.tag_id = t3.tag_id)
	order by 2, 1, 3
) as t0
;

