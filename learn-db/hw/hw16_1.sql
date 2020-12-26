SELECT 
		fed_area,
		round(avg(gdp_growth)::numeric,2)::text||'%' as avg_growth,
		sum(population) as sum_population,
		count(state) as no_of_states,
		string_agg(state, ',' ORDER BY state) as  state_list
	FROM us_state
	GROUP BY fed_area
	ORDER BY 2 desc
;
