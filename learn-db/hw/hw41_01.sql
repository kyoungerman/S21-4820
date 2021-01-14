SELECt
		  t1.real_name
		, t1.state
		, case
			when t1.state = 'WY' then 'y'
			when t1.state is null then 'n'
			else 'n'
		  end as "in_wyoming"
	FROM name_list as t1
;
