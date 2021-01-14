DROP TABLE if exists ct_login ;

CREATE TABLE ct_login (
	  user_id					uuid not null primary key -- 1 to 1 to "t_ymux_user"."id"
	, pg_acct					char varying (20) not null
	, class_no					text default '4010-BC' not null	-- 4280 or 4010-BC - one of 2 classes
	, lang_to_use				text default 'Go' not null		-- Go or PostgreSQL
	, misc						JSONb default '{}' not null		-- Whatever I forgot
);

create unique index ct_login_u1 on ct_login ( pg_acct );
create index ct_login_p1 on ct_login using gin ( misc );

ALTER TABLE ct_login
	ADD CONSTRAINT ct_login_user_id_fk
	FOREIGN KEY (user_id)
	REFERENCES "t_ymux_user" ("id")
;
