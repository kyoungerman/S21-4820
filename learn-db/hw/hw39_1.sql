create materialized view count_by_state_of_names as
	select count(1) as count_by_state,
		state
	from name_list
	group by state
;
create index count_by_state_of_names_p1 on count_by_state_of_names ( count_by_state );
create index count_by_state_of_names_p2 on count_by_state_of_names ( state );
