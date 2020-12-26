SELECT t1.avg_growth, t1.state_list
	FROM (
		SELECT 
				t2.fed_area,
				avg(t2.gdp_growth) as avg_growth,
				string_agg(t2.state, ',' ORDER BY state) as  state_list
			FROM us_state as t2
			GROUP BY t2.fed_area
	) as t1
;
