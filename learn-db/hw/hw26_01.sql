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
	, "rfc_6238_secret"		text -- if not null then this supports auth with RFC 6238 hmac/hash time based 2fa.
	, "recovery_token" 		text
	, "recovery_expire" 	timestamp
	, "parent_user_id"		uuid
	, "org_user_id"			uuid
	, "auth_token"			text -- if this is an auth-token based device login
	, "acct_expire" 		timestamp
	, "updated" 			timestamp
	, "created" 			timestamp default current_timestamp not null
);
COMMENT ON TABLE "t_ymux_user" IS 'version: m4_ver_version() tag: m4_ver_tag() build_date: m4_ver_date()';


create unique index "t_ymux_user_u1" on "t_ymux_user" ( "username" );
create index "t_ymux_user_p1" on "t_ymux_user" ( "email" );
create unique index "t_ymux_user_u3" on "t_ymux_user" ( "recovery_token" );
create index "t_ymux_user_p2" on "t_ymux_user" ( "created", "setup_2fa_complete" );
create index "t_ymux_user_p3" on "t_ymux_user" ( "created", "email_confirmed" );




CREATE OR REPLACE function t_ymux_user_upd()
RETURNS trigger AS $$
BEGIN
	-- version: b14871d878aa2f9fbaa35f4ad2c6c2baf9584c06 tag: v0.1.9 build_date: Fri Dec 11 14:30:43 MST 2020
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER t_ymux_user_trig
BEFORE update ON "t_ymux_user"
FOR EACH ROW
EXECUTE PROCEDURE t_ymux_user_upd();
