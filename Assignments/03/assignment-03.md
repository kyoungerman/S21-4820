





<style>
.pagebreak { page-break-before: always; }
.half { height: 200px; }
</style>





4820 - Assignment 03 - Key Word Search
===========================================================================================================================


Pts: 200

Due Mar 18th


Some very fancy tools like ElstaSearch and Lucine are for key word search.  They are very expensive.
PostgreSQL provides a decent key word search facility.
                      
In this assignment you will take your data from Assignment 02 and add the ability to do a key word 
search on it.

These tables are very much like Assignment 02, with some extra columns added.

You are inserting into these tables:

```

DROP TABLE if exists a03_title_to_tag cascade ;
DROP TABLE if exists a03_title cascade ;
DROP TABLE if exists a03_tags cascade ;

CREATE TABLE a03_title (
	id 				uuid DEFAULT uuid_generate_v4() not null primary key,
	title 			text not null,
	body 			text not null,
	words			tsvector,
	updated 		timestamp,
	created 		timestamp default current_timestamp not null
);

CREATE INDEX a03_title_p1 ON a03_title (created);  
CREATE INDEX a03_title_tsv_g1 ON a03_title USING GIN (words);  

CREATE TABLE a03_title_to_tag (
	id uuid DEFAULT uuid_generate_v4() not null primary key,
	title_id uuid not null,
	tag_id uuid not null
);

CREATE UNIQUE INDEX a03_title_to_tag_u1 on a03_title_to_tag ( title_id, tag_id );
CREATE UNIQUE INDEX a03_title_to_tag_u2 on a03_title_to_tag ( tag_id, title_id );

CREATE TABLE a03_tags (
	id uuid DEFAULT uuid_generate_v4() not null primary key,
	tag text
);

CREATE UNIQUE INDEX a03_tags_p1 on a03_tags ( tag );


ALTER TABLE a03_title_to_tag 
	ADD CONSTRAINT a03_title_id_fk1
	FOREIGN KEY (title_id)
	REFERENCES a03_title (id)
;
ALTER TABLE a03_title_to_tag 
	ADD CONSTRAINT a03_tag_id_fk2
	FOREIGN KEY (tag_id)
	REFERENCES a03_tags (id)
;



```

Create the tables in your system.  Write a script that will delete all the data from the tables so 
when your insert's don't work you can cleanup and start over.  (Save the delete script and turn it in also).

Write a script to copy the data from Assignment 02 into your new tables.  These should be SQL
statements of the form `insert into a03_title ( id, body, title) select id, body, title from a02_title;`
They will need to be in the correct order so that your foreign key constraints are met.

```
$ psql
pschlump=# \i cleanup-a03.sql
pschlump=# \i load-data-from-a02.sql
...
psqhlump=# \q
```

and load the data.


## Outline

1. Look at interactive homework 38 - it has details on using `tsvector`.

2. Create a trigger on insert and update that will populate the `words` column in `a03_title` with weighted results from both the title and from the body.
Assume that you are using the `english` language.  For `title` git it a 'A' weight, for body give it a `B` weight.

3. Create a trigger that on update will set the `updated` field to the current time stamp.

4. Create a select statement that search for the tag `trigger` and searches for the word `configuration`.  What interactive homework has both this tag and this word. 
Select the title of the interactive homework that matches this criteria.




Turn In
-------------------

1. Your copy script.
2. Your cleanup script
3. Your triggers. (1 or 2 files)
4. Your queries on the word and tag.  The output from running your query.




Copyright (C) University of Wyoming, 2021.

