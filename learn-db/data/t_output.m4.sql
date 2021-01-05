
-- "Copyright (C) Philip Schlump, 2009-2017." 

m4_include(setup.m4)

-- -------------------------------------------------------- -- --------------------------------------------------------
CREATE SEQUENCE t_output_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;

-- -------------------------------------------------------- -- --------------------------------------------------------
drop table if exists "t_output" ;
create table "t_output" (
	  "seq"	 				bigint DEFAULT nextval('t_output_id_seq'::regclass) NOT NULL 
	, "output"				text
	, "created" 			timestamp default current_timestamp not null 						--
);
create index "t_output_p1" on "t_output" ( "created" );

-- -------------------------------------------------------- -- --------------------------------------------------------
drop table if exists "t_debug_flag" ;
create table "t_debug_flag" (
	  "id"					m4_uuid_type() DEFAULT uuid_generate_v4() not null primary key
	, "seq"	 				bigint DEFAULT nextval('t_output_id_seq'::regclass) NOT NULL 
	, "flag_name"			text
	, "created" 			timestamp default current_timestamp not null 						--
);
create unique index "t_debug_flag_u1" on "t_debug_flag" ( "flag_name" );

-- -------------------------------------------------------- -- --------------------------------------------------------
CREATE or REPLACE FUNCTION daily_cleanup( p_who_did_it varchar ) RETURNS varchar AS $$
BEGIN
	delete from "t_output" where "created" < current_timestamp - interval '1 day';
	delete from "t_debug_flag" where "created" < current_timestamp - interval '3 day';
	RETURN p_who_did_it;
END;
$$ LANGUAGE plpgsql;


-- -------------------------------------------------------- -- --------------------------------------------------------
insert into "t_debug_flag" ("flag_name") values
	( 's_register_immediate' )
;

-- -------------------------------------------------------- -- --------------------------------------------------------
-- Return true if flag is in the t_debug_flag table.
-- -------------------------------------------------------- -- --------------------------------------------------------
drop FUNCTION if exists s_debug_flag_enabled(p_flag_name varchar);

CREATE or REPLACE FUNCTION s_debug_flag_enabled(p_flag_name varchar)
	RETURNS boolean AS $$
DECLARE
	l_flag_on 	boolean;
	l_junk		varchar (1);
begin

	-- "Copyright (C) Philip Schlump, 2009-2017." 

	select 'y' 
		into l_junk
		from "t_debug_flag"
		where "flag_name" = p_flag_name
		;

	if not found then
		l_flag_on = false;
	else
		l_flag_on = true;
	end if;

	RETURN l_flag_on;
END;
$$ LANGUAGE plpgsql;

