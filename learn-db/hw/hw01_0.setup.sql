
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
	delete from "t_ymux_auth_token" cascade where "user_id" = '7a955820-050a-405c-7e30-310da8152b6d' ;
	delete from "t_ymux_user" cascade where "id" = '7a955820-050a-405c-7e30-310da8152b6d' ;
	delete from "t_ymux_user_log" cascade;
	delete from ct_homework cascade;
	delete from ct_tag_homework cascade;
	delete from ct_tag cascade;

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

	insert into "t_ymux_user_log" (
		  "user_id"				
		, "activity_name"	
	) values 
		( '7a955820-050a-405c-7e30-310da8152b6d', 'Login' ),
		( '7a955820-050a-405c-7e30-310da8152b6d', 'Logout' )
	;

	-- hw26_5
	-- insert into ct_homework ( homework_id, homework_no, homework_title, points_avail, video_url, video_img, lesson_body ) values
	-- ;
	-- hw26_9
	-- insert into ct_tag_homework ( tag_id, homework_id ) values
	-- ;
	-- hw26_10
	-- insert into ct_tag ( tag_id, tag_word ) values
	-- ;

	-- title:     3:# Interactive - 01 - Create Table
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '72830246-411d-4fa1-59cb-2dae0c5b6578', ' Interactive - 01 - Create Table', '1', 'hw01.mp4', 'hw01.jpg', '{}' );
	-- tag  :    43:#### Tags: "create table","type text","type int","type varchar","hw01"
	insert into ct_tag ( tag_id, tag_word ) values ( '9ceb97da-5f7a-4ab8-7e49-d8a96c6d6e6e', 'create table' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '9ceb97da-5f7a-4ab8-7e49-d8a96c6d6e6e', '72830246-411d-4fa1-59cb-2dae0c5b6578' );
	insert into ct_tag ( tag_id, tag_word ) values ( '0da26ca0-b9c7-4a34-791d-b1df5eda8e0c', 'type text' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '0da26ca0-b9c7-4a34-791d-b1df5eda8e0c', '72830246-411d-4fa1-59cb-2dae0c5b6578' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'bc61a434-c9cc-44c0-5070-2a2d0a965361', 'type int' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'bc61a434-c9cc-44c0-5070-2a2d0a965361', '72830246-411d-4fa1-59cb-2dae0c5b6578' );
	insert into ct_tag ( tag_id, tag_word ) values ( '6a246df3-b6fe-4897-6576-552807281035', 'type varchar' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '6a246df3-b6fe-4897-6576-552807281035', '72830246-411d-4fa1-59cb-2dae0c5b6578' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'c714ccf9-e482-4809-557e-253584269405', 'hw01' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'c714ccf9-e482-4809-557e-253584269405', '72830246-411d-4fa1-59cb-2dae0c5b6578' );
	-- title:     3:# Interactive - 02 - Insert data into "name_list"
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '1c48c224-4db3-4693-79f5-79c9a67248a4', ' Interactive - 02 - Insert data into "name_list"', '2', 'hw02.mp4', 'hw02.jpg', '{}' );
	-- tag  :    60:#### Tags: "hw02","insert"    	
	insert into ct_tag ( tag_id, tag_word ) values ( 'a20991ec-f3ad-4404-7522-abc74affc718', 'hw02' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'a20991ec-f3ad-4404-7522-abc74affc718', '1c48c224-4db3-4693-79f5-79c9a67248a4' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'e4728086-8e1f-4a49-7ae6-9e1b02abed25', 'insert' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'e4728086-8e1f-4a49-7ae6-9e1b02abed25', '1c48c224-4db3-4693-79f5-79c9a67248a4' );
	-- title:     3:# Interactive - 03 - Select data back from the table
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '628cbc2f-7b8e-40b5-6500-ebd7b66b8aa1', ' Interactive - 03 - Select data back from the table', '3', 'hw03.mp4', 'hw03.jpg', '{}' );
	-- tag  :    52:#### Tags: select,where 
	insert into ct_tag ( tag_id, tag_word ) values ( 'e05c8fde-1e88-421d-512c-5021f73887c7', 'select' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'e05c8fde-1e88-421d-512c-5021f73887c7', '628cbc2f-7b8e-40b5-6500-ebd7b66b8aa1' );
	insert into ct_tag ( tag_id, tag_word ) values ( '84f3ebbc-cb24-46a0-4ef4-0eacc2fc7aa8', 'where' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '84f3ebbc-cb24-46a0-4ef4-0eacc2fc7aa8', '628cbc2f-7b8e-40b5-6500-ebd7b66b8aa1' );
	-- title:     3:# Interactive - 04 - update the table
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '8c4e026e-390e-482b-4aa9-76a2cb91a853', ' Interactive - 04 - update the table', '4', 'hw04.mp4', 'hw04.jpg', '{}' );
	-- tag  :    38:#### Tags: update,where
	insert into ct_tag ( tag_id, tag_word ) values ( '4a81ad7f-43ae-4a96-7961-880666160b27', 'update' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '4a81ad7f-43ae-4a96-7961-880666160b27', '8c4e026e-390e-482b-4aa9-76a2cb91a853' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '84f3ebbc-cb24-46a0-4ef4-0eacc2fc7aa8', '8c4e026e-390e-482b-4aa9-76a2cb91a853' );
	-- title:     3:# Interactive - 05 - insert more data / select unique data
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'c10176b2-0097-44fa-7719-3d7bf02cd31e', ' Interactive - 05 - insert more data / select unique data', '5', 'hw05.mp4', 'hw05.jpg', '{}' );
	-- tag  :    32:#### Tags: insert,select,distinct,select distinct
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'e4728086-8e1f-4a49-7ae6-9e1b02abed25', 'c10176b2-0097-44fa-7719-3d7bf02cd31e' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'e05c8fde-1e88-421d-512c-5021f73887c7', 'c10176b2-0097-44fa-7719-3d7bf02cd31e' );
	insert into ct_tag ( tag_id, tag_word ) values ( '0feabd7b-4173-4660-741b-f23d793d87cf', 'distinct' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '0feabd7b-4173-4660-741b-f23d793d87cf', 'c10176b2-0097-44fa-7719-3d7bf02cd31e' );
	insert into ct_tag ( tag_id, tag_word ) values ( '61883b72-e959-4f4c-6d7c-48ccfa8897c2', 'select distinct' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '61883b72-e959-4f4c-6d7c-48ccfa8897c2', 'c10176b2-0097-44fa-7719-3d7bf02cd31e' );
	-- title:     3:# Interactive - 06 - count rows of data
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'bbf2249a-9144-4339-7443-d198cec8b4f1', ' Interactive - 06 - count rows of data', '6', 'hw06.mp4', 'hw06.jpg', '{}' );
	-- tag  :    35:#### Tags: count,distinct,"count distinct"
	insert into ct_tag ( tag_id, tag_word ) values ( '9e25bcc8-0fe9-4550-4c34-718628ac36ef', 'count' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '9e25bcc8-0fe9-4550-4c34-718628ac36ef', 'bbf2249a-9144-4339-7443-d198cec8b4f1' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '0feabd7b-4173-4660-741b-f23d793d87cf', 'bbf2249a-9144-4339-7443-d198cec8b4f1' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'ba4565ad-db0c-4c32-6455-e7c20e9d2993', 'count distinct' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'ba4565ad-db0c-4c32-6455-e7c20e9d2993', 'bbf2249a-9144-4339-7443-d198cec8b4f1' );
	-- title:     3:# Interactive - 07 - add a check constraint on age
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '4ef5b837-a1d4-40ef-6bf5-9739a8eb6669', ' Interactive - 07 - add a check constraint on age', '7', 'hw07.mp4', 'hw07.jpg', '{}' );
	-- tag  :    60:#### Tags: "alter table rename","rename","insert","drop table","insert select"
	insert into ct_tag ( tag_id, tag_word ) values ( 'bdac112b-5c99-4a7e-67db-f6488c0f5ef0', 'alter table rename' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'bdac112b-5c99-4a7e-67db-f6488c0f5ef0', '4ef5b837-a1d4-40ef-6bf5-9739a8eb6669' );
	insert into ct_tag ( tag_id, tag_word ) values ( '1484fb4b-e5f0-41a9-426b-1705cbd1d97e', 'rename' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '1484fb4b-e5f0-41a9-426b-1705cbd1d97e', '4ef5b837-a1d4-40ef-6bf5-9739a8eb6669' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'e4728086-8e1f-4a49-7ae6-9e1b02abed25', '4ef5b837-a1d4-40ef-6bf5-9739a8eb6669' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'f565116b-5b85-40fb-6fdb-30c18cd6d158', 'drop table' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'f565116b-5b85-40fb-6fdb-30c18cd6d158', '4ef5b837-a1d4-40ef-6bf5-9739a8eb6669' );
	insert into ct_tag ( tag_id, tag_word ) values ( '53142189-8597-4771-5cf9-6fe319693cf8', 'insert select' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '53142189-8597-4771-5cf9-6fe319693cf8', '4ef5b837-a1d4-40ef-6bf5-9739a8eb6669' );
	-- title:     3:# Interactive - 08 - create unique id and a primary key 
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'd90c2ec2-b8bb-454d-66d5-7108de40cd1b', ' Interactive - 08 - create unique id and a primary key ', '8', 'hw08.mp4', 'hw08.jpg', '{}' );
	-- tag  :   103:#### Tags: "primary key","uuid","unique id","UUID"
	insert into ct_tag ( tag_id, tag_word ) values ( 'e7459c7a-85dd-44bb-5f70-c78b450f4b00', 'primary key' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'e7459c7a-85dd-44bb-5f70-c78b450f4b00', 'd90c2ec2-b8bb-454d-66d5-7108de40cd1b' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'b72e81ee-a023-48d8-4def-70be41fddecb', 'uuid' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'b72e81ee-a023-48d8-4def-70be41fddecb', 'd90c2ec2-b8bb-454d-66d5-7108de40cd1b' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'fd7451a6-aa58-4524-5f0b-df540c90c66a', 'unique id' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'fd7451a6-aa58-4524-5f0b-df540c90c66a', 'd90c2ec2-b8bb-454d-66d5-7108de40cd1b' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'cb2929df-bc64-4c58-716c-7d9697918be0', 'UUID' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'cb2929df-bc64-4c58-716c-7d9697918be0', 'd90c2ec2-b8bb-454d-66d5-7108de40cd1b' );
	-- title:     4:# Interactive - 09 - add a table with state codes
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '8f93808f-3d01-4bb1-648e-4db639f498d6', ' Interactive - 09 - add a table with state codes', '9', 'hw09.mp4', 'hw09.jpg', '{}' );
	-- tag  :    61:#### Tags: "foreign key","alter table","add constraint"
	insert into ct_tag ( tag_id, tag_word ) values ( '3e550ec1-b62b-4c84-426f-279565e01065', 'foreign key' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '3e550ec1-b62b-4c84-426f-279565e01065', '8f93808f-3d01-4bb1-648e-4db639f498d6' );
	insert into ct_tag ( tag_id, tag_word ) values ( '52df57c2-ae1d-4055-7f71-87d75e9aaf02', 'alter table' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '52df57c2-ae1d-4055-7f71-87d75e9aaf02', '8f93808f-3d01-4bb1-648e-4db639f498d6' );
	insert into ct_tag ( tag_id, tag_word ) values ( '704a4f30-d16e-459b-6183-9a7ad87d300e', 'add constraint' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '704a4f30-d16e-459b-6183-9a7ad87d300e', '8f93808f-3d01-4bb1-648e-4db639f498d6' );
	-- title:     4:# Interactive - 10 - add a index on the name table
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '165e7be6-d4cb-4fcd-55e0-245d1e395c47', ' Interactive - 10 - add a index on the name table', '10', 'hw10.mp4', 'hw10.jpg', '{}' );
	-- tag  :    63:#### Tags: "create index"
	insert into ct_tag ( tag_id, tag_word ) values ( 'e90cf289-3942-4b00-6301-39692a00b98e', 'create index' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'e90cf289-3942-4b00-6301-39692a00b98e', '165e7be6-d4cb-4fcd-55e0-245d1e395c47' );
	-- title:     4:# Interactive - 11 - add a index on the name table that is case insensitive.
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'b9fb9fd2-5372-417f-503c-8edddc305e2b', ' Interactive - 11 - add a index on the name table that is case insensitive.', '11', 'hw11.mp4', 'hw11.jpg', '{}' );
	-- tag  :    62:#### Tags: index,"create index","lower"
	insert into ct_tag ( tag_id, tag_word ) values ( '3b07d85a-b742-455c-44a1-aeec77cb9293', 'index' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '3b07d85a-b742-455c-44a1-aeec77cb9293', 'b9fb9fd2-5372-417f-503c-8edddc305e2b' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'e90cf289-3942-4b00-6301-39692a00b98e', 'b9fb9fd2-5372-417f-503c-8edddc305e2b' );
	insert into ct_tag ( tag_id, tag_word ) values ( '17e6fa36-2b99-4376-7d1a-f4d9bb57618a', 'lower' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '17e6fa36-2b99-4376-7d1a-f4d9bb57618a', 'b9fb9fd2-5372-417f-503c-8edddc305e2b' );
	-- title:     4:# Interactive - 12 - fix our duplicate data
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '59828348-26a1-40ab-5206-cf7ac7757b8f', ' Interactive - 12 - fix our duplicate data', '12', 'hw12.mp4', 'hw12.jpg', '{}' );
	-- tag  :    46:#### Tags: "duplicate data","delete","type cast","min","not in"
	insert into ct_tag ( tag_id, tag_word ) values ( 'edff4190-8d32-4b10-724f-07273cd86883', 'duplicate data' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'edff4190-8d32-4b10-724f-07273cd86883', '59828348-26a1-40ab-5206-cf7ac7757b8f' );
	insert into ct_tag ( tag_id, tag_word ) values ( '42bd3bf2-0505-4f41-454f-947146f1da7d', 'delete' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '42bd3bf2-0505-4f41-454f-947146f1da7d', '59828348-26a1-40ab-5206-cf7ac7757b8f' );
	insert into ct_tag ( tag_id, tag_word ) values ( '566af6cc-a9c6-4d91-6e1b-241f98cde317', 'type cast' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '566af6cc-a9c6-4d91-6e1b-241f98cde317', '59828348-26a1-40ab-5206-cf7ac7757b8f' );
	insert into ct_tag ( tag_id, tag_word ) values ( '3849284d-af3a-4b80-69ae-0f79302c1b08', 'min' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '3849284d-af3a-4b80-69ae-0f79302c1b08', '59828348-26a1-40ab-5206-cf7ac7757b8f' );
	insert into ct_tag ( tag_id, tag_word ) values ( '89e7538e-e189-4ba0-751f-d8b5418b2e3c', 'not in' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '89e7538e-e189-4ba0-751f-d8b5418b2e3c', '59828348-26a1-40ab-5206-cf7ac7757b8f' );
	-- title:     4:# Interactive - 13 - drop both tables
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '7bb89574-b78c-4bf7-59e2-7f93f3ca109a', ' Interactive - 13 - drop both tables', '13', 'hw13.mp4', 'hw13.jpg', '{}' );
	-- tag  :    41:#### Tags: "reload data","drop cascade"
	insert into ct_tag ( tag_id, tag_word ) values ( 'bf4fa5aa-c083-4d2b-72cb-0b4cf54d60fc', 'reload data' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'bf4fa5aa-c083-4d2b-72cb-0b4cf54d60fc', '7bb89574-b78c-4bf7-59e2-7f93f3ca109a' );
	insert into ct_tag ( tag_id, tag_word ) values ( '73a9ae1b-b780-4da1-6d1c-cd13b94fbac8', 'drop cascade' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '73a9ae1b-b780-4da1-6d1c-cd13b94fbac8', '7bb89574-b78c-4bf7-59e2-7f93f3ca109a' );
	-- title:     4:# Interactive - 14 - data types
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '1fe5270c-5ed6-47a2-7f8c-90f5744ac426', ' Interactive - 14 - data types', '14', 'hw14.mp4', 'hw14.jpg', '{}' );
	-- tag  :    82:#### Tags: "data types"
	insert into ct_tag ( tag_id, tag_word ) values ( '409be2ec-7b89-4311-534a-c14b59c7d106', 'data types' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '409be2ec-7b89-4311-534a-c14b59c7d106', '1fe5270c-5ed6-47a2-7f8c-90f5744ac426' );
	-- title:     4:# Interactive - 15 - select with group data of data
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'e8f073f6-9527-4212-4184-ec19f49912d1', ' Interactive - 15 - select with group data of data', '15', 'hw15.mp4', 'hw15.jpg', '{}' );
	-- tag  :    52:#### Tags: "min","max","avg","group by","order by","nested query","sub query"
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '3849284d-af3a-4b80-69ae-0f79302c1b08', 'e8f073f6-9527-4212-4184-ec19f49912d1' );
	insert into ct_tag ( tag_id, tag_word ) values ( '4e12627c-7f67-430a-7889-abea52e96c3b', 'max' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '4e12627c-7f67-430a-7889-abea52e96c3b', 'e8f073f6-9527-4212-4184-ec19f49912d1' );
	insert into ct_tag ( tag_id, tag_word ) values ( '5fea0da6-5aa7-4bc2-628c-347311550e77', 'avg' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '5fea0da6-5aa7-4bc2-628c-347311550e77', 'e8f073f6-9527-4212-4184-ec19f49912d1' );
	insert into ct_tag ( tag_id, tag_word ) values ( '20d0537b-c236-479c-4097-11e1f568d425', 'group by' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '20d0537b-c236-479c-4097-11e1f568d425', 'e8f073f6-9527-4212-4184-ec19f49912d1' );
	insert into ct_tag ( tag_id, tag_word ) values ( '01311a97-a842-43ac-4c18-c8c4121f84ee', 'order by' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '01311a97-a842-43ac-4c18-c8c4121f84ee', 'e8f073f6-9527-4212-4184-ec19f49912d1' );
	insert into ct_tag ( tag_id, tag_word ) values ( '79ef5a22-8113-4cde-5fc5-e18f09786e58', 'nested query' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '79ef5a22-8113-4cde-5fc5-e18f09786e58', 'e8f073f6-9527-4212-4184-ec19f49912d1' );
	insert into ct_tag ( tag_id, tag_word ) values ( '2899d672-32a0-44d8-796b-3959a7ad1b01', 'sub query' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '2899d672-32a0-44d8-796b-3959a7ad1b01', 'e8f073f6-9527-4212-4184-ec19f49912d1' );
	-- title:     4:# Interactive - 16 - count matching rows in a select
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '0cf270d9-7178-4b40-5cb5-aea637c3ee77', ' Interactive - 16 - count matching rows in a select', '16', 'hw16.mp4', 'hw16.jpg', '{}' );
	-- tag  :    35:#### Tags: "group by","avg","order by"
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '20d0537b-c236-479c-4097-11e1f568d425', '0cf270d9-7178-4b40-5cb5-aea637c3ee77' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '5fea0da6-5aa7-4bc2-628c-347311550e77', '0cf270d9-7178-4b40-5cb5-aea637c3ee77' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '01311a97-a842-43ac-4c18-c8c4121f84ee', '0cf270d9-7178-4b40-5cb5-aea637c3ee77' );
	-- title:     4:# Interactive - 17 - select with join ( inner join, left outer join )
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'ffbdfe1b-07a5-4d1a-6454-0db7380502e4', ' Interactive - 17 - select with join ( inner join, left outer join )', '17', 'hw17.mp4', 'hw17.jpg', '{}' );
	-- tag  :   131:#### Tags: "inner join","outer join","left outer join"
	insert into ct_tag ( tag_id, tag_word ) values ( '113f529c-1ec5-4d0f-6e2b-036c07225610', 'inner join' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '113f529c-1ec5-4d0f-6e2b-036c07225610', 'ffbdfe1b-07a5-4d1a-6454-0db7380502e4' );
	insert into ct_tag ( tag_id, tag_word ) values ( '3e5aff80-4433-418d-5220-93342152abb5', 'outer join' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '3e5aff80-4433-418d-5220-93342152abb5', 'ffbdfe1b-07a5-4d1a-6454-0db7380502e4' );
	insert into ct_tag ( tag_id, tag_word ) values ( '5bbf1e57-5792-4461-47f3-2eae0b41d092', 'left outer join' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '5bbf1e57-5792-4461-47f3-2eae0b41d092', 'ffbdfe1b-07a5-4d1a-6454-0db7380502e4' );
	-- title:     4:# Interactive - 18 - More joins (full joins)
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'bbd05754-a1b8-4ef6-5a2a-a2bc095a9e2d', ' Interactive - 18 - More joins (full joins)', '18', 'hw18.mp4', 'hw18.jpg', '{}' );
	-- tag  :    61:#### Tags: "full join","full outer join"
	insert into ct_tag ( tag_id, tag_word ) values ( '5a1ba84a-ceed-46e2-4dd3-efa2ec331f17', 'full join' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '5a1ba84a-ceed-46e2-4dd3-efa2ec331f17', 'bbd05754-a1b8-4ef6-5a2a-a2bc095a9e2d' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'b2079d51-f0fc-47af-7d09-a58017226f88', 'full outer join' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'b2079d51-f0fc-47af-7d09-a58017226f88', 'bbd05754-a1b8-4ef6-5a2a-a2bc095a9e2d' );
	-- title:     4:# Interactive - 19 - select using sub-query and exists
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'd00be092-62b2-4380-5ac0-f1a2cdf41192', ' Interactive - 19 - select using sub-query and exists', '19', 'hw19.mp4', 'hw19.jpg', '{}' );
	-- tag  :    18:#### Tags: "select exists","sub-query"
	insert into ct_tag ( tag_id, tag_word ) values ( 'd133659f-0353-4c2f-7af1-7df3b82275f1', 'select exists' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'd133659f-0353-4c2f-7af1-7df3b82275f1', 'd00be092-62b2-4380-5ac0-f1a2cdf41192' );
	insert into ct_tag ( tag_id, tag_word ) values ( '8834db52-dd5e-4ce4-419e-795431afe4ef', 'sub-query' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '8834db52-dd5e-4ce4-419e-795431afe4ef', 'd00be092-62b2-4380-5ac0-f1a2cdf41192' );
	-- title:     4:# Interactive - 20 - delete with in based sub-query
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '046daaec-dda6-4cc4-5cbd-365655e8b599', ' Interactive - 20 - delete with in based sub-query', '20', 'hw20.mp4', 'hw20.jpg', '{}' );
	-- tag  :    28:#### Tags: "delete exists","sub-query"
	insert into ct_tag ( tag_id, tag_word ) values ( '96b0a26e-b799-451b-723f-a85598174cc2', 'delete exists' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '96b0a26e-b799-451b-723f-a85598174cc2', '046daaec-dda6-4cc4-5cbd-365655e8b599' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '8834db52-dd5e-4ce4-419e-795431afe4ef', '046daaec-dda6-4cc4-5cbd-365655e8b599' );
	-- title:     4:# Interactive - 21 - select with union / minus
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'e287ad7d-f3f8-4af5-4c0d-664851ebb403', ' Interactive - 21 - select with union / minus', '21', 'hw21.mp4', 'hw21.jpg', '{}' );
	-- tag  :    23:#### Tags: "union"
	insert into ct_tag ( tag_id, tag_word ) values ( '4443692f-7253-47d1-5483-e94fcda6a387', 'union' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '4443692f-7253-47d1-5483-e94fcda6a387', 'e287ad7d-f3f8-4af5-4c0d-664851ebb403' );
	-- title:     4:# Interactive - 22 - recursive select - populating existing tables 
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'ea0e187f-8b93-45ff-6480-ee5fcffe6132', ' Interactive - 22 - recursive select - populating existing tables ', '22', 'hw22.mp4', 'hw22.jpg', '{}' );
	-- tag  :    21:#### Tags: "recursive select",recursive
	insert into ct_tag ( tag_id, tag_word ) values ( '9c32cb02-0cfc-46d0-7d54-97e14c79b150', 'recursive select' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '9c32cb02-0cfc-46d0-7d54-97e14c79b150', 'ea0e187f-8b93-45ff-6480-ee5fcffe6132' );
	insert into ct_tag ( tag_id, tag_word ) values ( '7792e0a3-e4d9-4adb-7a6f-524a056e1ee3', 'recursive' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '7792e0a3-e4d9-4adb-7a6f-524a056e1ee3', 'ea0e187f-8b93-45ff-6480-ee5fcffe6132' );
	-- title:     4:# Interactive - 23 - with - pre-selects to do stuff.
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'fd454f56-c190-4371-760e-e77b7618d45b', ' Interactive - 23 - with - pre-selects to do stuff.', '23', 'hw23.mp4', 'hw23.jpg', '{}' );
	-- tag  :    31:#### Tags: "with","with select"
	insert into ct_tag ( tag_id, tag_word ) values ( 'f5e8b10c-34e1-41de-4fd3-5c924ae32672', 'with' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'f5e8b10c-34e1-41de-4fd3-5c924ae32672', 'fd454f56-c190-4371-760e-e77b7618d45b' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'b150488a-c9d3-4efb-4d53-a8812420e1b8', 'with select' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'b150488a-c9d3-4efb-4d53-a8812420e1b8', 'fd454f56-c190-4371-760e-e77b7618d45b' );
	-- title:     4:# Interactive - 24 - truncate table
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'a708cdb9-ec27-4aaa-439c-df89e44f9c0c', ' Interactive - 24 - truncate table', '24', 'hw24.mp4', 'hw24.jpg', '{}' );
	-- tag  :    23:#### Tags: "truncate","fast delete","delete all rows"
	insert into ct_tag ( tag_id, tag_word ) values ( '3b8598d5-77be-452a-792b-fcf14ea45bf9', 'truncate' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '3b8598d5-77be-452a-792b-fcf14ea45bf9', 'a708cdb9-ec27-4aaa-439c-df89e44f9c0c' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'fdf6b761-2ec4-4ebf-69d9-388526d8813f', 'fast delete' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'fdf6b761-2ec4-4ebf-69d9-388526d8813f', 'a708cdb9-ec27-4aaa-439c-df89e44f9c0c' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'b5d89e20-d40a-4fd5-605f-fbcee6ba30fc', 'delete all rows' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'b5d89e20-d40a-4fd5-605f-fbcee6ba30fc', 'a708cdb9-ec27-4aaa-439c-df89e44f9c0c' );
	-- title:     4:# Interactive - 25 - drop cascade 
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'c38305b6-b327-404b-4558-a14a064a0330', ' Interactive - 25 - drop cascade ', '25', 'hw25.mp4', 'hw25.jpg', '{}' );
	-- tag  :    42:#### Tags: "drop","drop cascade"
	insert into ct_tag ( tag_id, tag_word ) values ( '77682e15-04d6-4660-77b6-14ccdaaeab70', 'drop' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '77682e15-04d6-4660-77b6-14ccdaaeab70', 'c38305b6-b327-404b-4558-a14a064a0330' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '73a9ae1b-b780-4da1-6d1c-cd13b94fbac8', 'c38305b6-b327-404b-4558-a14a064a0330' );
	-- title:     4:# Interactive - 26 - 1 to 1 relationship  				(pk to pk)
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'e156ef11-10f4-4ab3-5ea4-ee92d3ba451d', ' Interactive - 26 - 1 to 1 relationship  				(pk to pk)', '26', 'hw26.mp4', 'hw26.jpg', '{}' );
	-- tag  :   101:#### Tags: "setup","ct_homework","ct_homework_ans","ct_tag","ct_tag_homework","t_ymux_user","t_ymux_user_log","t_ymux_auth_token"
	insert into ct_tag ( tag_id, tag_word ) values ( 'ac1f8dd9-341b-4dad-5523-14e850d81e4c', 'setup' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'ac1f8dd9-341b-4dad-5523-14e850d81e4c', 'e156ef11-10f4-4ab3-5ea4-ee92d3ba451d' );
	insert into ct_tag ( tag_id, tag_word ) values ( '60fe314a-1c0b-45cd-7c7c-cd1b3facf159', 'ct_homework' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '60fe314a-1c0b-45cd-7c7c-cd1b3facf159', 'e156ef11-10f4-4ab3-5ea4-ee92d3ba451d' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'be227852-fb48-4cbb-7e27-0b02e75b366c', 'ct_homework_ans' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'be227852-fb48-4cbb-7e27-0b02e75b366c', 'e156ef11-10f4-4ab3-5ea4-ee92d3ba451d' );
	insert into ct_tag ( tag_id, tag_word ) values ( '0e62dc16-a8f2-49ef-4949-af1bc116db81', 'ct_tag' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '0e62dc16-a8f2-49ef-4949-af1bc116db81', 'e156ef11-10f4-4ab3-5ea4-ee92d3ba451d' );
	insert into ct_tag ( tag_id, tag_word ) values ( '92df184c-e202-4915-65a3-a77ba046582d', 'ct_tag_homework' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '92df184c-e202-4915-65a3-a77ba046582d', 'e156ef11-10f4-4ab3-5ea4-ee92d3ba451d' );
	insert into ct_tag ( tag_id, tag_word ) values ( '4b09eace-5c2f-4bde-6769-c4b672013058', 't_ymux_user' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '4b09eace-5c2f-4bde-6769-c4b672013058', 'e156ef11-10f4-4ab3-5ea4-ee92d3ba451d' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'f6a61358-5096-42ad-4e5e-287a0b014e83', 't_ymux_user_log' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'f6a61358-5096-42ad-4e5e-287a0b014e83', 'e156ef11-10f4-4ab3-5ea4-ee92d3ba451d' );
	insert into ct_tag ( tag_id, tag_word ) values ( '2f25b1d7-4c69-4c3e-4850-96f573abee4b', 't_ymux_auth_token' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '2f25b1d7-4c69-4c3e-4850-96f573abee4b', 'e156ef11-10f4-4ab3-5ea4-ee92d3ba451d' );
	-- title:     4:# Interactive - 27 - 1 to 0 or 1 relationship 			(fk, unique)
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '06cb8463-cff4-4a89-6f1c-1514f93bda88', ' Interactive - 27 - 1 to 0 or 1 relationship 			(fk, unique)', '27', 'hw27.mp4', 'hw27.jpg', '{}' );
	-- tag  :    21:#### Tags: "1 to 0","1:0","1:0 relationship","1:1"
	insert into ct_tag ( tag_id, tag_word ) values ( '13df3546-aa07-48d3-4d37-66557be3176c', '1 to 0' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '13df3546-aa07-48d3-4d37-66557be3176c', '06cb8463-cff4-4a89-6f1c-1514f93bda88' );
	insert into ct_tag ( tag_id, tag_word ) values ( '9d7b912a-10a6-44a9-5723-1cef6022f5f7', '1:0' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '9d7b912a-10a6-44a9-5723-1cef6022f5f7', '06cb8463-cff4-4a89-6f1c-1514f93bda88' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'deeb717e-22fc-4343-6709-bd9ea180e8ad', '1:0 relationship' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'deeb717e-22fc-4343-6709-bd9ea180e8ad', '06cb8463-cff4-4a89-6f1c-1514f93bda88' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'f76db0e1-8b30-448d-6af9-cc485f19ce87', '1:1' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'f76db0e1-8b30-448d-6af9-cc485f19ce87', '06cb8463-cff4-4a89-6f1c-1514f93bda88' );
	-- title:     5:# Interactive - 28 - 1 to n relationship				(fk)
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '87f5f17d-f358-41c2-61f7-5f5fa066d422', ' Interactive - 28 - 1 to n relationship				(fk)', '28', 'hw28.mp4', 'hw28.jpg', '{}' );
	-- tag  :    23:#### Tags: "1:n","1:n relationship"
	insert into ct_tag ( tag_id, tag_word ) values ( '2c6f0ae8-4302-410f-4761-bd1885fb489b', '1:n' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '2c6f0ae8-4302-410f-4761-bd1885fb489b', '87f5f17d-f358-41c2-61f7-5f5fa066d422' );
	insert into ct_tag ( tag_id, tag_word ) values ( '84924d24-3a27-4846-65e6-0b58ff6f2bc9', '1:n relationship' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '84924d24-3a27-4846-65e6-0b58ff6f2bc9', '87f5f17d-f358-41c2-61f7-5f5fa066d422' );
	-- title:     4:# Interactive - 29 - m to n relationship				(fk to join table to fk)
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '7b25f3b4-3f50-4c72-4f2f-09aff73f2c7c', ' Interactive - 29 - m to n relationship				(fk to join table to fk)', '29', 'hw29.mp4', 'hw29.jpg', '{}' );
	-- tag  :   109:#### Tags: "m to n","m:n","m:n relationship"
	insert into ct_tag ( tag_id, tag_word ) values ( 'f2e8ae2e-c602-4454-5010-bfbf52f4d577', 'm to n' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'f2e8ae2e-c602-4454-5010-bfbf52f4d577', '7b25f3b4-3f50-4c72-4f2f-09aff73f2c7c' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'f883026e-62bf-4173-66ec-336d3a898d40', 'm:n' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'f883026e-62bf-4173-66ec-336d3a898d40', '7b25f3b4-3f50-4c72-4f2f-09aff73f2c7c' );
	insert into ct_tag ( tag_id, tag_word ) values ( '281778fc-e8d2-4533-5eb9-fd3cde13eb34', 'm:n relationship' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '281778fc-e8d2-4533-5eb9-fd3cde13eb34', '7b25f3b4-3f50-4c72-4f2f-09aff73f2c7c' );




	RETURN 'PASS';
END;
$$;



CREATE OR REPLACE FUNCTION validate_hw01() RETURNS text
LANGUAGE plpgsql
AS $$
DECLARE
	l_junk text;
BEGIN
	l_junk = 'PASS';
	RETURN l_junk;
END;
$$;

