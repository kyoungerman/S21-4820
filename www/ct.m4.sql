
m4_changequote(`[[[', `]]]')

-- -------------------------------------------------------- -- --------------------------------------------------------
create table ct_login (
	  user_id					char varying (40) DEFAULT uuid_generate_v4() not null primary key
	, username 					char varying(200) not null
	, password 					char varying(200) not null
);

-- -------------------------------------------------------- -- --------------------------------------------------------
create table ct_video_seen (
	  user_id					char varying (40)  not null
	, video_id					char varying (40) not null
	, when_seen					timestamp not null
);

-- -------------------------------------------------------- -- --------------------------------------------------------
create table ct_video (
	  video_id					char varying (40) DEFAULT uuid_generate_v4() not null primary key
	, url						text not null
	, img_url					text not null
	, title						text not null
	, lesson					jsonb not null
);

-- -------------------------------------------------------- -- --------------------------------------------------------
CREATE SEQUENCE ct_run_seq
	INCREMENT 1
	MINVALUE 1
	MAXVALUE 9223372036854775807
	START 1
	CACHE 1;

-- -------------------------------------------------------- -- --------------------------------------------------------
create table ct_video_questions (
	  video_id				char varying (40) DEFAULT uuid_generate_v4() not null primary key
	, seq					bigint DEFAULT nextval('ct_run_seq'::regclass) NOT NULL 	-- ID for passing to client as a number
	, qdata					jsonb not null
	, pass					char (1) default 'n' not null check ( "pass" in ( 'y','n' ) )
);

