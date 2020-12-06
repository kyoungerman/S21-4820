
m4_changequote(`[[[', `]]]')

-- -------------------------------------------------------- -- --------------------------------------------------------
drop table if exists ct_login ;
create table ct_login (
	  user_id					char varying (40) DEFAULT uuid_generate_v4() not null primary key
	, username 					char varying(200) not null
	, password 					char varying(200) not null
	, pg_acct					char varying (20) not null
);

create unique index ct_loing_u1 on ct_login ( username );
create unique index ct_loing_u2 on ct_login ( password );
create unique index ct_loing_u3 on ct_login ( pg_acct );

-- -------------------------------------------------------- -- --------------------------------------------------------
drop view if exists ct_video_per_user ;
drop table if exists ct_video_seen ;
create table ct_video_seen (
	  user_id					char varying (40)  not null
	, video_id					char varying (40) not null
	, when_seen					timestamp not null
	, watch_count				int default 0 not null
);

-- -------------------------------------------------------- -- --------------------------------------------------------
drop table if exists ct_video ;
create table ct_video (
	  video_id					char varying (40) DEFAULT uuid_generate_v4() not null primary key
	, video_raw_file			text  not null
	, video_title				text  not null
	, url						text not null
	, img_url					text not null
	, lesson					jsonb not null	-- all the leson data from ./lesson/{video_id}.json, ./raw/{fn}
);

-- See:https://scalegrid.io/blog/using-jsonb-in-postgresql-how-to-effectively-store-index-json-data-in-postgresql/ 

create index ct_video_p1 on ct_video using gin ( lesson );

-- -------------------------------------------------------- -- --------------------------------------------------------
CREATE SEQUENCE ct_run_seq
	INCREMENT 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1;

-- -------------------------------------------------------- -- --------------------------------------------------------
drop table if exists ct_video_questions ;
create table ct_video_questions (
	  video_id				char varying (40) DEFAULT uuid_generate_v4() not null primary key
	, seq					bigint DEFAULT nextval('ct_run_seq'::regclass) NOT NULL 	-- ID for passing to client as a number
	, qdata					jsonb not null
	, pass					char (1) default 'n' not null check ( "pass" in ( 'y','n' ) )
);


-- -------------------------------------------------------- -- --------------------------------------------------------
drop table if exists ct_output ;
create table ct_output (
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
			  t1.video_id		
			, t1.video_raw_file	
			, t1.video_title
			, t1.url	
			, t1.img_url					
			, t1.lesson					
			, t2.when_seen
			, t2.watch_count
			, case			
				when t2.watch_count = 0 then 'n'
				when t2.watch_count is null then 'n'
				else 'y'
			  end as "has_been_seen"
		from ct_video as t1
			left outer join ct_video_seen as t2 on ( t1.video_id = t2.video_id )
;



-- -------------------------------------------------------- -- --------------------------------------------------------
-- Data
-- -------------------------------------------------------- -- --------------------------------------------------------

insert into ct_login ( username, password, pg_acct ) values	
	  ( 'abc', 'abc123', 'i4280v001' )
	, ( 'abd', 'abd123', 'i4280v002' )
;

insert into ct_video ( 
	  video_raw_file			-- text  not null
	, video_title				-- text  not null
	, url						-- text not null
	, img_url					-- text not null
	, lesson					-- jsonb not null	-- all the leson data from ./lesson/{video_id}.json, ./raw/{fn}
) values 
	  ( 'select_1.md', 'Intro to Select', 'select01.mp4', 'select01.jpg', '{"sample":1}' )
	, ( 'select_2.md', 'Select From', 'select02.mp4', 'select02.jpg', '{"sample":2}' )
;











-- -------------------------------------------------------- -- --------------------------------------------------------
-- Validation / Testing
-- -------------------------------------------------------- -- --------------------------------------------------------

CREATE or REPLACE FUNCTION ct_table_test ( p_p1 varchar, p_p2 varchar ) returns varchar AS $$
DECLARE
    l_junk char varying(40);
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
		RETURN 'PASS - no errors';
	ELSE	
		RETURN 'FAIL - errors = '|| l_n_err::text;
	END IF;
END;
$$ LANGUAGE plpgsql;

select ct_table_test ( '', '' );

select line from ct_output order by id;

