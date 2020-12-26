DROP TABLE if exists ct_homework cascade;

CREATE TABLE ct_homework (
	  homework_id				uuid DEFAULT uuid_generate_v4() not null primary key
	, homework_no				text not null
	, points_avail				int not null default 10
	, video_url					text not null
	, video_img					text not null
	, lesson_body 				JSONb not null 	-- body, html, text etc.
);

CREATE INDEX ct_homework_p1 on ct_homework ( homework_no );
