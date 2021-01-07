
--
-- Copyright (C) Philip Schlump, 2016-2020.  All rights reserved.
-- MIT Licensed.
--













DROP VIEW if exists ct_video_per_user cascade ;
DROP TABLE if exists ct_homework_seen cascade ;
DROP TABLE if exists ct_homework_grade cascade ;
DROP TABLE if exists ct_homework_list cascade ;
DROP TABLE if exists ct_homework cascade ;
DROP TABLE if exists ct_homework_validation cascade ;
DROP TABLE if exists ct_output cascade ;
DROP TABLE if exists ct_val_homework cascade ;
DROP TABLE if exists ct_file_list cascade ;
DROP TABLE if exists ct_login cascade ;
DROP SEQUENCE if exists ct_run_seq ;

-- -------------------------------------------------------- -- --------------------------------------------------------
-- 1 to 1 to user to add additional parametric data to a user.
-- Inserted right after registration. (part of user create script)
-- -------------------------------------------------------- -- --------------------------------------------------------
CREATE TABLE ct_login (
	  user_id					uuid not null primary key -- 1 to 1 to t_ymux_user."id"
	, pg_acct					char varying (20) not null
);

CREATE UNIQUE INDEX ct_login_u1 on ct_login ( pg_acct );


-- -------------------------------------------------------- -- --------------------------------------------------------
-- This tracks if the user has watched the video and the number of times.  It is a log of watches.
--
-- When: on completion of watch of video.
-- -------------------------------------------------------- -- --------------------------------------------------------

CREATE TABLE ct_homework_seen (
	  id						uuid DEFAULT uuid_generate_v4() not null primary key
	, user_id					uuid not null
	, homework_id				uuid not null
	, when_seen					timestamp 
	, watch_count				int default 0 not null
	, when_start				timestamp 
 	, updated 					timestamp
 	, created 					timestamp default current_timestamp not null
);



CREATE OR REPLACE function ct_homework_seen_upd()
RETURNS trigger AS 
$BODY$
BEGIN
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$BODY$
LANGUAGE 'plpgsql';


CREATE TRIGGER ct_homework_seen_trig
BEFORE update ON "ct_homework_seen"
FOR EACH ROW
EXECUTE PROCEDURE ct_homework_seen_upd();




		--	left outer join ct_homework_seen as t2 on ( t1.homework_id = t2.homework_id )

-- -------------------------------------------------------- -- --------------------------------------------------------
-- Upon completion of the homework section this row is added - and marked as pass/fail.
--
-- WHen : on submit of homework.
-- -------------------------------------------------------- -- --------------------------------------------------------
CREATE TABLE ct_homework_grade (
	  user_id		uuid not null						-- 1 to 1 map to user	
	, homework_id		uuid not null						-- assignment
	, tries			int default 0 not null				-- how many times did they try thisa
	, pass			text default 'No' not null			-- Did the test get passed
	, pts			int default 0 not null				-- points awarded
 	, updated 		timestamp
 	, created 		timestamp default current_timestamp not null
);



CREATE OR REPLACE function ct_homework_grade_upd()
RETURNS trigger AS 
$BODY$
BEGIN
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$BODY$
LANGUAGE 'plpgsql';


CREATE TRIGGER ct_homework_grade_trig
BEFORE update ON "ct_homework_grade"
FOR EACH ROW
EXECUTE PROCEDURE ct_homework_grade_upd();





-- -------------------------------------------------------- -- --------------------------------------------------------
-- Hm.... ???
-- Hm.... ???
-- Hm.... ???
-- -------------------------------------------------------- -- --------------------------------------------------------
CREATE TABLE ct_homework_list (
	  user_id		uuid not null						-- 1 to 1 map to user	
	, lesson_id		uuid not null						-- assignment
	, when_test		timestamp not null default now()	-- when did it get run/tested?
	, code			text not null						-- the submitted code
	, pass			text default 'No' not null			-- Assume that it failed to pass
 	, updated 		timestamp
 	, created 		timestamp default current_timestamp not null
);



CREATE OR REPLACE function ct_homework_list_upd()
RETURNS trigger AS 
$BODY$
BEGIN
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$BODY$
LANGUAGE 'plpgsql';


CREATE TRIGGER ct_homework_list_trig
BEFORE update ON "ct_homework_list"
FOR EACH ROW
EXECUTE PROCEDURE ct_homework_list_upd();






-----------------------------------------------------------------------------------------------------------------------

-- DROP VIEW if exists ct_homework_per_user_title;

CREATE TABLE ct_homework (
	  homework_id				uuid DEFAULT uuid_generate_v4() not null primary key
	, homework_title			text not null
	, homework_no					text not null
	, points_avail				int not null default 10
	, video_url					text not null
	, video_img					text not null
	, lesson_body 				JSONb not null 	-- body, html, text etc.
 	, updated 					timestamp
 	, created 					timestamp default current_timestamp not null
);

CREATE INDEX ct_homework_p1 on ct_homework ( homework_no );
CREATE INDEX ct_video_p2 on ct_homework using gin ( lesson_body );



CREATE OR REPLACE function ct_homework_upd()
RETURNS trigger AS 
$BODY$
BEGIN
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$BODY$
LANGUAGE 'plpgsql';


CREATE TRIGGER ct_homework_trig
BEFORE update ON "ct_homework"
FOR EACH ROW
EXECUTE PROCEDURE ct_homework_upd();




-- create or replace view ct_homework_per_user_title as
-- 	select distinct t1.homework_id, t1.homework_title, t2.user_id
-- 	from ct_homework as t1
-- 		left outer join "t_ymux_user" as t2 
-- ;
		

-- -------------------------------------------------------- -- --------------------------------------------------------
-- Used to create a sequential list of data.
-- -------------------------------------------------------- -- --------------------------------------------------------
CREATE SEQUENCE ct_run_seq
	INCREMENT 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1;


-- -------------------------------------------------------- -- --------------------------------------------------------
-- The in-order list (seq) of checks on a subject that validate the subject.
-- ct_homework -1-to-N(ordered-list)- of ct_homework_validation.
-- qdata is the set of tests that are performed to check an answer.  If a test returns 'PASS' then a row in
-- ct_homework_grade is put in.  If non pass then a ct_homework_grade.pass = 'No' is put in.
-- old
-- , pass					char (1) default 'n' not null check ( "pass" in ( 'y','n' ) )
-- -------------------------------------------------------- -- --------------------------------------------------------
CREATE TABLE ct_homework_validation (
	  id					uuid DEFAULT uuid_generate_v4() not null primary key
	, lesson_id				uuid not null
	, seq					bigint DEFAULT nextval('ct_run_seq'::regclass) NOT NULL 	-- ID for passing to client as a number
	, qdata					jsonb not null
 	, updated 				timestamp
 	, created 				timestamp default current_timestamp not null
);



CREATE OR REPLACE function ct_homework_validation_upd()
RETURNS trigger AS 
$BODY$
BEGIN
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$BODY$
LANGUAGE 'plpgsql';


CREATE TRIGGER ct_homework_validation_trig
BEFORE update ON "ct_homework_validation"
FOR EACH ROW
EXECUTE PROCEDURE ct_homework_validation_upd();






-- -------------------------------------------------------- -- --------------------------------------------------------
-- 
-- -------------------------------------------------------- -- --------------------------------------------------------
create table ct_val_homework (
	val_id uuid not null primary key,
	homework_no int not null,
	val_type text not null,
	val_data text not null
 	, updated 				timestamp
 	, created 				timestamp default current_timestamp not null
);



CREATE OR REPLACE function ct_val_homework_upd()
RETURNS trigger AS 
$BODY$
BEGIN
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$BODY$
LANGUAGE 'plpgsql';


CREATE TRIGGER ct_val_homework_trig
BEFORE update ON "ct_val_homework"
FOR EACH ROW
EXECUTE PROCEDURE ct_val_homework_upd();




-- -------------------------------------------------------- -- --------------------------------------------------------
-- 
-- -------------------------------------------------------- -- --------------------------------------------------------
create table ct_file_list (
	file_list_id uuid not null primary key,
	homework_no int not null,
	file_name text not null
 	, updated 				timestamp
 	, created 				timestamp default current_timestamp not null
);



CREATE OR REPLACE function ct_file_list_upd()
RETURNS trigger AS 
$BODY$
BEGIN
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$BODY$
LANGUAGE 'plpgsql';


CREATE TRIGGER ct_file_list_trig
BEFORE update ON "ct_file_list"
FOR EACH ROW
EXECUTE PROCEDURE ct_file_list_upd();





-- -------------------------------------------------------- -- --------------------------------------------------------
-- General output table for data model tests.
-- -------------------------------------------------------- -- --------------------------------------------------------
CREATE TABLE ct_output (
	  id			bigint DEFAULT nextval('ct_run_seq'::regclass) NOT NULL 	-- Time orderd sequece output.
	, line			text
	, created		timestamp default now() not null
);

create index ct_output_p1 on ct_output ( created );



-- -------------------------------------------------------- -- --------------------------------------------------------
-- See:https://www.postgresqltutorial.com/postgresql-joins/
-- -------------------------------------------------------- -- --------------------------------------------------------
create or replace view ct_video_per_user as
	select
			  t1.homework_id
			, t1.homework_title
			, t1.video_url
			, t1.video_img
			, t1.lesson_body
			, t1.homework_no
			, t2.id as video_seen_id
			, t2.when_seen
			, t2.watch_count
			, case
				when t2.watch_count = 0 then 'n'
				when t2.watch_count is null then 'n'
				else 'y'
			  end as "has_been_seen"
		from ct_homework as t1
			left outer join ct_homework_seen as t2 on ( t1.homework_id = t2.homework_id )
;


\i ../hw/hw26_04.sql
-- 05 is ct_homeowrk - built above
\i ../hw/hw26_06.sql
\i ../hw/hw26_07.sql
-- 08 is empty
\i ../hw/hw26_09.sql
\i ../hw/hw26_10.sql


-- -------------------------------------------------------- -- --------------------------------------------------------
-- Data
-- -------------------------------------------------------- -- --------------------------------------------------------

DELETE FROM ct_homework ;
INSERT INTO ct_homework (
	  homework_title			-- text not null
	, video_url					-- text not null
	, video_img					-- text not null
	, lesson_body				-- jsonb not null	-- all the leson data from ./lesson/{lesson_id}.json, ./raw/{fn}
	, homework_no				-- 01, 02 ... 99
) values
	  (  'Create Tabel'              , '1.mp4', '1.png', '{"sample":1,"lesson_text":"Some <i><b>Lesson</b></i> Text 1","sql_test":"select s01_test() as X","test_type":"sql"}', '91' )
	, (  'Select From'               , '2.mp4', '2.png', '{"sample":2,"lesson_text":"Some Lesson Text 2"}', '92' )
	, (  'Select Where'              , '3.mp4', '3.png', '{"sample":3,"lesson_text":"Some Lesson Text 3"}', '93' )
;

\i ../hw/gen_data.sql












-- -------------------------------------------------------- -- --------------------------------------------------------
-- Validation / Testing
-- -------------------------------------------------------- -- --------------------------------------------------------


CREATE or REPLACE FUNCTION s00_test ( )
RETURNS varchar AS $$
DECLARE
    l_cnt int;
    l_n_err int;
BEGIN
    l_n_err = 0;
	delete from ct_output;

	IF l_n_err = 0 THEN
		insert into ct_output ( line ) values ( 'PASS - no errors' );
		RETURN 'PASS';
	ELSE
		RETURN 'FAIL - errors = '|| l_n_err::text;
	END IF;
END;
$$ LANGUAGE plpgsql;




CREATE or REPLACE FUNCTION s01_test ( )
RETURNS varchar AS $$
DECLARE
    l_cnt int;
    l_n_err int;
    l_junk int;
	l_fail boolean;
	l_schema varchar;
BEGIN
	l_fail = false;
    l_n_err = 0;
	delete from ct_output;
	l_schema = current_schema();

	-- TODO - check that table exists	
	IF NOT l_fail THEN
		SELECT 1 
			INTO l_junk 	
			FROM information_schema.tables 
			WHERE table_schema = l_schema
			  and table_catalog = current_database()
			  and table_name = 'hw_01'
			;
		IF NOT found THEN
			l_fail = true;
			l_n_err = l_n_err + 1;
			insert into ct_output ( line ) values ( 'Table hw_01 is missing' );
		END IF;
	END IF;

	-- TODO - check that it has correct columns
	IF NOT l_fail THEN
		SELECT count(1) 
			INTO l_junk 	
			FROM information_schema.columns 
			WHERE table_schema = l_schema
			  and table_catalog = current_database()
			  and table_name = 'hw_01'
			  and column_name in ( 'name', 'age', 'a_date' )
			;
		IF NOT found THEN
			l_fail = true;
			l_n_err = l_n_err + 1;
			insert into ct_output ( line ) values ( 'Table hw_01 has no colunns - this is unusual' );
		END IF;
		IF l_junk < 3 then
			l_fail = true;
			l_n_err = l_n_err + 1;
			insert into ct_output ( line ) values ( 'Table hw_01 is missing a column' );
		END IF;
	END IF;
	IF NOT l_fail THEN
		SELECT count(1) 
			INTO l_junk 	
			FROM information_schema.columns 
			WHERE table_schema = l_schema
			  and table_catalog = current_database()
			  and table_name = 'hw_01'
			;
		IF NOT found THEN
			l_fail = true;
			l_n_err = l_n_err + 1;
			insert into ct_output ( line ) values ( 'Table hw_01 has no colunns - this is unusual' );
		END IF;
		IF l_junk > 3 then
			l_fail = true;
			l_n_err = l_n_err + 1;
			insert into ct_output ( line ) values ( 'Table hw_01 has extra columns' );
		END IF;
	END IF;

	IF l_n_err = 0 THEN
		insert into ct_output ( line ) values ( 'PASS - no errors' );
		RETURN 'PASS';
	ELSE
		RETURN 'FAIL - errors = '|| l_n_err::text;
	END IF;
END;
$$ LANGUAGE plpgsql;




















CREATE or REPLACE FUNCTION ct_table_test ( p_p1 varchar, p_p2 varchar )
RETURNS varchar AS $$
DECLARE
    l_junk uuid;
    l_cnt int;
    l_n_err int;
BEGIN
    l_n_err = 0;
	delete from ct_output;

	-- ------------------------------------------------------ -- ------------------------------------------------------
	-- test that view is created correctly.
	-- ------------------------------------------------------ -- ------------------------------------------------------
	select count(1)
		into l_cnt
		from ct_video_per_user
		;
	IF NOT FOUND THEN
		l_n_err = l_n_err + 1;
		insert into ct_output ( line ) values ( 'not found - no rows in view: ct_video_per_user - should be 2' );
	ELSE
		IF l_cnt <> 2 THEN
			l_n_err = l_n_err + 1;
			insert into ct_output ( line ) values ( 'Expected 2 rows got: '||l_cnt::text );
		ELSE
			insert into ct_output ( line ) values ( 'PASS - test 001' );
		END IF;
	END IF;

	select count(1)
		into l_cnt
		from ct_video_per_user
		where has_been_seen = 'y'
		;
	IF NOT FOUND THEN
		insert into ct_output ( line ) values ( 'PASS - test 002' );
	ELSE
		IF l_cnt <> 0 THEN
			l_n_err = l_n_err + 1;
			insert into ct_output ( line ) values ( 'Expected 0 rows got: '||l_cnt::text );
		ELSE
			insert into ct_output ( line ) values ( 'PASS - test 002' );
		END IF;
	END IF;






	IF l_n_err = 0 THEN
		insert into ct_output ( line ) values ( 'PASS - no errors' );
		RETURN 'PASS';
	ELSE
		RETURN 'FAIL - errors = '|| l_n_err::text;
	END IF;
END;
$$ LANGUAGE plpgsql;

select ct_table_test ( '', '' );

select line from ct_output order by id;


CREATE or REPLACE FUNCTION ct_setup_data ()
RETURNS varchar AS $$
DECLARE
    l_junk uuid;
    l_cnt int;
    l_n_err int;
BEGIN
    l_n_err = 0;
	insert into ct_login ( user_id, pg_acct ) values ( '7a955820-050a-405c-7e30-310da8152b6d', 'bobo0001' );
	return 'PASS';
END;
$$ LANGUAGE plpgsql;

select  ct_setup_data ();


