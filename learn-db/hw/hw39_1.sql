CREATE materialized view count_by_state_of_names as
	SELECT count(1) as count_by_state,
		state
	FROM name_list
	GROUP BY state
;
CREATE INDEX count_by_state_of_names_p1 on count_by_state_of_names ( count_by_state );
CREATE INDEX count_by_state_of_names_p2 on count_by_state_of_names ( state );
