
-- -------------------------------------------------------- -- --------------------------------------------------------
-- Note the "auth_token" is the "ID" for this row. (Primnary Key)
-- -------------------------------------------------------- -- --------------------------------------------------------

drop TABLE if exists "t_ymux_auth_token" ;
CREATE TABLE "t_ymux_auth_token" (
	  "id"					uuid DEFAULT uuid_generate_v4() not null primary key
	, "user_id"				uuid not null
	, "updated" 			timestamp
	, "created" 			timestamp default current_timestamp not null
);
COMMENT ON TABLE "t_ymux_auth_token" IS 'version: b14871d878aa2f9fbaa35f4ad2c6c2baf9584c06 tag: v0.1.9 build_date: Fri Dec 11 14:30:43 MST 2020';

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
	-- version: b14871d878aa2f9fbaa35f4ad2c6c2baf9584c06 tag: v0.1.9 build_date: Fri Dec 11 14:30:43 MST 2020
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER t_ymux_auth_token_trig
BEFORE update ON "t_ymux_auth_token"
FOR EACH ROW
EXECUTE PROCEDURE t_ymux_auth_token_upd();
