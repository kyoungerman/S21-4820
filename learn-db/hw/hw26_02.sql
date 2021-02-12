
-- -------------------------------------------------------- -- --------------------------------------------------------
-- Note the "auth_token" is the "ID" for this row. (Primnary Key)
-- -------------------------------------------------------- -- --------------------------------------------------------

drop TABLE if exists "t_ymux_auth_token" cascade ;

CREATE TABLE "t_ymux_auth_token" (
	  "id"					uuid DEFAULT uuid_generate_v4() not null primary key
	, "user_id"				uuid not null
	, "updated" 			timestamp
	, "created" 			timestamp default current_timestamp not null
);

create index "t_ymux_auth_token_p1" on "t_ymux_auth_token" ( "user_id" );
create index "t_ymux_auth_token_p2" on "t_ymux_auth_token" ( "created" );


ALTER TABLE "t_ymux_auth_token"
	ADD CONSTRAINT "t_ymux_auth_token_user_id_fk1"
	FOREIGN KEY ("user_id")
	REFERENCES "t_ymux_user" ("id")
;

CREATE OR REPLACE function t_ymux_auth_token_upd()
RETURNS trigger AS $$
BEGIN 
	NEW.updated := current_timestamp; 
	RETURN NEW; 
END 
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER t_ymux_auth_token_trig
	BEFORE update ON "t_ymux_auth_token"
	FOR EACH ROW
	EXECUTE PROCEDURE t_ymux_auth_token_upd();
