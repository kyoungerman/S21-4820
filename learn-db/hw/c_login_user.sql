--$file-name$ c_login_user.m4.sql

--$code$ 73







---------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Auth2faEnabled is 'yes' if it is configured in t_ymux_config, or 'Yes' if it is configured for a single user via
-- haveing a rfc_6238_secret set for that youser.  For example if testlogin@gmail has  this value:
-- 
--  select username , rfc_6238_secret from t_ymux_user;
--               username               | rfc_6238_secret  
-- -------------------------------------+------------------
--  app.example.com:testlogin@gmail.com | YFKM6OARYRRVN6NH
--  app.example.com:user1@gmail.com     | 
--  app.example.com:user2@gmail.com     | 
--  app.example.com:user3@gmail.com     | 
--  app.example.com:user4@gmail.com     | 
-- 
-- then a Yes will be returned even thogh the defaut is not non-use 2fa.  So admin accounts can use it when regular
-- users will not have 2fa enabled.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE or REPLACE FUNCTION c_login_user_enc ( p_username varchar, p_key varchar, p_enc_user_hash varchar )
	RETURNS varchar AS $$

DECLARE
	l_data						text;
	l_fail						bool;
	l_junk 						text;
	l_auth_2fa_enabled			text;
	l_auth_login_on_register	text;
	l_auth_email_confirm		text;
	l_auth_token				uuid;
	l_user_id					uuid;
	l_email_confirmed			text;
	l_pwh						text;
	l_salt						text;
	l_email						text;
	l_real_name					text;
	l_acct_type					text;
	l_parent_user_id			uuid;
	l_rfc6238_secret			text;
	l_realm						text;
	l_acct_expire				timestamp;
	l_debug_on					bool;
	l_coverage_on				bool;
	l_is_enc					bool;
BEGIN
	-- version: 9d776a5466a8c1f7c9cba2870d255ab9be1eb348 tag: v0.1.9 build_date: Sat Feb 13 16:56:53 MST 2021

	select split_part( p_username, ':', 1 ) into l_realm;
	select c_get_config_bool ( 'pg.debug.c_login_user_enc', l_realm, 'no' ) into l_debug_on;
	select c_get_config_bool ( 'pg.coverage.c_login_user_enc', l_realm, 'no' ) into l_coverage_on;

	l_debug_on = true;
	l_coverage_on = true;

	if l_debug_on then
		insert into t_output ( msg ) values ( 'Call To: c_ling_user_enc: c_login_user.m4.sql' );
		insert into t_output ( msg ) values ( 'param: l_realm = '||coalesce(to_json(l_realm)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_username = '||coalesce(to_json(p_username)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_enc_user_hash = '||coalesce(to_json(p_enc_user_hash)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_key = '||coalesce(to_json(p_key)::text,'"NULL"') );
	end if;

	if p_key is null or p_key = '' then
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_login_user.m4.sql line_no:73' );
		end if;
		l_is_enc = false;
	else
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_login_user.m4.sql line_no:78' );
		end if;
		l_is_enc = true;
	end if;

	l_fail = false;
	l_data = '{"status":"success"}';

	l_auth_token = uuid_generate_v4();
	l_auth_2fa_enabled = 'x';
	l_auth_login_on_register = 'x';
	l_auth_email_confirm = 'x';

	if l_debug_on then
		insert into t_output ( msg ) values ( 'realm='||l_realm );
	end if;

	select c_get_config ( 'Auth2faEnabled', l_realm, 'no' ) into l_auth_2fa_enabled;
	select c_get_config ( 'AuthLoginOnRegister', l_realm, 'no' ) into l_auth_login_on_register;
	select c_get_config ( 'AuthEmailConfirm', l_realm, 'no' ) into l_auth_email_confirm;

	if not l_fail then
		if l_is_enc then

			if l_coverage_on then
				insert into t_output ( msg ) values ( 'file:c_login_user.m4.sql line_no:103' );
			end if;
			select 
					  "salt"
					, pgp_sym_decrypt(decode("password",'base64'),p_key)
					, "id" as "user_id"
					, "email_confirmed"
					, pgp_sym_decrypt(decode("email",'base64'),p_key)
					, pgp_sym_decrypt(decode("real_name",'base64'),p_key)
					, "acct_type"
					, "parent_user_id"
					, "rfc_6238_secret"
					, "acct_expire"
				into l_salt
					, l_pwh
					, l_user_id
					, l_email_confirmed
					, l_email
					, l_real_name
					, l_acct_type
					, l_parent_user_id
					, l_rfc6238_secret
					, l_acct_expire
				from "t_ymux_user" 
				where "enc_user_hash" = p_enc_user_hash
			;
			if not found then

				if l_coverage_on then
					insert into t_output ( msg ) values ( 'file:c_login_user.m4.sql line_no:132' );
				end if;
				select "salt"
						, "password"
						, "id" as "user_id"
						, "email_confirmed"
						, "email"
						, "real_name"
						, "acct_type"
						, "parent_user_id"
						, "rfc_6238_secret"
						, "acct_expire"
					into l_salt
						, l_pwh
						, l_user_id
						, l_email_confirmed
						, l_email
						, l_real_name
						, l_acct_type
						, l_parent_user_id
						, l_rfc6238_secret
						, l_acct_expire
					from "t_ymux_user" 
					where "username" = p_username
				;
				if not found then
					l_fail = true;
					l_data = '{"status":"error","msg":"Unable to find user.","code":"15100","status_code":401, "at":"c_login_user.m4.sql:159" }';
				end if;

			end if;

		else

			if l_coverage_on then
				insert into t_output ( msg ) values ( 'file:c_login_user.m4.sql line_no:167' );
			end if;
			select "salt"
					, "password"
					, "id" as "user_id"
					, "email_confirmed"
					, "email"
					, "real_name"
					, "acct_type"
					, "parent_user_id"
					, "rfc_6238_secret"
					, "acct_expire"
				into l_salt
					, l_pwh
					, l_user_id
					, l_email_confirmed
					, l_email
					, l_real_name
					, l_acct_type
					, l_parent_user_id
					, l_rfc6238_secret
					, l_acct_expire
				from "t_ymux_user" 
				where "username" = p_username
			;
			if not found then
				l_fail = true;
				l_data = '{"status":"error","msg":"Unable to find user.","code":"15101","status_code":401, "at":"c_login_user.m4.sql:194" }';
			end if;

		end if;
	end if;

	-- check 'acct_expire' at this point  : todo xyzzy  --  Tue Jan 26 06:10:07 MST 2021
	if not l_fail then
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_login_user.m4.sql line_no:203' );
		end if;
		if l_acct_expire is not null and l_acct_expire < now() then
			l_fail = true;
			l_data = '{"status":"error","msg":"Account has expired.","code":"15102","status_code":401, "at":"c_login_user.m4.sql:207" }';
		end if;
	end if;

	if l_rfc6238_secret is not null then
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_login_user.m4.sql line_no:213' );
		end if;
		l_auth_2fa_enabled = 'Yes';
	else 
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_login_user.m4.sql line_no:218' );
		end if;
		l_rfc6238_secret = '';
	end if;
 
	if not l_fail then
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_login_user.m4.sql line_no:225' );
		end if;
		if l_acct_type = 'dev-un-pw-acct' or l_acct_type = 'auth-token' then
			if l_parent_user_id	is null then
				if l_coverage_on then
					insert into t_output ( msg ) values ( 'file:c_login_user.m4.sql line_no:230' );
				end if;
				l_fail = true;
				l_data = '{"status":"error","msg":"User improperly configured...","code":"15103","status_code":401 , "at":"c_login_user.m4.sql:233" }';
			else 
				if l_coverage_on then
					insert into t_output ( msg ) values ( 'file:c_login_user.m4.sql line_no:236' );
				end if;
				-- acct_type of 'other' indicates an invalidated account.
				-- may want to add 'acct_expire' at this point too
				select 'found' as "x"
					into l_junk
					from "t_ymux_user" 
					where "id" = l_parent_user_id::uuid and "acct_type" = 'login-user'
				;
				if not found then
					l_fail = true;
					l_data = '{"status":"error","msg":"Unable to find parent user.","code":"15104","status_code":401 , "at":"c_login_user.m4.sql:247" }';
				end if;
			end if;
		end if;
		if l_acct_type = 'other' then
			l_fail = true;
			l_data = '{"status":"error","msg":"Account Invalid.","code":"15105","status_code":401, "at":"c_login_user.m4.sql:253" }';
		end if;
	end if;

	if not l_fail then
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_login_user.m4.sql line_no:259' );
		end if;
		BEGIN
			insert into "t_ymux_auth_token" ( "id", "user_id" ) values ( l_auth_token, l_user_id::uuid );
		EXCEPTION WHEN unique_violation THEN
			l_fail = true;
			l_data = '{"status":"error","msg":"Unable to create user/auth-token.","code":"15106","status_code":500 , "at":"c_login_user.m4.sql:265" }';
		END;
	end if;

	select c_cleanup_users() into l_junk;

	if not l_fail and l_user_id is not null then
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_login_user.m4.sql line_no:273' );
		end if;
		insert into "t_ymux_user_log" ( "user_id", "activity_name" ) values ( l_user_id::uuid, 'Successful Login:'||l_acct_type );
	else
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_login_user.m4.sql line_no:278' );
		end if;
		insert into "t_ymux_user_log" ( "user_id", "activity_name" ) values ( l_user_id::uuid, 'Failed Login:'||l_acct_type );
	end if;

	if not l_fail then
		l_data = '{"status":"success"'
			||', "user_id":'||coalesce(to_json(l_user_id)::text,'""')
			||', "email_confirmed":'||coalesce(to_json(l_email_confirmed)::text,'""')
			||', "email":'||coalesce(to_json(l_email)::text,'""')
			||', "real_name":'||coalesce(to_json(l_real_name)::text,'""')
			||', "pwh":'||coalesce(to_json(l_pwh)::text,'""')
			||', "salt":'||coalesce(to_json(l_salt)::text,'""')
			||', "auth_token":'||coalesce(to_json(l_auth_token)::text,'""')
			||', "acct_type":'||coalesce(to_json(l_acct_type)::text,'""')
	 		||', "Auth2faEnabled":'||coalesce(to_json(l_auth_2fa_enabled)::text,'""')
	 		||', "AuthLoginOnRegister":'||coalesce(to_json(l_auth_login_on_register)::text,'""')
	 		||', "AuthEmailConfirm":'||coalesce(to_json(l_auth_email_confirm)::text,'""')
	 		||', "RFC6238Secret":'||coalesce(to_json(l_rfc6238_secret)::text,'""')
			||'}';
	end if;

	if l_coverage_on then
		insert into t_output ( msg ) values ( 'file:c_login_user.m4.sql line_no:301' );
	end if;
	RETURN l_data;
END;
$$ LANGUAGE plpgsql;
















CREATE or REPLACE FUNCTION c_login_user ( p_username varchar )
	RETURNS varchar AS $$

DECLARE
	l_data						text;
BEGIN
	-- version: 9d776a5466a8c1f7c9cba2870d255ab9be1eb348 tag: v0.1.9 build_date: Sat Feb 13 16:56:53 MST 2021

	select c_login_user_enc ( p_username , '' , '' )
		into l_data;

	RETURN l_data;
END;
$$ LANGUAGE plpgsql;








