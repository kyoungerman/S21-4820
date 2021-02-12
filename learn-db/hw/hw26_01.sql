CREATE EXTENSION if not exists "uuid-ossp";
CREATE EXTENSION if not exists pgcrypto;

DROP TABLE if exists "t_ymux_user" cascade ;

CREATE TABLE "t_ymux_user" (
	  "id"					uuid DEFAULT uuid_generate_v4() not null primary key
	, "username" 			text
	, "password" 			text
	, "realm" 				text
	, "real_name" 			text
	, "salt" 				text
	, "email" 				text
	, "email_confirmed" 	char varying (1) default 'n' not null
	, "setup_2fa_complete" 	char varying (1) default 'n' not null
	, "rfc_6238_secret"		text 
	, "recovery_token" 		text
	, "recovery_expire" 	timestamp
	, "parent_user_id"		uuid
	, "org_user_id"			uuid
	, "auth_token"			text 
	, "acct_expire" 		timestamp
	, "updated" 			timestamp
	, "created" 			timestamp default current_timestamp not null
);


create unique index "t_ymux_user_u1" on "t_ymux_user" ( "username" );
create index "t_ymux_user_p1" on "t_ymux_user" ( "email" );
create unique index "t_ymux_user_u3" on "t_ymux_user" ( "recovery_token" );
create index "t_ymux_user_p2" on "t_ymux_user" ( "created", "setup_2fa_complete" );
create index "t_ymux_user_p3" on "t_ymux_user" ( "created", "email_confirmed" );




CREATE OR REPLACE function t_ymux_user_upd()
RETURNS trigger AS $$
BEGIN 
	NEW.updated := current_timestamp; 
	RETURN NEW; 
END 
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER t_ymux_user_trig
	BEFORE update ON "t_ymux_user"
	FOR EACH ROW
	EXECUTE PROCEDURE t_ymux_user_upd();
