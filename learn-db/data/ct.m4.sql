
--
-- Copyright (C) Philip Schlump, 2016-2020.  All rights reserved.
-- MIT Licensed.
--

m4_include(setup.m4)

-- -------------------------------------------------------- -- --------------------------------------------------------
-- 1 to 1 to user to add additional parametric data to a user.
-- Inserted right after registration. (part of user create script)
-- -------------------------------------------------------- -- --------------------------------------------------------
drop table if exists ct_login ;
CREATE TABLE ct_login (
	  user_id					m4_uuid_type() not null primary key -- 1 to 1 to t_ymux_user."id"
	, pg_acct					char varying (20) not null
	, class_no					text default '4010-BC' not null				-- 4280 or 4010-BC - one of 2 classes
	, lang_to_use				text default 'Go' not null				-- Go or PostgreSQL
	, misc						JSONb default '{}' not null				-- Whatever I forgot
);

create unique index ct_login_u1 on ct_login ( pg_acct );
create index ct_login_p1 on ct_login using gin ( misc );



-- -------------------------------------------------------- -- --------------------------------------------------------
-- This tracks if the user has watched the video and the number of times.  It is a log of watches.
--
-- When: on completion of watch of video.
-- -------------------------------------------------------- -- --------------------------------------------------------
drop view if exists ct_video_per_user ;
-- drop table if exists ct_video_seen ; -- old --
drop table if exists ct_lesson_seen ;
CREATE TABLE ct_lesson_seen (
	  id						m4_uuid_type() DEFAULT uuid_generate_v4() not null primary key
	, user_id					m4_uuid_type() not null
	, lesson_id					m4_uuid_type() not null
	, when_seen					timestamp 
	, watch_count				int default 0 not null
	, when_start				timestamp 
 	, updated 					timestamp
 	, created 					timestamp default current_timestamp not null
);

m4_updTrig(ct_lesson_seen)



-- -------------------------------------------------------- -- --------------------------------------------------------
-- Upon completion of the homework section this row is added - and marked as pass/fail.
--
-- WHen : on submit of homework.
-- -------------------------------------------------------- -- --------------------------------------------------------
drop table if exists ct_homework_grade ;
CREATE TABLE ct_homework_grade (
	  user_id		uuid not null						-- 1 to 1 map to user	
	, lesson_id		uuid not null						-- assignment
	, tries			int default 0 not null				-- how many times did they try thisa
	, pass			text default 'No' not null			-- Did the test get passed
 	, updated 		timestamp
 	, created 		timestamp default current_timestamp not null
);

m4_updTrig(ct_homework_grade)



-- -------------------------------------------------------- -- --------------------------------------------------------
-- Hm.... ???
-- Hm.... ???
-- Hm.... ???
-- -------------------------------------------------------- -- --------------------------------------------------------
drop table if exists ct_homework_list ;
CREATE TABLE ct_homework_list (
	  user_id		uuid not null						-- 1 to 1 map to user	
	, lesson_id		uuid not null						-- assignment
	, when_test		timestamp not null default now()	-- when did it get run/tested?
	, code			text not null						-- the submitted code
	, pass			text default 'No' not null			-- Assume that it failed to pass
 	, updated 		timestamp
 	, created 		timestamp default current_timestamp not null
);


m4_updTrig(ct_homework_list)



-- -------------------------------------------------------- -- --------------------------------------------------------
-- ct_lesson is the set of lessons that the person can do.
-- -------------------------------------------------------- -- --------------------------------------------------------
-- drop table if exists ct_video ;	 -- old --
drop table if exists ct_lesson ;
CREATE TABLE ct_lesson (
	  lesson_id					m4_uuid_type() DEFAULT uuid_generate_v4() not null primary key
	, video_raw_file			text not null
	, video_title				text not null
	, url						text not null
	, img_url					text not null
	, lesson					jsonb not null	-- all the leson data from ./lesson/{lesson_id}.json, ./raw/{fn}
	, lesson_name				text not null
	, lang_to_use				text default 'Go' not null				-- Go or PostgreSQL
 	, updated 					timestamp
 	, created 					timestamp default current_timestamp not null
);

create index ct_video_p1 on ct_lesson ( lesson_name );

-- See:https://scalegrid.io/blog/using-jsonb-in-postgresql-how-to-effectively-store-index-json-data-in-postgresql/
create index ct_video_p2 on ct_lesson using gin ( lesson );

m4_updTrig(ct_lesson)



-- -------------------------------------------------------- -- --------------------------------------------------------
-- Used to create a sequential list of data.
-- -------------------------------------------------------- -- --------------------------------------------------------
drop table if exists ct_video_questions ;
drop table if exists ct_lesson_validation ;
drop table if exists ct_output ;
drop sequence if exists ct_run_seq;
CREATE SEQUENCE ct_run_seq
	INCREMENT 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1;


-- -------------------------------------------------------- -- --------------------------------------------------------
-- The in-order list (seq) of checks on a subject that validate the subject.
-- ct_lesson -1-to-N(ordered-list)- of ct_lesson_validation.
-- qdata is the set of tests that are performed to check an answer.  If a test returns 'PASS' then a row in
-- ct_homework_grade is put in.  If non pass then a ct_homework_grade.pass = 'No' is put in.
-- old
-- , pass					char (1) default 'n' not null check ( "pass" in ( 'y','n' ) )
-- -------------------------------------------------------- -- --------------------------------------------------------
CREATE TABLE ct_lesson_validation (
	  id					m4_uuid_type() DEFAULT uuid_generate_v4() not null primary key
	, lesson_id				m4_uuid_type() not null
	, seq					bigint DEFAULT nextval('ct_run_seq'::regclass) NOT NULL 	-- ID for passing to client as a number
	, qdata					jsonb not null
 	, updated 				timestamp
 	, created 				timestamp default current_timestamp not null
);

m4_updTrig(ct_lesson_validation)


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
drop view if exists ct_video_per_user ;
create or replace view ct_video_per_user as
	select
			  t1.lesson_id
			, t1.video_raw_file
			, t1.video_title
			, t1.url
			, t1.img_url
			, t1.lesson
			, t1.lesson_name
			, t2.id as video_seen_id
			, t2.when_seen
			, t2.watch_count
			, case
				when t2.watch_count = 0 then 'n'
				when t2.watch_count is null then 'n'
				else 'y'
			  end as "has_been_seen"
			, t1.lang_to_use				
		from ct_lesson as t1
			left outer join ct_lesson_seen as t2 on ( t1.lesson_id = t2.lesson_id )
;



-- -------------------------------------------------------- -- --------------------------------------------------------
-- Data
-- -------------------------------------------------------- -- --------------------------------------------------------

--insert into ct_login ( user_id, pg_acct, class_no, lang_to_use, misc ) values
--	  ( uuid_generate_v4(), 'i4280v001', '4280', 'PostgreSQL', '{}' )
--	, ( uuid_generate_v4(), 'i4280v002', '4010-BC', 'Go', '{}' )
--;
--CREATE TABLE ct_login (
--	  user_id					m4_uuid_type() not null primary key -- 1 to 1 to t_ymux_user."id"
--	, pg_acct					char varying (20) not null
--	, class_no					text default '4010-BC' not null				-- 4280 or 4010-BC - one of 2 classes
--	, lang_to_use				text default 'Go' not null				-- Go or PostgreSQL
--	, misc						JSONb default '{}' not null				-- Whatever I forgot
--);
insert into ct_login ( user_id, pg_acct, class_no, lang_to_use, misc ) values
	  ( '7a955820-050a-405c-7e30-310da8152b6d', 'i4280v001', '4280', 'PostgreSQL', '{}' )
;


delete from ct_lesson ;
insert into ct_lesson (
	  video_raw_file			-- text not null
	, video_title				-- text not null
	, url						-- text not null
	, img_url					-- text not null
	, lesson					-- jsonb not null	-- all the leson data from ./lesson/{lesson_id}.json, ./raw/{fn}
	, lesson_name				-- 
	, lang_to_use				-- Go or PostgrsSQL
) values
	  ( 'sql_create_table_1.md', 'Create Tabel'              , '1.mp4', '1.png', '{"sample":1,"lesson_text":"Some <i><b>Lesson</b></i> Text 1","sql_test":"select s01_test() as X","test_type":"sql"}', 's01', 'PostgreSQL' )
	, ( 'sql_select_2.md'      , 'Select From'               , '2.mp4', '2.png', '{"sample":2,"lesson_text":"Some Lesson Text 2"}', 's02', 'PostgreSQL' )
	, ( 'sql_select_3.md'      , 'Select Where'              , '3.mp4', '3.png', '{"sample":3,"lesson_text":"Some Lesson Text 3"}', 's03', 'PostgreSQL' )
	, ( 'go_calc_1.md'         , 'Basic Claculation'         , '1.mp4', '1.jpg', '{"sample":4,"lesson_text":"Some Lesson Text 4"}', 'g01', 'Go' )
	, ( 'go_func_2.md'         , 'Functions'                 , '4.mp4', '2.png', '{"sample":5,"lesson_text":"Some Lesson Text 5"}', 'g02', 'Go' )
;
















--$begin-test$ ct_table_test()

-- -------------------------------------------------------- -- --------------------------------------------------------
-- Validation / Testing
-- -------------------------------------------------------- -- --------------------------------------------------------

-- 01 - create table
-- 02 - insrt
-- 03 - select *
-- 04 - select col
-- 05 - select * where ...
-- 06 - update
-- 07 - delete
-- 08 - 2nd table
-- 09 - list tables
-- 10 - alter table
-- 11 - add 3rd table
-- 12 - drop table
-- 13 - simple join
-- 14 - inner join
-- 15 - outer join
-- 16 - group by
-- 18 - sumation
-- 19 - where exits
-- 20 - where in
-- 21 - create view
-- 22 - create function
-- 23 - drop if exists
-- 24 - check constraints
-- 25 - indexes
-- 26 - gin indexes
-- 27 - JSONb
-- 28 - Geographic data (GIS)
-- 29 - foreign keys
-- 30 - foreign keys constraints
-- 31 - delete ... cascade
-- 32 - information schema - list tables
-- 33 - information schema - list indexes
-- 34 - maintance - find unused indxes
-- 35 - maintance - count tables


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
    l_junk m4_uuid_type();
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

--$end-test$















