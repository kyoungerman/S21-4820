
CREATE EXTENSION if not exists "uuid-ossp";
CREATE EXTENSION if not exists pgcrypto;

DROP TABLE if exists a02_title_to_tag cascade ;
DROP TABLE if exists a02_title cascade ;
DROP TABLE if exists a02_tags cascade ;

CREATE TABLE a02_title (
	id uuid DEFAULT uuid_generate_v4() not null primary key,
	title text not null,
	body text not null
);

CREATE TABLE a02_title_to_tag (
	id uuid DEFAULT uuid_generate_v4() not null primary key,
	title_id uuid not null,
	tag_id uuid not null
);

CREATE UNIQUE INDEX a02_title_to_tag_u1 on a02_title_to_tag ( title_id, tag_id );
CREATE UNIQUE INDEX a02_title_to_tag_u2 on a02_title_to_tag ( tag_id, title_id );

CREATE TABLE a02_tags (
	id uuid DEFAULT uuid_generate_v4() not null primary key,
	tag text
);

CREATE UNIQUE INDEX a02_tags_p1 on a02_tags ( tag );


ALTER TABLE a02_title_to_tag 
	ADD CONSTRAINT a02_title_id_fk1
	FOREIGN KEY (title_id)
	REFERENCES a02_title (id)
;
ALTER TABLE a02_title_to_tag 
	ADD CONSTRAINT a02_tag_id_fk2
	FOREIGN KEY (tag_id)
	REFERENCES a02_tags (id)
;


