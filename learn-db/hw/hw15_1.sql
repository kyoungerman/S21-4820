SELECT 
		fed_area,
		min(gdp_growth) as max_growth,
		avg(gdp_growth) as avg_growth,
		max(gdp_growth) as min_growth,
		string_agg(state, ',' ORDER BY state) as  state_list
	FROM us_state
	GROUP BY fed_area
	ORDER BY fed_area
;
