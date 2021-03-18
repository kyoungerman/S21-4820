
drop view if exists i_issue_list_view;

create or replace view i_issue_list_view as
select 
	t1.id
	, t1.title
	, t1.body
	, t2.state	
	, t1.state_id
	, t3.severity
	, t1.severity_id
	, t1.updated
	, t1.created
	, t1.words
from i_issue as t1
	join i_state as t2 on ( t2.id = t1.state_id )
	join i_severity as t3 on ( t3.id = t1.severity_id )
order by t1.severity_id desc, t1.updated desc, t1.created desc	
;

