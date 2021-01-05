









-- "Copyright (C) Philip Schlump, 2016."












drop TABLE if exists "ct_user" ;
CREATE TABLE "ct_user" (
	  "id"					uuid DEFAULT uuid_generate_v4() not null primary key
	, "username" 			text
	, "password" 			text
	, "real_name" 			text
	, "salt" 				text
	, "email" 				text
	, "email_confirmed" 	char varying (1) default 'n' not null
	, "recovery_token" 		text
	, "recovery_expire" 	timestamp
	, "default_image" 		text
	, "default_title" 		text
	, "updated" 			timestamp
	, "created" 			timestamp default current_timestamp not null
);

create unique index "ct_user_u1" on "ct_user" ( "username" );
create index "ct_user_p1" on "ct_user" ( "email" );
create unique index "ct_user_u2" on "ct_user" ( "recovery_token" );

delete from "ct_user" where "username" in ( 'q8s.co:sa' );
insert into "ct_user" ( "id", "username", "password", "salt", "default_image", "default_title", "email", "email_confirmed" ) values
  ( 'c0b71df9-e258-49ec-b912-bf69ff31481b', 'q8s.co:sa',
	'97cca56f16244cd08e0083c43dc0a201b1b3d0b7aff980c714dbb1c9a85f6d3615ed774a8e47f95b7666c27b421971126717c781bd28883a97bad9907de38c7a',
	'3632343036333434', 'sa-60x60.png', 'Salvation Army', 'pschlump@gmail.com', 'y' )
;

drop TABLE if exists "t_registration_key" ;
CREATE TABLE "t_registration_key" (
	  "id"					uuid DEFAULT uuid_generate_v4() not null primary key
	, "key" 				text not null
	, "owner_id" 			text
);

create unique index "t_registration_key_u1" on "t_registration_key" ( "key" );




CREATE OR REPLACE function ct_user_upd()
RETURNS trigger AS 
$BODY$
BEGIN
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$BODY$
LANGUAGE 'plpgsql';


CREATE TRIGGER ct_user_trig
BEFORE update ON "ct_user"
FOR EACH ROW
EXECUTE PROCEDURE ct_user_upd();



delete from "ct_auth_token";
drop TABLE if exists "ct_auth_token" ;
CREATE TABLE "ct_auth_token" (
	  "id"					uuid DEFAULT uuid_generate_v4() not null primary key
	, "user_id"				uuid not null
	, "updated" 			timestamp
	, "created" 			timestamp default current_timestamp not null
);

create index "ct_auth_token_p1" on "ct_auth_token" ( "user_id" );



CREATE OR REPLACE function ct_auth_token_upd()
RETURNS trigger AS 
$BODY$
BEGIN
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$BODY$
LANGUAGE 'plpgsql';


CREATE TRIGGER ct_auth_token_trig
BEFORE update ON "ct_auth_token"
FOR EACH ROW
EXECUTE PROCEDURE ct_auth_token_upd();




delete from "ct_add_token";
drop TABLE if exists "ct_add_token" ;
CREATE TABLE "ct_add_token" (
	  "id"					uuid DEFAULT uuid_generate_v4() not null primary key
	, "user_id"				uuid not null
	, "token_type"			text			-- "device", "recovery", "temorary"
	, "sell_by_date"		timestamp		-- when token expires
	, "username"			text
	, "password"			text
	, "salt"				text
	, "description"			text			-- for device, what is the device/application
	, "auth_token"			text			-- derived token for token based authentication
	, "updated" 			timestamp
	, "created" 			timestamp default current_timestamp not null
);

create index "ct_add_token_p1" on "ct_add_token" ( "user_id" );



CREATE OR REPLACE function ct_add_token_upd()
RETURNS trigger AS 
$BODY$
BEGIN
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$BODY$
LANGUAGE 'plpgsql';


CREATE TRIGGER ct_add_token_trig
BEFORE update ON "ct_add_token"
FOR EACH ROW
EXECUTE PROCEDURE ct_add_token_upd();




