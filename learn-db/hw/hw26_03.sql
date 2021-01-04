CREATE SEQUENCE t_log_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

DROP TABLE if exists "t_ymux_user_log" ;

CREATE TABLE "t_ymux_user_log" (
	  "id"					uuid DEFAULT uuid_generate_v4() not null primary key
	, "user_id"				uuid 	-- if null then a failed event
	, "seq"	 				bigint DEFAULT nextval('t_log_seq'::regclass) NOT NULL 
	, "activity_name"		text
	, "updated" 			timestamp
	, "created" 			timestamp default current_timestamp not null
);
COMMENT ON TABLE "t_ymux_user_log" IS 'version: b14871d878aa2f9fbaa35f4ad2c6c2baf9584c06 tag: v0.1.9 build_date: Fri Dec 11 14:30:43 MST 2020';

create index "t_ymux_user_log_p1" on "t_ymux_user_log" ( "user_id", "seq" );
create index "t_ymux_user_log_p2" on "t_ymux_user_log" ( "user_id", "created" );

ALTER TABLE "t_ymux_user_log"
	ADD CONSTRAINT "t_ymux_user_log_user_id_fk1"
	FOREIGN KEY ("user_id")
	REFERENCES "t_ymux_user" ("id")
;

CREATE OR REPLACE function t_ymux_user_log_upd()
RETURNS trigger AS $$
BEGIN
	-- version: b14871d878aa2f9fbaa35f4ad2c6c2baf9584c06 tag: v0.1.9 build_date: Fri Dec 11 14:30:43 MST 2020
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER t_ymux_user_log_trig
BEFORE update ON "t_ymux_user_log"
FOR EACH ROW
EXECUTE PROCEDURE t_ymux_user_log_upd();
