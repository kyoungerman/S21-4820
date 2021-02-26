explain analyze select * 
	from t_ymux_user as t1 
	join t_ymux_auth_token as t2 on ( t2.user_id = t1.id )
;
