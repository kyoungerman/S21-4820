---------------------------------------
--This file creates all of the tables--
---------------------------------------

DROP TABLE IF EXISTS i_note CASCADE;
DROP TABLE IF EXISTS i_issue CASCADE;
DROP TABLE IF EXISTS i_state;
DROP TABLE IF EXISTS i_severity;
DROP TABLE IF EXISTS i_config;



CREATE EXTENSION if not exists "uuid-ossp";

------Create tables------
CREATE TABLE i_config (
    id serial PRIMARY KEY NOT NULL,
    name text,
    value text
);

CREATE TABLE i_state (
    id serial PRIMARY KEY NOT NULL,
    state text
);

CREATE TABLE i_severity (
    id serial PRIMARY KEY NOT NULL,
    severity text
);

CREATE TABLE i_issue (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    title text,
    body text,
    state_id int NOT NULL,
    severity_id int NOT NULL,
    words tsvector,
    updated timestamp,
    created timestamp
);

CREATE TABLE i_note (
    id uuid DEFAULT uuid_generate_v4() PRIMARY KEY NOT NULL,
    title text,
    body text,
    issue_id uuid NOT NULL,
    seq serial,
    words tsvector,
    updated timestamp,
    created timestamp
);

drop view if exists i_issue_st_sv;

create or replace view i_issue_st_sv as
select 
	t1.id
	, t1.title
	, t1.body
	, t2.state	
	, t1.state_id
	, t3.severity
	, t1.severity_id
	, t1.updated
	, t1.created
	, t1.words
from i_issue as t1
	join i_state as t2 on ( t2.id = t1.state_id )
	join i_severity as t3 on ( t3.id = t1.severity_id )
order by t1.severity_id desc, t1.updated desc, t1.created desc	
;

drop view if exists i_issue_note;

create or replace view i_issue_note as
select 
	t1.id
	, t1.title
	, t1.body	
	, t1.state_id
	, t1.severity_id
	, t1.updated
	, t1.created
	, t1.words
    , t2.id as note_id
    , t2.title as note_title
    , t2.body as note_body
    , t2.issue_id
from i_issue as t1
	join i_note as t2 on ( t2.issue_id = t1.id )
order by t2.seq desc
;


