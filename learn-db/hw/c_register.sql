--$file-name$ c_register.m4.sql







-- 70100
-- 70101
-- 70102

------------------------------------- ------------------------------------- ------------------------------------- -------------------------------------
--
-- Register a new user.
--
------------------------------------- ------------------------------------- ------------------------------------- -------------------------------------
-- 
-- Description
--
-- Create and register a new login user.
--
-- Tables Used:
--	t_ymux_user
--	t_ymux_auth_token
--	t_ymux_user_log
--	t_registration_token		-- check to see if a registration_token is valid.
--	t_ymux_config				-- config items like registration token required.
--
------------------------------------- ------------------------------------- ------------------------------------- -------------------------------------


DROP FUNCTION if exists c_register_user_all ( p_user_type varchar, p_parent_id varchar, p_id varchar, p_username varchar, p_password varchar, p_salt varchar, p_real_name varchar, p_recovery_token varchar, p_email varchar, p_user_hash varchar, p_qr_id varchar, p_realm varchar, p_setup_2fa_token varchar, p_registration_token varchar, p_key varchar, p_enc_user_hash varchar );

CREATE or REPLACE FUNCTION c_register_user_all ( p_user_type varchar, p_parent_id varchar, p_id varchar, p_username varchar, p_password varchar, p_salt varchar, p_real_name varchar, p_recovery_token varchar, p_email varchar, p_user_hash varchar, p_qr_id varchar, p_realm varchar, p_setup_2fa_token varchar, p_registration_token varchar, p_key varchar, p_enc_user_hash varchar, p_enc_email_hash varchar )
	RETURNS varchar AS $$

DECLARE
	l_2fa_id							uuid;
	l_auth_token						uuid;
	l_data								text;
	l_junk								varchar (20);
	l_fail								bool;
	l_username_enc						text;
	l_email_enc							text;
	l_real_name_enc						text;
	l_password_enc						text;
	l_auth_2fa_enabled					text;
	l_auth_login_on_register			text;
	l_auth_email_confirm				text;
	l_auth_registration_token_required 	text;
	l_email_confirmed					varchar(1);
	l_setup_2fa_complete				varchar(1);
	l_setup_secret 						varchar(40);
	l_is_enc							bool;
	l_check_org							bool;
	l_org_user_id						uuid;
	l_debug_on							bool;
	l_realm								text;
	l_coverage_on						bool;
	l_real_name							text;
BEGIN
	-- version: 9d776a5466a8c1f7c9cba2870d255ab9be1eb348 tag: v0.1.9 build_date: Sat Feb 13 16:56:53 MST 2021

	select split_part( p_username, ':', 1 ) into l_realm;
	select c_get_config_bool ( 'pg.debug.c_register_user_all', l_realm, 'no' ) into l_debug_on;
	select c_get_config_bool ( 'pg.coverage.c_register_user_all', l_realm, 'no' ) into l_coverage_on;

	select trim(p_real_name) into l_real_name;

	l_debug_on = true;
	l_coverage_on = true;

	if l_debug_on then
		insert into t_output ( msg ) values ( 'Call To: c_register_user_all: c_register.m4.sql' );
		insert into t_output ( msg ) values ( 'param: l_realm = '||coalesce(to_json(l_realm)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_user_type = '||coalesce(to_json(p_user_type)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_parent_id = '||coalesce(to_json(p_parent_id)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_id = '||coalesce(to_json(p_id)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_username = '||coalesce(to_json(p_username)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_password = '||coalesce(to_json(p_password)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_salt = '||coalesce(to_json(p_salt)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_real_name = '||coalesce(to_json(p_real_name)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: l_real_name = '||coalesce(to_json(l_real_name)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_recovery_token = '||coalesce(to_json(p_recovery_token)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_email = '||coalesce(to_json(p_email)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_user_hash = '||coalesce(to_json(p_user_hash)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_qr_id = '||coalesce(to_json(p_qr_id)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_realm = '||coalesce(to_json(p_realm)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_setup_2fa_token = '||coalesce(to_json(p_setup_2fa_token)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_registration_token = '||coalesce(to_json(p_registration_token)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_key = '||coalesce(to_json(p_key)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_enc_user_hash = '||coalesce(to_json(p_enc_user_hash)::text,'"NULL"') );
		insert into t_output ( msg ) values ( 'param: p_enc_email_hash = '||coalesce(to_json(p_enc_email_hash)::text,'"NULL"') );
	end if;

	if l_coverage_on then
		insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:97' );
	end if;

	if p_user_type = 'login-user' then
	elsif p_user_type = 'auth-token' or p_user_type = 'dev-un-pw-acct' then
	else
		l_fail = true;
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:105' );
		end if;
		l_data = '{"status":"error"'
			||', "code":"70103"'
			||', "status_code":500'
			||', "at":"c_register.m4.sql:110"'
			||', "msg":"Invalid user type:'||coalesce(to_json(p_user_type)::text,'""')
			||'}';
	end if;

	if p_key is null or p_key = '' then
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:117' );
		end if;
		l_is_enc = false;
	else
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:122' );
		end if;
		l_is_enc = true;
	end if;

	if not l_fail then
		l_check_org = false;
		if p_user_type = 'org:login-user' then
			if l_coverage_on then
				insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:131' );
			end if;
			p_user_type = 'login-user';
			l_check_org	= true;
		end if;
	end if;

	l_fail = false;
	l_data = '{"status":"success"}';
	l_2fa_id = uuid_generate_v4();
	l_auth_2fa_enabled = 'x';
	l_auth_login_on_register = 'x';
	l_auth_email_confirm = 'x';
	l_email_confirmed = 'n';
	l_setup_2fa_complete = 'n';
	l_auth_token = uuid_generate_v4();
	l_setup_secret = null;

	select c_cleanup_users() into l_junk;

	if not l_fail then
		if l_is_enc then 
			if l_coverage_on then
				insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:154' );
			end if;

			select 
					  encode(pgp_sym_encrypt(p_username,p_key),'base64') 
					, encode(pgp_sym_encrypt(l_real_name,p_key),'base64') 
					, encode(pgp_sym_encrypt(p_email,p_key),'base64') 
					, encode(pgp_sym_encrypt(p_password,p_key),'base64') 
				into 
					  l_username_enc
					, l_real_name_enc
					, l_email_enc
					, l_password_enc
			;

			if l_debug_on then
				insert into t_output ( msg ) values ( 'file:c_register.m4.sql/enc: p_key='||p_key );
				insert into t_output ( msg ) values ( 'file:c_register.m4.sql/enc: username='||p_username );
				insert into t_output ( msg ) values ( 'file:c_register.m4.sql/enc: l_username_enc='||l_username_enc );
			end if;
		end if;
	end if;


	if not l_fail then
		-- Config Options
		select c_get_config ( 'Auth2faEnabled', p_realm, 'no' ) into l_auth_2fa_enabled;
		select c_get_config ( 'AuthLoginOnRegister', p_realm, 'no' ) into l_auth_login_on_register;
		select c_get_config ( 'AuthEmailConfirm', p_realm, 'no' ) into l_auth_email_confirm;
		select c_get_config ( 'AuthRegistrationTokenRequired', p_realm, 'no' ) into l_auth_registration_token_required;
	end if;

	if p_id is null or p_username is null then
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:188' );
		end if;
		l_fail = true;
	end if;

	if p_user_type = 'auth-token' or p_user_type = 'dev-un-pw-acct' then
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:195' );
		end if;
		if p_parent_id is null then
			l_fail = true;
		end if;

		l_setup_2fa_complete = 'y';
		l_email_confirmed = 'y';

		if not l_fail then
			select "org_user_id"
				into l_org_user_id
				from "t_ymux_user"
				where "id" = p_parent_id::uuid
				  and "acct_type" = 'login-user'
				;
			if not found then
				l_fail = true;
				l_data = '{"status":"error","msg":"Unable to find user.","code":"70104","status_code":401,"at":"c_register.m4.sql:213"}';
			end if;
		end if;
	else
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:218' );
		end if;

		if l_check_org then
			if not l_fail then
				if l_coverage_on then
					insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:224' );
				end if;
				select "org_user_id"
					into l_org_user_id
					from "t_ymux_user"
					where "id" = p_parent_id::uuid
					  and "acct_type" = 'login-user'
					;
				if not found then
					l_fail = true;
					l_data = '{"status":"error","msg":"Unable to find user.","code":"70105","status_code":401, "at":"c_register.m4.sql:234"}';
				end if;
			end if;
		else
			-- check for registration token if necessary. -- use p_setup_2fa_token 
			if l_auth_registration_token_required = 'yes' then
				if l_coverage_on then
					insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:241' );
				end if;
				select 'ok'
					into l_junk
						from "t_registration_token"
						where "token" = p_registration_token::uuid
						;
				if not found then
					l_fail = true;
					l_data = '{"status":"error","msg":"Unable to create user - invalid registration token.","code":"70106","status_code":401, "at":"c_register.m4.sql:250"}';
				end if;
			end if;
		end if;

		if l_auth_2fa_enabled = 'no' then
			-- if we do not have 2fa turned on then we are done, it is complete.
			l_setup_2fa_complete = 'y';
		else
			select random_string(15) into l_setup_secret ;
		end if;
		if l_auth_email_confirm = 'no' then
			-- if we are not requiring email confiormation then the account is automatically confirmed.
			l_email_confirmed = 'y';
		end if;
	end if;

	if not l_fail then
		BEGIN
			if l_is_enc then 
				if l_coverage_on then
					insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:271' );
				end if;
				delete from "t_ymux_user_log"
					where "user_id" in (
						select "id" from "t_ymux_user"
							where "enc_user_hash" = p_enc_user_hash
							  and "acct_expire" = '2000-01-01'
					)
				;
				delete from "t_ymux_auth_token"
					where "user_id" in (
						select "id" from "t_ymux_user"
							where "enc_user_hash" = p_enc_user_hash
							  and "acct_expire" = '2000-01-01'
					)
				;
				delete from "t_ymux_user"
					where "enc_user_hash" = p_enc_user_hash
					  and "acct_expire" = '2000-01-01'
				;
				insert into "t_ymux_user" ( 
						  "id"
						, "username"			-- ENC
						, "password"			-- ENC
						, "salt"
						, "real_name"			-- ENC
						, "recovery_token"
						, "email"				-- ENC
						, "email_confirmed"
						, "setup_2fa_complete"
						, "realm"
						, "setup_2fa_token"
						, "acct_expire"
						, "enc_user_hash"
						, "acct_type"
						, "org_user_id"
						, "enc_email_hash"
					) values ( 
						  p_id::uuid
						, l_username_enc		-- ENC
						, l_password_enc		-- ENC
						, p_salt
						, l_real_name_enc		-- ENC
						, p_recovery_token
						, l_email_enc			-- ENC
						, l_email_confirmed
						, l_setup_2fa_complete
						, p_realm
						, l_setup_secret
						, '2000-01-01'
						, p_enc_user_hash
						, p_user_type
						, l_org_user_id
						, p_enc_email_hash
					);
			else
				if l_coverage_on then
					insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:328' );
				end if;
				delete from "t_ymux_user_log"
					where "user_id" in (
						select "id" from "t_ymux_user"
							where "username" = p_username
							  and "acct_expire" = '2000-01-01'
					)
				;
				delete from "t_ymux_auth_token"
					where "user_id" in (
						select "id" from "t_ymux_user"
							where "username" = p_username
							  and "acct_expire" = '2000-01-01'
					)
				;
				delete from "t_ymux_user"
					where "username" = p_username
					  and "acct_expire" = '2000-01-01'
				;
				insert into "t_ymux_user" (
						  "id"
						, "username"
						, "password"
						, "salt"
						, "real_name"
						, "recovery_token"
						, "email"
						, "email_confirmed"
						, "setup_2fa_complete"
						, "realm"
						, "setup_2fa_token"
						, "acct_expire"
						, "acct_type"
						, "org_user_id"
					) values (
						  p_id::uuid
						, p_username
						, p_password
						, p_salt
						, l_real_name
						, p_recovery_token
						, p_email
						, l_email_confirmed
						, l_setup_2fa_complete
						, p_realm
						, l_setup_secret
						, '2000-01-01'
						, p_user_type
						, l_org_user_id
					);
			end if;
		EXCEPTION WHEN unique_violation THEN
			l_fail = true;
			l_data = '{"status":"error","msg":"Unable to create user - user already exists.","code":"70107","status_code":500 , "at":"c_register.m4.sql:382" }';
		END;
	end if;

	if not l_fail then
		select c_setup_2fa_tables(l_2fa_id, p_id::uuid, p_user_hash, p_qr_id) into l_junk;
	end if;

	if not l_fail then
		if l_auth_login_on_register = 'yes' then
			if l_coverage_on then
				insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:393' );
			end if;
			-- l_auth_token = uuid_generate_v4();
			BEGIN
				insert into "t_ymux_auth_token" ( "id", "user_id" ) values ( l_auth_token, p_id::uuid );
			EXCEPTION WHEN unique_violation THEN
				l_fail = true;
				l_data = '{"status":"error","msg":"Unable to create user/auth-token.","code":"70108","status_code":500 , "at":"c_register.m4.sql:400" }';
			END;
		end if;
	end if;

	-- delete from "t_ymux_auth_token" where "created" < now() - '14 day'::interval;
	select c_cleanup_users() into l_junk;

	if not l_fail and p_id is not null then
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:410' );
		end if;
		insert into "t_ymux_user_log" ( "user_id", "activity_name" ) values ( p_id::uuid, 'Registration' );
	else
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:415' );
		end if;
		insert into "t_ymux_user_log" ( "user_id", "activity_name" ) values ( p_id::uuid, 'Failed Registration' );
	end if;

	select c_app_user_setup ( p_id, p_user_type, p_email ) into l_junk;

	if l_coverage_on then
		insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:423' );
	end if;

	if not l_fail then
		if p_user_type = 'login-user' then
			if l_coverage_on then
				insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:429' );
			end if;
			l_data = '{"status":"success"'
				||', "user_id":'||coalesce(to_json(p_id)::text,'""')
				||', "x2fa_id":'||coalesce(to_json(l_2fa_id)::text,'""')
				||', "auth_token":'||coalesce(to_json(l_auth_token)::text,'""')
				||', "setup_2fa_token":'||coalesce(to_json(p_setup_2fa_token)::text,'""')
				||', "Auth2faEnabled":'||coalesce(to_json(l_auth_2fa_enabled)::text,'""')
				||', "AuthLoginOnRegister":'||coalesce(to_json(l_auth_login_on_register)::text,'""')
				||', "AuthEmailConfirm":'||coalesce(to_json(l_auth_email_confirm)::text,'""')
				||'}';
		elsif p_user_type = 'auth-token' or p_user_type = 'dev-un-pw-acct' then
			if l_coverage_on then
				insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:442' );
			end if;
			l_data = '{"status":"success"'
				||', "user_id":'||coalesce(to_json(p_id)::text,'""')
				||', "auth_token":'||coalesce(to_json(l_auth_token)::text,'""')
				||'}';
		else
			l_fail = true;
			if l_coverage_on then
				insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:451' );
			end if;
			l_data = '{"status":"error"'
				||', "code":"70109"'
				||', "status_code":500'
				||', "at":"c_register.m4.sql:456"'
				||', "msg":"Invalid user type:'||coalesce(to_json(p_user_type)::text,'""')
				||'}';
		end if;
	else
		if l_coverage_on then
			insert into t_output ( msg ) values ( 'file:c_register.m4.sql line_no:462' );
		end if;
		delete from "t_ymux_user" where "id" = p_id::uuid;
	end if;

	RETURN l_data;
END;
$$ LANGUAGE plpgsql;






































































DROP FUNCTION if exists c_register_user(character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying,character varying);

CREATE or REPLACE FUNCTION c_register_user ( p_id varchar, p_username varchar, p_password varchar, p_salt varchar, p_real_name varchar, p_recovery_token varchar, p_email varchar, p_user_hash varchar, p_qr_id varchar, p_realm varchar, p_setup_2fa_token varchar, p_registration_token varchar )
	RETURNS varchar AS $$

DECLARE
	l_data								text;
BEGIN
	-- version: 9d776a5466a8c1f7c9cba2870d255ab9be1eb348 tag: v0.1.9 build_date: Sat Feb 13 16:56:53 MST 2021

	select c_register_user_all (
			  'login-user'		-- p_user_type
			, ''
			, p_id
			, p_username
			, p_password
			, p_salt
			, p_real_name
			, p_recovery_token
			, p_email
			, p_user_hash
			, p_qr_id
			, p_realm
			, p_setup_2fa_token
			, p_registration_token
			, ''
			, ''
			, ''
			)
		into l_data;
	RETURN l_data;
END;
$$ LANGUAGE plpgsql;





























DROP FUNCTION if exists c_register_user_enc ( p_id varchar, p_username varchar, p_password varchar, p_salt varchar, p_real_name varchar, p_recovery_token varchar, p_email varchar, p_user_hash varchar, p_qr_id varchar, p_realm varchar, p_setup_2fa_token varchar, p_registration_token varchar, p_key varchar, p_enc_user_hash varchar );

CREATE or REPLACE FUNCTION c_register_user_enc ( p_id varchar, p_username varchar, p_password varchar, p_salt varchar, p_real_name varchar, p_recovery_token varchar, p_email varchar, p_user_hash varchar, p_qr_id varchar, p_realm varchar, p_setup_2fa_token varchar, p_registration_token varchar, p_key varchar, p_enc_user_hash varchar, p_enc_email_hash varchar )
	RETURNS varchar AS $$

DECLARE
	l_data								text;
BEGIN
	-- version: 9d776a5466a8c1f7c9cba2870d255ab9be1eb348 tag: v0.1.9 build_date: Sat Feb 13 16:56:53 MST 2021

	select c_register_user_all ( 'login-user', '', p_id, p_username, p_password, p_salt, p_real_name, p_recovery_token, p_email, p_user_hash, p_qr_id, p_realm, p_setup_2fa_token, p_registration_token, p_key, p_enc_user_hash, p_enc_email_hash )
			into l_data;

	RETURN l_data;
END;
$$ LANGUAGE plpgsql;












CREATE or REPLACE FUNCTION c_finalize_user ( p_user_id varchar )
	RETURNS varchar AS $$

DECLARE
	l_data						text;

BEGIN
	-- version: 9d776a5466a8c1f7c9cba2870d255ab9be1eb348 tag: v0.1.9 build_date: Sat Feb 13 16:56:53 MST 2021

	l_data = '{"status":"success"}';
	update "t_ymux_user"
		set "acct_expire" = NULL
		where "id" = p_user_id::uuid
		  and "acct_expire" = '2000-01-01'
	;
	RETURN l_data;
END;
$$ LANGUAGE plpgsql;











-- 7a955820-050a-405c-7e30-310da8152b6d 
-- 7a955820-050a-405c-7e30-310da8152b6d | e772d993-1030-41b9-6612-397944e45147 
-- 7a955820-050a-405c-7e30-310da8152b6d | 611262a0-e900-4997-43e7-c5743583880d 
-- 7a955820-050a-405c-7e30-310da8152b6d | 7e5cbb5c-4b28-421b-611a-eb5cee1f6e09 


-- insert into "t_ymux_user" ( "acct_type", "config", "created", "email", "email_confirmed", "id", "password", "real_name", "realm", "recovery_token", "roles_privs", "salt", "setup_2fa_complete", "user_role", "username" ) values ( 'login-user', '{"config":["user"]}', '2021-01-25T18:31:53.14212+0000', 'abando@uwyo.edu', 'y', 'f21552b6-3c19-4f48-7c78-0da8d9e437ef', '17c5f731435329bd3629270b24081d33f832e86e16887d426f408ec7be5db189a444da7658fac571d47881820c345579188215ba64813e7165ac2e210647f4b0', ' Arsene Bando', 'app.example.com', '908d980c-ea85-499e-64e4-3e4fb4681b2f', '{"role":"user","privs":["user"]}', '3237333635313339', 'y', 'user', 'app.example.com:abando@uwyo.edu' );
-- insert into "t_ymux_user" ( "acct_type", "config", "created", "email", "email_confirmed", "id", "password", "real_name", "realm", "recovery_token", "roles_privs", "salt", "setup_2fa_complete", "user_role", "username" ) values ( 'login-user', '{"config":["user"]}', '2021-01-25T18:31:53.21474+0000', 'cdepaol1@uwyo.edu', 'y', '875bdb67-d483-4aea-6086-f4dabb83f2c6', 'a11a4cc4cc16974a878d217fde93abf0b1ec15264b42a835f61e8f95c95f0b3ddb23a8d8f0e808831e54ae10b4805980884fd8d59823d016efa0a9579782baec', ' Cale J. Depaolo', 'app.example.com', 'dc132728-3378-4d2c-6cac-42741c6f86b3', '{"role":"user","privs":["user"]}', '3934303732303438', 'y', 'user', 'app.example.com:cdepaol1@uwyo.edu' );
-- insert into "t_ymux_user" ( "acct_type", "config", "created", "email", "email_confirmed", "id", "password", "real_name", "realm", "recovery_token", "roles_privs", "salt", "setup_2fa_complete", "user_role", "username" ) values ( 'login-user', '{"config":["user"]}', '2021-01-25T18:31:53.28294+0000', 'myraiken@uwyo.edu', 'y', 'e3b64e4f-05cf-4807-44c3-c1c8a5a6432e', '5fe5fc91088da7dd1e712f6621e06b2aa922060815f6cf25417e7093108a68ec6eec1e5e8f5fea304df79b87a8ce24e5653740085e35c59704215325af68a298', ' James W Hockenberry', 'app.example.com', '44ea6edf-c0b1-4f71-79bc-fc3560ab30d2', '{"role":"user","privs":["user"]}', '3030303233303232', 'y', 'user', 'app.example.com:myraiken@uwyo.edu' );
-- insert into "t_ymux_user" ( "acct_type", "config", "created", "email", "email_confirmed", "id", "password", "real_name", "realm", "recovery_token", "roles_privs", "salt", "setup_2fa_complete", "user_role", "username" ) values ( 'login-user', '{"config":["user"]}', '2021-01-25T18:31:53.37993+0000', 'pschlump1@uwyo.edu', 'y', '3b12487b-4b8a-4d4c-776c-d5c30e12d9e8', '5ed0575bc3014c223d764db9ca8f5682b119dc5f6560d6132db6b78181c4a30d144a7471890304be5b77290ea3c0b44967203cb4681f85df0177dbc576094e05', ' Test A Schlump', 'app.example.com', '9c262826-b2d4-4374-76a9-1eb380d2c8c4', '{"role":"user","privs":["user"]}', '3034393737363530', 'y', 'user', 'app.example.com:pschlump1@uwyo.edu' );
-- insert into "t_ymux_user" ( "acct_type", "config", "created", "email", "email_confirmed", "id", "password", "real_name", "realm", "recovery_token", "roles_privs", "salt", "setup_2fa_complete", "user_role", "username" ) values ( 'login-user', '{"config":["user"]}', '2021-01-25T18:31:53.45075+0000', 'pschlump2@uwyo.edu', 'y', '4246c38a-5476-451c-45b5-6ea0e6cae5c6', '276dcb17fb038cbc4d3bf7f7ff83ebd88d10ba462ffc67d51238a4b4f27502db5b0b3b3d1096276bb9fb2d9bc9fd09aa96319e4b7e8e7afd96c733b354a37715', ' Test B Schlump', 'app.example.com', 'c2000a8e-8b2d-4ff5-7d93-8c17e2d76081', '{"role":"user","privs":["user"]}', '3330393137353739', 'y', 'user', 'app.example.com:pschlump2@uwyo.edu' );
-- insert into "t_ymux_user" ( "acct_expire", "acct_type", "config", "created", "email", "email_confirmed", "id", "password", "real_name", "realm", "recovery_token", "roles_privs", "salt", "setup_2fa_complete", "user_role", "username" ) values ( '2000-01-01T00:00:00+0000', 'login-user', '{"config":["user"]}', '2021-01-29T13:31:01.56192+0000', 'rolson14@uwyo.edu', 'y', 'c4aa9455-ac98-43bc-4707-ebc6c95e65e0', 'e4cde56cedba6f0f97786317665d9ae685754a2310ddab23d97b659c8751f38286a38ddc99e64c98f92211fe8b2fb2cdfd931c7f6e5679a720ec4dc41274c969', 'Reid P. Olson Reid P. Olson', 'app.example.com', '3c2922a8-193c-4ad5-539f-992756214f3f', '{"role":"user","privs":["user"]}', '3633323335363439', 'y', 'user', 'app.example.com:rolson14@uwyo.edu' );



-- 1. A "setup" for each test
-- 2. A "tear down" for each test
-- 3. A "call" for each test -> pass/fail
CREATE or REPLACE FUNCTION c_register_user__setup()
	RETURNS varchar AS $$
BEGIN
	delete from "t_ymux_user_log"
		where "id" in ( '02f40ddd-8d4e-4090-692c-6630ededaae6'::uuid )
	;
	delete from "t_ymux_auth_token"
		where "user_id" = '02f40ddd-8d4e-4090-692c-6630ededaae6'
	;
	delete from "t_ymux_user"
		where "id" = '02f40ddd-8d4e-4090-692c-6630ededaae6'
	;
	-- setup config for app.test.com - no-emila-conf, no-2fa, immediate-login
END;
$$ LANGUAGE plpgsql;







CREATE or REPLACE FUNCTION c_register_user__teardown()
	RETURNS varchar AS $$
BEGIN
	delete from "t_ymux_user_log"
		where "id" in ( '02f40ddd-8d4e-4090-692c-6630ededaae6'::uuid )
	;
	delete from "t_ymux_auth_token"
		where "user_id" = '02f40ddd-8d4e-4090-692c-6630ededaae6'
	;
	delete from "t_ymux_user"
		where "id" = '02f40ddd-8d4e-4090-692c-6630ededaae6'
	;
	delete from "t_ymux_config"
		where "realm" = 'app.test.com'
	;
END;
$$ LANGUAGE plpgsql;







CREATE or REPLACE FUNCTION c_register_user__test()
	RETURNS varchar AS $$

DECLARE
	l_data						text;
	l_status					text;
	l_rv						text;

BEGIN
	delete from t_output;

	-- test cases - register user w/ 
	-- insert into "t_ymux_user" ( "acct_type", "config", "created", "email", "email_confirmed", "id", "password", "real_name", "realm", "recovery_token", "roles_privs",
	--	"salt", "setup_2fa_complete", "user_role", "username" ) values ( 'login-user', '{"config":["user"]}', '2021-01-25T18:31:53.14212+0000', 'abando@uwyo.edu',
	--	'y', 'f21552b6-3c19-4f48-7c78-0da8d9e437ef',
	--	'17c5f731435329bd3629270b24081d33f832e86e16887d426f408ec7be5db189a444da7658fac571d47881820c345579188215ba64813e7165ac2e210647f4b0', ' Arsene Bando',
	--	'app.example.com', '908d980c-ea85-499e-64e4-3e4fb4681b2f', '{"role":"user","privs":["user"]}', '3237333635313339', 'y', 'user',
	--	'app.example.com:abando@uwyo.edu' );
	select c_register_user ( 
		  '02f40ddd-8d4e-4090-692c-6630ededaae6' 		--   p_id varchar
		, 'app.example.com:test_user1@gmail.com' 		-- , p_username varchar
		, '17c5f731435329bd3629270b24081d33f832e86e16887d426f408ec7be5db189a444da7658fac571d47881820c345579188215ba64813e7165ac2e210647f4b0' -- , p_password varchar
		, '3237333635313339' 							-- , p_salt varchar
		, 'Jules Verne'									-- , p_real_name varchar
	 	, 'f21552b6-3c19-4f48-7c78-0da8d9e437ef' 		-- , p_recovery_token varchar
		, 'test_user1@gmail.com' 						-- , p_email varchar
		, '' 											-- , p_user_hash varchar
		, '' 											-- , p_qr_id varchar
		, 'app.example.com' 							-- , p_realm varchar
		, 'e772d993-1030-41b9-6612-397944e45147' 		-- , p_setup_2fa_token varchar
		, '611262a0-e900-4997-43e7-c5743583880d' 		-- , p_registration_token varchar
		)
		into l_data;
	-- verify data has
		-- sample output : {"status":"success", "user_id":"02f40ddd-8d4e-4090-692c-6630ededaae6", "x2fa_id":"ff06cef9-67d0-48c3-be7d-d4a57a4bb819",
			-- "auth_token":"09bdb3d3-2ef1-47d9-955f-bb9c536f2154", "setup_2fa_token":"e772d993-1030-41b9-6612-397944e45147", "Auth2faEnabled":"no",
			-- "AuthLoginOnRegister":"yes", "AuthEmailConfirm":"no"}
	select json_extract_path ( l_data::json, 'status' )
		into l_status;

	if l_status = '"success"' then
		l_rv = 'PASS';
	else
		l_rv = 'FAIL';
	end if;

	return l_rv;
END;
$$ LANGUAGE plpgsql;


select c_register_user__test();

select msg from t_output;

delete from "t_ymux_user" where username = 'app.example.com:test_user1@gmail.com';
