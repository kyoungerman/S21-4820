SELECT setup_data_26();

SELECT t1.email, t2.id as "auth_token"
	FROM "t_ymux_user" as t1
		join "t_ymux_auth_token" as t2 on ( t1."id" = t2."user_id" )
;
