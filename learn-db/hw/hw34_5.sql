
-- -------------------------------------------------------- -- --------------------------------------------------------
-- This tracks if the user has watched the video and the number of times.  It is a log of watches.
--
-- When: on completion of watch of video.
-- -------------------------------------------------------- -- --------------------------------------------------------

CREATE TABLE if not exists ct_homework_seen (
	  id						uuid DEFAULT uuid_generate_v4() not null primary key
	, user_id					uuid not null
	, homework_id				uuid not null
	, homework_no				text not null
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
CREATE TABLE if not exists ct_homework_grade (
	  user_id		uuid not null						-- 1 to 1 map to user	
	, homework_id	uuid not null						-- assignment
	, homework_no	text not null
	, tries			int default 0 not null				-- how many times did they try thisa
	, pass			text default 'No' not null			-- Did the test get passed
	, pts			int default 0 not null				-- points awarded
 	, updated 		timestamp
 	, created 		timestamp default current_timestamp not null
);

CREATE UNIQUE index if not exists ct_homework_grade_u1 on ct_homework_grade ( homework_id, user_id );
CREATE UNIQUE index if not exists ct_homework_grade_u2 on ct_homework_grade ( homework_no, user_id );



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









-----------------------------------------------------------------------------------------------------------------------

-- DROP VIEW if exists ct_homework_per_user_title;

CREATE TABLE if not exists ct_homework (
	  homework_id				uuid DEFAULT uuid_generate_v4() not null primary key
	, homework_title			text not null
	, homework_no				text not null
	, points_avail				int not null default 10
	, video_url					text not null
	, video_img					text not null
	, lesson_body 				JSONb not null 	-- body, html, text etc.
 	, updated 					timestamp
 	, created 					timestamp default current_timestamp not null
);

CREATE INDEX if not exists ct_homework_p1 on ct_homework ( homework_no );
CREATE INDEX if not exists ct_homework_p2 on ct_homework using gin ( lesson_body );
CREATE UNIQUE index if not exists ct_homework_u1 on ct_homework ( homework_no );



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


