
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
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'b4cad7dd-8db2-46bf-58d6-6549d0a26a58', ' Interactive - 01 - Create Table', '01', 'hw01.mp4', 'hw01.jpg', '{}' );
	-- tag  :    43:#### Tags: "create table","type text","type int","type varchar","hw01"
	insert into ct_tag ( tag_id, tag_word ) values ( 'a439239c-5579-4df3-7c76-b0176a6897cf', 'create table' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'a439239c-5579-4df3-7c76-b0176a6897cf', 'b4cad7dd-8db2-46bf-58d6-6549d0a26a58' );
	insert into ct_tag ( tag_id, tag_word ) values ( '32fc0c4e-2f84-4a45-4fb9-3714752ed2ba', 'type text' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '32fc0c4e-2f84-4a45-4fb9-3714752ed2ba', 'b4cad7dd-8db2-46bf-58d6-6549d0a26a58' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'ece35a50-2b0d-470f-4884-54ccb42abef9', 'type int' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'ece35a50-2b0d-470f-4884-54ccb42abef9', 'b4cad7dd-8db2-46bf-58d6-6549d0a26a58' );
	insert into ct_tag ( tag_id, tag_word ) values ( '21afa68b-c5a5-45c2-4565-a56ac78ec9f6', 'type varchar' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '21afa68b-c5a5-45c2-4565-a56ac78ec9f6', 'b4cad7dd-8db2-46bf-58d6-6549d0a26a58' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'd93831ed-3c66-424a-4bb1-61fa6c8edf64', 'hw01' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'd93831ed-3c66-424a-4bb1-61fa6c8edf64', 'b4cad7dd-8db2-46bf-58d6-6549d0a26a58' );
	-- title:     3:# Interactive - 02 - Insert data into "name_list"
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'b8212786-fdd8-40b5-74fb-217fd8f0d973', ' Interactive - 02 - Insert data into "name_list"', '02', 'hw02.mp4', 'hw02.jpg', '{}' );
	-- tag  :    60:#### Tags: "hw02","insert"    	
	insert into ct_tag ( tag_id, tag_word ) values ( '4a0a43e2-3274-47e4-79f5-b4174c894727', 'hw02' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '4a0a43e2-3274-47e4-79f5-b4174c894727', 'b8212786-fdd8-40b5-74fb-217fd8f0d973' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'b75adab0-e4b5-4dfd-5c9c-c2f1aa4fe1c5', 'insert' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'b75adab0-e4b5-4dfd-5c9c-c2f1aa4fe1c5', 'b8212786-fdd8-40b5-74fb-217fd8f0d973' );
	-- title:     3:# Interactive - 03 - Select data back from the table
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'd45ceeb5-4e3e-4b85-63c9-e9812eff8890', ' Interactive - 03 - Select data back from the table', '03', 'hw03.mp4', 'hw03.jpg', '{}' );
	-- tag  :    52:#### Tags: select,where 
	insert into ct_tag ( tag_id, tag_word ) values ( '372b3af3-3efd-4a59-5592-1f6f5db23b4c', 'select' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '372b3af3-3efd-4a59-5592-1f6f5db23b4c', 'd45ceeb5-4e3e-4b85-63c9-e9812eff8890' );
	insert into ct_tag ( tag_id, tag_word ) values ( '62bbab6b-edf2-4c44-6b06-ae1198d9b2a4', 'where' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '62bbab6b-edf2-4c44-6b06-ae1198d9b2a4', 'd45ceeb5-4e3e-4b85-63c9-e9812eff8890' );
	-- title:     3:# Interactive - 04 - update the table
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'f5f62787-6932-4717-59d0-2783460076b4', ' Interactive - 04 - update the table', '04', 'hw04.mp4', 'hw04.jpg', '{}' );
	-- tag  :    38:#### Tags: update,where
	insert into ct_tag ( tag_id, tag_word ) values ( '4049fdeb-4446-4f70-6bf3-cf91fa30a522', 'update' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '4049fdeb-4446-4f70-6bf3-cf91fa30a522', 'f5f62787-6932-4717-59d0-2783460076b4' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '62bbab6b-edf2-4c44-6b06-ae1198d9b2a4', 'f5f62787-6932-4717-59d0-2783460076b4' );
	-- title:     3:# Interactive - 05 - insert more data / select unique data
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'f88dc4f8-3b30-4813-7c6a-aada4feaf8d6', ' Interactive - 05 - insert more data / select unique data', '05', 'hw05.mp4', 'hw05.jpg', '{}' );
	-- tag  :    32:#### Tags: insert,select,distinct,select distinct
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'b75adab0-e4b5-4dfd-5c9c-c2f1aa4fe1c5', 'f88dc4f8-3b30-4813-7c6a-aada4feaf8d6' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '372b3af3-3efd-4a59-5592-1f6f5db23b4c', 'f88dc4f8-3b30-4813-7c6a-aada4feaf8d6' );
	insert into ct_tag ( tag_id, tag_word ) values ( '05cd4e1d-4600-40d0-7164-ed92b15cd90d', 'distinct' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '05cd4e1d-4600-40d0-7164-ed92b15cd90d', 'f88dc4f8-3b30-4813-7c6a-aada4feaf8d6' );
	insert into ct_tag ( tag_id, tag_word ) values ( '4d7be2ff-30bb-4388-4b16-6c3a5c22f6f1', 'select distinct' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '4d7be2ff-30bb-4388-4b16-6c3a5c22f6f1', 'f88dc4f8-3b30-4813-7c6a-aada4feaf8d6' );
	-- title:     3:# Interactive - 06 - count rows of data
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '8660d734-2a57-4888-7059-28ac815a82b2', ' Interactive - 06 - count rows of data', '06', 'hw06.mp4', 'hw06.jpg', '{}' );
	-- tag  :    35:#### Tags: count,distinct,"count distinct"
	insert into ct_tag ( tag_id, tag_word ) values ( 'e835bd6f-79c5-403b-6714-7ea74d3cecbb', 'count' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'e835bd6f-79c5-403b-6714-7ea74d3cecbb', '8660d734-2a57-4888-7059-28ac815a82b2' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '05cd4e1d-4600-40d0-7164-ed92b15cd90d', '8660d734-2a57-4888-7059-28ac815a82b2' );
	insert into ct_tag ( tag_id, tag_word ) values ( '693796e8-b87c-4558-4590-27dad7c0ec31', 'count distinct' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '693796e8-b87c-4558-4590-27dad7c0ec31', '8660d734-2a57-4888-7059-28ac815a82b2' );
	-- title:     3:# Interactive - 07 - add a check constraint on age
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'f70c637a-df2a-4e87-6ad8-31927d36fed6', ' Interactive - 07 - add a check constraint on age', '07', 'hw07.mp4', 'hw07.jpg', '{}' );
	-- tag  :    60:#### Tags: "alter table rename","rename","insert","drop table","insert select"
	insert into ct_tag ( tag_id, tag_word ) values ( 'd5b37e3b-1fbe-4346-4e55-8b52262aaee7', 'alter table rename' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'd5b37e3b-1fbe-4346-4e55-8b52262aaee7', 'f70c637a-df2a-4e87-6ad8-31927d36fed6' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'ab618312-1100-4b41-67fc-88f0fe94ab28', 'rename' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'ab618312-1100-4b41-67fc-88f0fe94ab28', 'f70c637a-df2a-4e87-6ad8-31927d36fed6' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'b75adab0-e4b5-4dfd-5c9c-c2f1aa4fe1c5', 'f70c637a-df2a-4e87-6ad8-31927d36fed6' );
	insert into ct_tag ( tag_id, tag_word ) values ( '7befc9c8-715d-49e3-543f-2033e687f820', 'drop table' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '7befc9c8-715d-49e3-543f-2033e687f820', 'f70c637a-df2a-4e87-6ad8-31927d36fed6' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'c151f6cf-d694-4805-4574-04ae8b395ee1', 'insert select' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'c151f6cf-d694-4805-4574-04ae8b395ee1', 'f70c637a-df2a-4e87-6ad8-31927d36fed6' );
	-- title:     3:# Interactive - 08 - create unique id and a primary key 
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'ec550aa6-0d14-4f49-4e43-b14905d06d39', ' Interactive - 08 - create unique id and a primary key ', '08', 'hw08.mp4', 'hw08.jpg', '{}' );
	-- tag  :   103:#### Tags: "primary key","uuid","unique id","UUID"
	insert into ct_tag ( tag_id, tag_word ) values ( '663615bf-ef81-432d-6757-0a208a31e297', 'primary key' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '663615bf-ef81-432d-6757-0a208a31e297', 'ec550aa6-0d14-4f49-4e43-b14905d06d39' );
	insert into ct_tag ( tag_id, tag_word ) values ( '415ce134-8769-49ac-6c61-e5f7f0d2c539', 'uuid' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '415ce134-8769-49ac-6c61-e5f7f0d2c539', 'ec550aa6-0d14-4f49-4e43-b14905d06d39' );
	insert into ct_tag ( tag_id, tag_word ) values ( '6350d08c-bd4e-401e-4fb4-e7c14d561108', 'unique id' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '6350d08c-bd4e-401e-4fb4-e7c14d561108', 'ec550aa6-0d14-4f49-4e43-b14905d06d39' );
	insert into ct_tag ( tag_id, tag_word ) values ( '3729bc77-965d-4e11-630c-0f5dc966e5ae', 'UUID' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '3729bc77-965d-4e11-630c-0f5dc966e5ae', 'ec550aa6-0d14-4f49-4e43-b14905d06d39' );
	-- title:     4:# Interactive - 09 - add a table with state codes
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'e57ab0dd-8c03-4ca3-437e-4f86940bca3a', ' Interactive - 09 - add a table with state codes', '09', 'hw09.mp4', 'hw09.jpg', '{}' );
	-- tag  :    61:#### Tags: "foreign key","alter table","add constraint"
	insert into ct_tag ( tag_id, tag_word ) values ( '22dc266f-3473-464f-6874-e8a4da038ebb', 'foreign key' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '22dc266f-3473-464f-6874-e8a4da038ebb', 'e57ab0dd-8c03-4ca3-437e-4f86940bca3a' );
	insert into ct_tag ( tag_id, tag_word ) values ( '949c884b-5311-49a7-4b98-ccce7b147e50', 'alter table' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '949c884b-5311-49a7-4b98-ccce7b147e50', 'e57ab0dd-8c03-4ca3-437e-4f86940bca3a' );
	insert into ct_tag ( tag_id, tag_word ) values ( '01be3801-7432-4539-40ff-f4588e3aebab', 'add constraint' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '01be3801-7432-4539-40ff-f4588e3aebab', 'e57ab0dd-8c03-4ca3-437e-4f86940bca3a' );
	-- title:     4:# Interactive - 10 - add a index on the name table
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '993d9b0c-5b23-442c-4cb7-12f01b83f32f', ' Interactive - 10 - add a index on the name table', '10', 'hw10.mp4', 'hw10.jpg', '{}' );
	-- tag  :    63:#### Tags: "create index"
	insert into ct_tag ( tag_id, tag_word ) values ( 'fee655c8-e5ab-488b-403d-9e362fe328de', 'create index' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'fee655c8-e5ab-488b-403d-9e362fe328de', '993d9b0c-5b23-442c-4cb7-12f01b83f32f' );
	-- title:     4:# Interactive - 11 - add a index on the name table that is case insensitive.
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '33e803c5-9a0a-44f6-7666-ba9a3033cc64', ' Interactive - 11 - add a index on the name table that is case insensitive.', '11', 'hw11.mp4', 'hw11.jpg', '{}' );
	-- tag  :    62:#### Tags: index,"create index","lower"
	insert into ct_tag ( tag_id, tag_word ) values ( 'e37a23e6-37e5-493a-58af-ce8bf8f96e91', 'index' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'e37a23e6-37e5-493a-58af-ce8bf8f96e91', '33e803c5-9a0a-44f6-7666-ba9a3033cc64' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'fee655c8-e5ab-488b-403d-9e362fe328de', '33e803c5-9a0a-44f6-7666-ba9a3033cc64' );
	insert into ct_tag ( tag_id, tag_word ) values ( '161ab39f-25bc-4d43-68cd-42ba3f6b4b50', 'lower' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '161ab39f-25bc-4d43-68cd-42ba3f6b4b50', '33e803c5-9a0a-44f6-7666-ba9a3033cc64' );
	-- title:     4:# Interactive - 12 - fix our duplicate data
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'c5b0173d-175a-4091-5145-41283062652a', ' Interactive - 12 - fix our duplicate data', '12', 'hw12.mp4', 'hw12.jpg', '{}' );
	-- tag  :    46:#### Tags: "duplicate data","delete","type cast","min","not in"
	insert into ct_tag ( tag_id, tag_word ) values ( 'a52eb34d-57c0-43fe-4bfb-db3190ad454b', 'duplicate data' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'a52eb34d-57c0-43fe-4bfb-db3190ad454b', 'c5b0173d-175a-4091-5145-41283062652a' );
	insert into ct_tag ( tag_id, tag_word ) values ( '951ad3b7-4bfc-4ab5-717c-9efd15f6fd1e', 'delete' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '951ad3b7-4bfc-4ab5-717c-9efd15f6fd1e', 'c5b0173d-175a-4091-5145-41283062652a' );
	insert into ct_tag ( tag_id, tag_word ) values ( '5ea3c09b-72b6-41cf-78df-dfecac741ce8', 'type cast' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '5ea3c09b-72b6-41cf-78df-dfecac741ce8', 'c5b0173d-175a-4091-5145-41283062652a' );
	insert into ct_tag ( tag_id, tag_word ) values ( '4c3f8a59-b955-4655-53d4-e594f1c625a3', 'min' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '4c3f8a59-b955-4655-53d4-e594f1c625a3', 'c5b0173d-175a-4091-5145-41283062652a' );
	insert into ct_tag ( tag_id, tag_word ) values ( '0a618081-e05c-4402-64f0-a3211d5e3a3a', 'not in' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '0a618081-e05c-4402-64f0-a3211d5e3a3a', 'c5b0173d-175a-4091-5145-41283062652a' );
	-- title:     4:# Interactive - 13 - drop both tables
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'c21efd33-0487-4a6b-529e-96ce98621cdd', ' Interactive - 13 - drop both tables', '13', 'hw13.mp4', 'hw13.jpg', '{}' );
	-- tag  :    41:#### Tags: "reload data","drop cascade"
	insert into ct_tag ( tag_id, tag_word ) values ( 'a86023c1-098c-4e4f-7f77-d8b9aae8424c', 'reload data' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'a86023c1-098c-4e4f-7f77-d8b9aae8424c', 'c21efd33-0487-4a6b-529e-96ce98621cdd' );
	insert into ct_tag ( tag_id, tag_word ) values ( '41a77383-fc6e-477c-5434-db1ff697bf11', 'drop cascade' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '41a77383-fc6e-477c-5434-db1ff697bf11', 'c21efd33-0487-4a6b-529e-96ce98621cdd' );
	-- title:     4:# Interactive - 14 - data types
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'ad426a14-cf3f-446c-583a-b39f64b259ca', ' Interactive - 14 - data types', '14', 'hw14.mp4', 'hw14.jpg', '{}' );
	-- tag  :    82:#### Tags: "data types"
	insert into ct_tag ( tag_id, tag_word ) values ( 'fe0cd1b3-2b7b-4ab2-556c-cf18492f596c', 'data types' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'fe0cd1b3-2b7b-4ab2-556c-cf18492f596c', 'ad426a14-cf3f-446c-583a-b39f64b259ca' );
	-- title:     4:# Interactive - 15 - select with group data of data
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '75f7929e-e4b9-467c-4da0-8ac044907832', ' Interactive - 15 - select with group data of data', '15', 'hw15.mp4', 'hw15.jpg', '{}' );
	-- tag  :    52:#### Tags: "min","max","avg","group by","order by","nested query","sub query"
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '4c3f8a59-b955-4655-53d4-e594f1c625a3', '75f7929e-e4b9-467c-4da0-8ac044907832' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'c7e2acdf-6c4a-4887-716d-50591f01c3e5', 'max' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'c7e2acdf-6c4a-4887-716d-50591f01c3e5', '75f7929e-e4b9-467c-4da0-8ac044907832' );
	insert into ct_tag ( tag_id, tag_word ) values ( '58eec5ac-cd64-4448-4464-36e719561a90', 'avg' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '58eec5ac-cd64-4448-4464-36e719561a90', '75f7929e-e4b9-467c-4da0-8ac044907832' );
	insert into ct_tag ( tag_id, tag_word ) values ( '95ce1a9d-d62f-4cc0-629d-97a10e3df433', 'group by' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '95ce1a9d-d62f-4cc0-629d-97a10e3df433', '75f7929e-e4b9-467c-4da0-8ac044907832' );
	insert into ct_tag ( tag_id, tag_word ) values ( '5ebdcda7-5087-49ec-717c-46c2945d1ecf', 'order by' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '5ebdcda7-5087-49ec-717c-46c2945d1ecf', '75f7929e-e4b9-467c-4da0-8ac044907832' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'b7963841-c671-4759-5eff-6cddcca38409', 'nested query' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'b7963841-c671-4759-5eff-6cddcca38409', '75f7929e-e4b9-467c-4da0-8ac044907832' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'c4490eb6-a730-477c-6259-c315d332ff63', 'sub query' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'c4490eb6-a730-477c-6259-c315d332ff63', '75f7929e-e4b9-467c-4da0-8ac044907832' );
	-- title:     4:# Interactive - 16 - count matching rows in a select
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '6e32b7a1-ea8c-4526-7157-5f35bb03ffae', ' Interactive - 16 - count matching rows in a select', '16', 'hw16.mp4', 'hw16.jpg', '{}' );
	-- tag  :    35:#### Tags: "group by","avg","order by"
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '95ce1a9d-d62f-4cc0-629d-97a10e3df433', '6e32b7a1-ea8c-4526-7157-5f35bb03ffae' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '58eec5ac-cd64-4448-4464-36e719561a90', '6e32b7a1-ea8c-4526-7157-5f35bb03ffae' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '5ebdcda7-5087-49ec-717c-46c2945d1ecf', '6e32b7a1-ea8c-4526-7157-5f35bb03ffae' );
	-- title:     4:# Interactive - 17 - select with join ( inner join, left outer join )
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '6965127f-0cd5-4df5-446b-a4a979c84f87', ' Interactive - 17 - select with join ( inner join, left outer join )', '17', 'hw17.mp4', 'hw17.jpg', '{}' );
	-- tag  :   131:#### Tags: "inner join","outer join","left outer join"
	insert into ct_tag ( tag_id, tag_word ) values ( '0f2d70a9-3784-4eb9-76e1-071bef194816', 'inner join' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '0f2d70a9-3784-4eb9-76e1-071bef194816', '6965127f-0cd5-4df5-446b-a4a979c84f87' );
	insert into ct_tag ( tag_id, tag_word ) values ( '5ee2adf8-35f2-4fee-4f1e-e627a812e859', 'outer join' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '5ee2adf8-35f2-4fee-4f1e-e627a812e859', '6965127f-0cd5-4df5-446b-a4a979c84f87' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'f489f7bc-8987-4ec5-509c-f0efb3ebd7d4', 'left outer join' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'f489f7bc-8987-4ec5-509c-f0efb3ebd7d4', '6965127f-0cd5-4df5-446b-a4a979c84f87' );
	-- title:     4:# Interactive - 18 - More joins (full joins)
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '2a9c7c5b-eee2-4323-6345-8b887be6c0cf', ' Interactive - 18 - More joins (full joins)', '18', 'hw18.mp4', 'hw18.jpg', '{}' );
	-- tag  :    61:#### Tags: "full join","full outer join"
	insert into ct_tag ( tag_id, tag_word ) values ( 'f2012c65-5fcc-45e8-78e9-a4c2423cdba1', 'full join' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'f2012c65-5fcc-45e8-78e9-a4c2423cdba1', '2a9c7c5b-eee2-4323-6345-8b887be6c0cf' );
	insert into ct_tag ( tag_id, tag_word ) values ( '701c990b-ab82-4ea8-469c-42751b6f3f2b', 'full outer join' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '701c990b-ab82-4ea8-469c-42751b6f3f2b', '2a9c7c5b-eee2-4323-6345-8b887be6c0cf' );
	-- title:     4:# Interactive - 19 - select using sub-query and exists
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'a8222b91-c5ec-4d96-7928-f60722327833', ' Interactive - 19 - select using sub-query and exists', '19', 'hw19.mp4', 'hw19.jpg', '{}' );
	-- tag  :    18:#### Tags: "select exists","sub-query"
	insert into ct_tag ( tag_id, tag_word ) values ( '302d7efb-9af9-41aa-4bcd-3c673e8215ef', 'select exists' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '302d7efb-9af9-41aa-4bcd-3c673e8215ef', 'a8222b91-c5ec-4d96-7928-f60722327833' );
	insert into ct_tag ( tag_id, tag_word ) values ( '337a159f-07b1-452b-724c-9d296f9b9429', 'sub-query' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '337a159f-07b1-452b-724c-9d296f9b9429', 'a8222b91-c5ec-4d96-7928-f60722327833' );
	-- title:     4:# Interactive - 20 - delete with in based sub-query
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'a16d48ca-5b40-414a-606d-7033dfa07bf0', ' Interactive - 20 - delete with in based sub-query', '20', 'hw20.mp4', 'hw20.jpg', '{}' );
	-- tag  :    28:#### Tags: "delete exists","sub-query"
	insert into ct_tag ( tag_id, tag_word ) values ( 'ce239aa2-1779-442f-6dcc-c9810cf72d20', 'delete exists' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'ce239aa2-1779-442f-6dcc-c9810cf72d20', 'a16d48ca-5b40-414a-606d-7033dfa07bf0' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '337a159f-07b1-452b-724c-9d296f9b9429', 'a16d48ca-5b40-414a-606d-7033dfa07bf0' );
	-- title:     4:# Interactive - 21 - select with union / minus
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '630184d3-78ea-4021-769f-e5a2fc614b21', ' Interactive - 21 - select with union / minus', '21', 'hw21.mp4', 'hw21.jpg', '{}' );
	-- tag  :    23:#### Tags: "union"
	insert into ct_tag ( tag_id, tag_word ) values ( '719a9520-6efc-4d37-4b19-58b0fa85414f', 'union' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '719a9520-6efc-4d37-4b19-58b0fa85414f', '630184d3-78ea-4021-769f-e5a2fc614b21' );
	-- title:     4:# Interactive - 22 - recursive select - populating existing tables 
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'c431566d-a982-43d8-6785-9d76fffc6193', ' Interactive - 22 - recursive select - populating existing tables ', '22', 'hw22.mp4', 'hw22.jpg', '{}' );
	-- tag  :    21:#### Tags: "recursive select",recursive
	insert into ct_tag ( tag_id, tag_word ) values ( '13f6c740-9380-45b7-65d6-deec8b317d59', 'recursive select' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '13f6c740-9380-45b7-65d6-deec8b317d59', 'c431566d-a982-43d8-6785-9d76fffc6193' );
	insert into ct_tag ( tag_id, tag_word ) values ( '4a7721c2-3b1f-4040-70f0-648b5efc3087', 'recursive' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '4a7721c2-3b1f-4040-70f0-648b5efc3087', 'c431566d-a982-43d8-6785-9d76fffc6193' );
	-- title:     4:# Interactive - 23 - with - pre-selects to do stuff.
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'a470c2c8-38b9-4534-55ed-24a368176c28', ' Interactive - 23 - with - pre-selects to do stuff.', '23', 'hw23.mp4', 'hw23.jpg', '{}' );
	-- tag  :    31:#### Tags: "with","with select"
	insert into ct_tag ( tag_id, tag_word ) values ( '96f54614-0ffa-4692-7b23-bbba903a2c08', 'with' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '96f54614-0ffa-4692-7b23-bbba903a2c08', 'a470c2c8-38b9-4534-55ed-24a368176c28' );
	insert into ct_tag ( tag_id, tag_word ) values ( '117bb99e-b919-4b95-525c-61a9c2c7c6e3', 'with select' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '117bb99e-b919-4b95-525c-61a9c2c7c6e3', 'a470c2c8-38b9-4534-55ed-24a368176c28' );
	-- title:     4:# Interactive - 24 - truncate table
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '6883ea5b-9d0a-4011-4dff-9daf76cc137b', ' Interactive - 24 - truncate table', '24', 'hw24.mp4', 'hw24.jpg', '{}' );
	-- tag  :    23:#### Tags: "truncate","fast delete","delete all rows"
	insert into ct_tag ( tag_id, tag_word ) values ( '2afab2c1-da03-4455-797e-64e3bf335891', 'truncate' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '2afab2c1-da03-4455-797e-64e3bf335891', '6883ea5b-9d0a-4011-4dff-9daf76cc137b' );
	insert into ct_tag ( tag_id, tag_word ) values ( '63bb3b51-394f-4d08-768d-2dc71ed08cf7', 'fast delete' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '63bb3b51-394f-4d08-768d-2dc71ed08cf7', '6883ea5b-9d0a-4011-4dff-9daf76cc137b' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'a5761120-7a73-4157-5ec7-dd55d374244a', 'delete all rows' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'a5761120-7a73-4157-5ec7-dd55d374244a', '6883ea5b-9d0a-4011-4dff-9daf76cc137b' );
	-- title:     4:# Interactive - 25 - drop cascade 
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '3e2e8bcf-7b91-4b11-5f01-abc5d5193661', ' Interactive - 25 - drop cascade ', '25', 'hw25.mp4', 'hw25.jpg', '{}' );
	-- tag  :    42:#### Tags: "drop","drop cascade"
	insert into ct_tag ( tag_id, tag_word ) values ( '1f019dda-a838-4895-70d3-e0a8f9886b2b', 'drop' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '1f019dda-a838-4895-70d3-e0a8f9886b2b', '3e2e8bcf-7b91-4b11-5f01-abc5d5193661' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '41a77383-fc6e-477c-5434-db1ff697bf11', '3e2e8bcf-7b91-4b11-5f01-abc5d5193661' );
	-- title:     4:# Interactive - 26 - 1 to 1 relationship  				(pk to pk)
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '5c18b992-1902-4b01-73a0-7df876871cd4', ' Interactive - 26 - 1 to 1 relationship  				(pk to pk)', '26', 'hw26.mp4', 'hw26.jpg', '{}' );
	-- tag  :   101:#### Tags: "setup","ct_homework","ct_homework_ans","ct_tag","ct_tag_homework","t_ymux_user","t_ymux_user_log","t_ymux_auth_token"
	insert into ct_tag ( tag_id, tag_word ) values ( '324eae0f-89a7-421f-496e-1ed49924ff38', 'setup' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '324eae0f-89a7-421f-496e-1ed49924ff38', '5c18b992-1902-4b01-73a0-7df876871cd4' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'ddb7a155-a280-451e-6422-6a4eb1591aed', 'ct_homework' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'ddb7a155-a280-451e-6422-6a4eb1591aed', '5c18b992-1902-4b01-73a0-7df876871cd4' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'db2537b8-3520-4f58-63bf-a2b4ac7ed9d9', 'ct_homework_ans' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'db2537b8-3520-4f58-63bf-a2b4ac7ed9d9', '5c18b992-1902-4b01-73a0-7df876871cd4' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'a0ffccbc-2773-4694-434c-aa11af7e7b63', 'ct_tag' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'a0ffccbc-2773-4694-434c-aa11af7e7b63', '5c18b992-1902-4b01-73a0-7df876871cd4' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'c6895057-7e3a-4af0-4f3a-934688195a47', 'ct_tag_homework' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'c6895057-7e3a-4af0-4f3a-934688195a47', '5c18b992-1902-4b01-73a0-7df876871cd4' );
	insert into ct_tag ( tag_id, tag_word ) values ( '37b7885f-8003-48ce-453e-3b5ec4775c27', 't_ymux_user' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '37b7885f-8003-48ce-453e-3b5ec4775c27', '5c18b992-1902-4b01-73a0-7df876871cd4' );
	insert into ct_tag ( tag_id, tag_word ) values ( '2427e0ec-a641-4b0b-42de-3039393a84e4', 't_ymux_user_log' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '2427e0ec-a641-4b0b-42de-3039393a84e4', '5c18b992-1902-4b01-73a0-7df876871cd4' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'd996c30d-e9ec-46c5-5abd-70b1be173630', 't_ymux_auth_token' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'd996c30d-e9ec-46c5-5abd-70b1be173630', '5c18b992-1902-4b01-73a0-7df876871cd4' );
	-- title:     4:# Interactive - 27 - 1 to 0 or 1 relationship 			(fk, unique)
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '227c41a8-de37-49d1-6e0d-f021946765af', ' Interactive - 27 - 1 to 0 or 1 relationship 			(fk, unique)', '27', 'hw27.mp4', 'hw27.jpg', '{}' );
	-- tag  :    21:#### Tags: "1 to 0","1:0","1:0 relationship","1:1"
	insert into ct_tag ( tag_id, tag_word ) values ( '5a24795a-d323-40f3-4982-e27afe304256', '1 to 0' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '5a24795a-d323-40f3-4982-e27afe304256', '227c41a8-de37-49d1-6e0d-f021946765af' );
	insert into ct_tag ( tag_id, tag_word ) values ( '8a423fa5-6d70-4fd4-521b-3dbe659f3c7e', '1:0' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '8a423fa5-6d70-4fd4-521b-3dbe659f3c7e', '227c41a8-de37-49d1-6e0d-f021946765af' );
	insert into ct_tag ( tag_id, tag_word ) values ( '2419487d-e8a7-4feb-7272-27c2d1425a3a', '1:0 relationship' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '2419487d-e8a7-4feb-7272-27c2d1425a3a', '227c41a8-de37-49d1-6e0d-f021946765af' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'de44e22d-7ab3-4889-7465-a3d184dba097', '1:1' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'de44e22d-7ab3-4889-7465-a3d184dba097', '227c41a8-de37-49d1-6e0d-f021946765af' );
	-- title:     5:# Interactive - 28 - 1 to n relationship				(fk)
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( 'cab7671a-c69b-45a6-79f1-a5048319448e', ' Interactive - 28 - 1 to n relationship				(fk)', '28', 'hw28.mp4', 'hw28.jpg', '{}' );
	-- tag  :    23:#### Tags: "1:n","1:n relationship"
	insert into ct_tag ( tag_id, tag_word ) values ( '3459beda-91ec-4a54-5cab-e3eda0b617b8', '1:n' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '3459beda-91ec-4a54-5cab-e3eda0b617b8', 'cab7671a-c69b-45a6-79f1-a5048319448e' );
	insert into ct_tag ( tag_id, tag_word ) values ( '70e7a009-421e-4e11-55fa-133a2b0cad3d', '1:n relationship' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '70e7a009-421e-4e11-55fa-133a2b0cad3d', 'cab7671a-c69b-45a6-79f1-a5048319448e' );
	-- title:     4:# Interactive - 29 - m to n relationship				(fk to join table to fk)
	insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '20ec79a8-7fca-43c5-62c0-ec38eaf41127', ' Interactive - 29 - m to n relationship				(fk to join table to fk)', '29', 'hw29.mp4', 'hw29.jpg', '{}' );
	-- tag  :   109:#### Tags: "m to n","m:n","m:n relationship"
	insert into ct_tag ( tag_id, tag_word ) values ( '0b4d2e5e-62cb-40d5-66fc-f24dd3c3c900', 'm to n' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( '0b4d2e5e-62cb-40d5-66fc-f24dd3c3c900', '20ec79a8-7fca-43c5-62c0-ec38eaf41127' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'c9372e6d-540a-4eec-61ef-d067b24e551b', 'm:n' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'c9372e6d-540a-4eec-61ef-d067b24e551b', '20ec79a8-7fca-43c5-62c0-ec38eaf41127' );
	insert into ct_tag ( tag_id, tag_word ) values ( 'a718b366-efc8-4473-476b-4b7da6f61738', 'm:n relationship' );
	insert into ct_tag_homework ( tag_id, homework_id ) values ( 'a718b366-efc8-4473-476b-4b7da6f61738', '20ec79a8-7fca-43c5-62c0-ec38eaf41127' );
	-- Tag distinct 05cd4e1d-4600-40d0-7164-ed92b15cd90d
	-- Tag data types fe0cd1b3-2b7b-4ab2-556c-cf18492f596c
	-- Tag m:n c9372e6d-540a-4eec-61ef-d067b24e551b
	-- Tag 1:n 3459beda-91ec-4a54-5cab-e3eda0b617b8
	-- Tag not in 0a618081-e05c-4402-64f0-a3211d5e3a3a
	-- Tag delete exists ce239aa2-1779-442f-6dcc-c9810cf72d20
	-- Tag fast delete 63bb3b51-394f-4d08-768d-2dc71ed08cf7
	-- Tag ct_homework_ans db2537b8-3520-4f58-63bf-a2b4ac7ed9d9
	-- Tag where 62bbab6b-edf2-4c44-6b06-ae1198d9b2a4
	-- Tag count e835bd6f-79c5-403b-6714-7ea74d3cecbb
	-- Tag ct_homework ddb7a155-a280-451e-6422-6a4eb1591aed
	-- Tag primary key 663615bf-ef81-432d-6757-0a208a31e297
	-- Tag add constraint 01be3801-7432-4539-40ff-f4588e3aebab
	-- Tag drop table 7befc9c8-715d-49e3-543f-2033e687f820
	-- Tag UUID 3729bc77-965d-4e11-630c-0f5dc966e5ae
	-- Tag drop 1f019dda-a838-4895-70d3-e0a8f9886b2b
	-- Tag hw02 4a0a43e2-3274-47e4-79f5-b4174c894727
	-- Tag select 372b3af3-3efd-4a59-5592-1f6f5db23b4c
	-- Tag alter table rename d5b37e3b-1fbe-4346-4e55-8b52262aaee7
	-- Tag type cast 5ea3c09b-72b6-41cf-78df-dfecac741ce8
	-- Tag order by 5ebdcda7-5087-49ec-717c-46c2945d1ecf
	-- Tag outer join 5ee2adf8-35f2-4fee-4f1e-e627a812e859
	-- Tag full join f2012c65-5fcc-45e8-78e9-a4c2423cdba1
	-- Tag 1:0 8a423fa5-6d70-4fd4-521b-3dbe659f3c7e
	-- Tag type varchar 21afa68b-c5a5-45c2-4565-a56ac78ec9f6
	-- Tag insert select c151f6cf-d694-4805-4574-04ae8b395ee1
	-- Tag duplicate data a52eb34d-57c0-43fe-4bfb-db3190ad454b
	-- Tag 1:1 de44e22d-7ab3-4889-7465-a3d184dba097
	-- Tag m to n 0b4d2e5e-62cb-40d5-66fc-f24dd3c3c900
	-- Tag drop cascade 41a77383-fc6e-477c-5434-db1ff697bf11
	-- Tag group by 95ce1a9d-d62f-4cc0-629d-97a10e3df433
	-- Tag ct_tag a0ffccbc-2773-4694-434c-aa11af7e7b63
	-- Tag setup 324eae0f-89a7-421f-496e-1ed49924ff38
	-- Tag m:n relationship a718b366-efc8-4473-476b-4b7da6f61738
	-- Tag rename ab618312-1100-4b41-67fc-88f0fe94ab28
	-- Tag index e37a23e6-37e5-493a-58af-ce8bf8f96e91
	-- Tag nested query b7963841-c671-4759-5eff-6cddcca38409
	-- Tag 1 to 0 5a24795a-d323-40f3-4982-e27afe304256
	-- Tag type text 32fc0c4e-2f84-4a45-4fb9-3714752ed2ba
	-- Tag inner join 0f2d70a9-3784-4eb9-76e1-071bef194816
	-- Tag union 719a9520-6efc-4d37-4b19-58b0fa85414f
	-- Tag t_ymux_user_log 2427e0ec-a641-4b0b-42de-3039393a84e4
	-- Tag type int ece35a50-2b0d-470f-4884-54ccb42abef9
	-- Tag insert b75adab0-e4b5-4dfd-5c9c-c2f1aa4fe1c5
	-- Tag sub-query 337a159f-07b1-452b-724c-9d296f9b9429
	-- Tag max c7e2acdf-6c4a-4887-716d-50591f01c3e5
	-- Tag select exists 302d7efb-9af9-41aa-4bcd-3c673e8215ef
	-- Tag recursive select 13f6c740-9380-45b7-65d6-deec8b317d59
	-- Tag unique id 6350d08c-bd4e-401e-4fb4-e7c14d561108
	-- Tag alter table 949c884b-5311-49a7-4b98-ccce7b147e50
	-- Tag create index fee655c8-e5ab-488b-403d-9e362fe328de
	-- Tag ct_tag_homework c6895057-7e3a-4af0-4f3a-934688195a47
	-- Tag t_ymux_user 37b7885f-8003-48ce-453e-3b5ec4775c27
	-- Tag lower 161ab39f-25bc-4d43-68cd-42ba3f6b4b50
	-- Tag delete 951ad3b7-4bfc-4ab5-717c-9efd15f6fd1e
	-- Tag sub query c4490eb6-a730-477c-6259-c315d332ff63
	-- Tag with select 117bb99e-b919-4b95-525c-61a9c2c7c6e3
	-- Tag truncate 2afab2c1-da03-4455-797e-64e3bf335891
	-- Tag create table a439239c-5579-4df3-7c76-b0176a6897cf
	-- Tag update 4049fdeb-4446-4f70-6bf3-cf91fa30a522
	-- Tag foreign key 22dc266f-3473-464f-6874-e8a4da038ebb
	-- Tag recursive 4a7721c2-3b1f-4040-70f0-648b5efc3087
	-- Tag 1:n relationship 70e7a009-421e-4e11-55fa-133a2b0cad3d
	-- Tag select distinct 4d7be2ff-30bb-4388-4b16-6c3a5c22f6f1
	-- Tag uuid 415ce134-8769-49ac-6c61-e5f7f0d2c539
	-- Tag reload data a86023c1-098c-4e4f-7f77-d8b9aae8424c
	-- Tag left outer join f489f7bc-8987-4ec5-509c-f0efb3ebd7d4
	-- Tag full outer join 701c990b-ab82-4ea8-469c-42751b6f3f2b
	-- Tag t_ymux_auth_token d996c30d-e9ec-46c5-5abd-70b1be173630
	-- Tag hw01 d93831ed-3c66-424a-4bb1-61fa6c8edf64
	-- Tag count distinct 693796e8-b87c-4558-4590-27dad7c0ec31
	-- Tag min 4c3f8a59-b955-4655-53d4-e594f1c625a3
	-- Tag 1:0 relationship 2419487d-e8a7-4feb-7272-27c2d1425a3a
	-- Tag avg 58eec5ac-cd64-4448-4464-36e719561a90
	-- Tag with 96f54614-0ffa-4692-7b23-bbba903a2c08
	-- Tag delete all rows a5761120-7a73-4157-5ec7-dd55d374244a

	RETURN 'PASS';
END;
$$;
