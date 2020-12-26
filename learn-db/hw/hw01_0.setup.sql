
DROP TABLE IF EXISTS name_list;
DROP TABLE IF EXISTS us_state;

DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS department;

CREATE OR REPLACE FUNCTION soundex(input text) RETURNS text
IMMUTABLE STRICT COST 500 LANGUAGE plpgsql
AS $$
DECLARE
	soundex text = '';
	char text;
	symbol text;
	last_symbol text = '';
	pos int = 1;
BEGIN
	WHILE length(soundex) < 4 LOOP
		char = upper(substr(input, pos, 1));
		pos = pos + 1;
		CASE char
		WHEN '' THEN
			-- End of input string
			IF soundex = '' THEN
				RETURN '';
			ELSE
				RETURN rpad(soundex, 4, '0');
			END IF;
		WHEN 'B', 'F', 'P', 'V' THEN
			symbol = '1';
		WHEN 'C', 'G', 'J', 'K', 'Q', 'S', 'X', 'Z' THEN
			symbol = '2';
		WHEN 'D', 'T' THEN
			symbol = '3';
		WHEN 'L' THEN
			symbol = '4';
		WHEN 'M', 'N' THEN
			symbol = '5';
		WHEN 'R' THEN
			symbol = '6';
		ELSE
			-- Not a consonant; no output, but next similar consonant will be re-recorded
			symbol = '';
		END CASE;

		IF soundex = '' THEN
			-- First character; only accept strictly English ASCII characters
			IF char ~>=~ 'A' AND char ~<=~ 'Z' THEN
				soundex = char;
				last_symbol = symbol;
			END IF;
		ELSIF last_symbol != symbol THEN
			soundex = soundex || symbol;
			last_symbol = symbol;
		END IF;
	END LOOP;

	RETURN soundex;
END;
$$;





-- select setup_data_26();

CREATE OR REPLACE FUNCTION setup_data_26() RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
	pos int = 1;
BEGIN
	delete from "t_ymux_auth_token" where "user_id" = '7a955820-050a-405c-7e30-310da8152b6d';
	delete from "t_ymux_user" where "id" = '7a955820-050a-405c-7e30-310da8152b6d';

	insert into "t_ymux_user" (
		  "id"					
		, "username" 		
		, "password" 			
		, "realm" 			
		, "real_name" 	
		, "salt" 	
		, "email" 				
		, "email_confirmed" 
		, "setup_2fa_complete" 	
		, "rfc_6238_secret"	
		, "recovery_token" 
		, "recovery_expire" 	
		, "parent_user_id"		
	) values
		 ( '7a955820-050a-405c-7e30-310da8152b6d', 	-- id
			'app.example.com:testlogin@gmail.com', 	-- username realm
			'8009f839a419a57023235cacd45aacc6675561131a80524a01412c1c833bdb17d51a205c639cdf3630bcc79abb32c02c6efb4255bf39bf73806d650d5ff9867c', -- password
			'app.example.com', 						-- realm
			'Test Login', 							-- real name
			'3738333337333832', 					-- salt
			'testlogin@gmail.com', 					-- email
			'y', 									-- email_confirmed
			'y', 									-- setup_2fa_complete
			'YFKM6OARYRRVN6NH',  					-- secret
			'ee201a82-84f0-4278-5e7d-10d511b1ad80', -- recovery token
			NULL, 									-- recover_expire = null is expired
			NULL 									-- parent_user_id
		);
			-- 'login-user', 							-- acct_type

	insert into "t_ymux_auth_token" ( "id", "user_id" ) values 
		 ('527b00e6-dd14-4096-5c57-d2d9563182d1', '7a955820-050a-405c-7e30-310da8152b6d'),
		 ('cc5e15ad-92a3-4661-96c7-6004d58e523b', '7a955820-050a-405c-7e30-310da8152b6d'),
 		 ('e84fad29-7167-440f-a58b-ce97371f5009', '7a955820-050a-405c-7e30-310da8152b6d')
	;

	RETURN 'PASS';
END;
$$;
