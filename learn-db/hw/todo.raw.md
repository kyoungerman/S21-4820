m4_include(setup.m4)

Done
==================

# Interactive - 01 - Create Table

# Interactive - 02 - Insert data into "name_list"

# Interactive - 03 - Select data back from the table

# Interactive - 04 - update the table

# Interactive - 05 - insert more data / select unique data

# Interactive - 06 - count(1) and where

# Interactive - 07 - add a check constraint on age

# Interactive - 08 - create unique id and a primary key 

# Interactive - 09 - add a table with state codes

# Interactive - 10 - add a index on the name table

# Interactive - 11 - add a index on the name table that is case insensitive.

# Interactive - 12 - fix our duplicate data

# Interactive - 13 - drop both tables

# Interactive - 14 - data types

# Interactive - 15 - select with group data of data

# Interactive - 16 - count matching rows in a select

# Interactive - 17 - select with join ( inner join, left outer join )

# Interactive - 18 - More joins (full joins)

# Interactive - 19 - select using sub-query and exists

# Interactive - 20 - delete with in based sub-query

# Interactive - 21 - select with union / minus

# Interactive - 22 - recursive select - populating existing tables 

# Interactive - 23 - with - pre-selects to do stuff.

# Interactive - 24 - truncate table

# Interactive - 25 - drop cascade 

# Interactive - 26 - 1 to 1 relationship  				(pk to pk)

# Interactive - 27 - 1 to 0 or 1 relationship 			(fk, unique)

# Interactive - 28 - 1 to n relationship				(fk)

# Interactive - 29 - m to n relationship				(fk to join table to fk)

# Interactive - 30 - 1 to ordered list relationship		(fk to uk with sequence)

# Interactive - 31 - only one row of data				(uk with no sequence)

# Interactive - 32 - only one a fixed set of rows.		(pre-papulae with key, pk, check-constraint on key)

# Interactive - 33 - types of indexes (hash, gin)

# Interactive - 34 - 

# Interactive - 35 - views

# Interactive - 36 - stored procedures

# Interactive - 37 - encrypted/hashed passwords storage

# Interactive - 38 - key word lookup

# Interactive - 39 - materialized views

# Interactive - 41 - case/when - if in projected columns

# Interactive - 42 - foreign data wrapper

# Interactive - 43 - indexes on functions - soundex 

# Interactive - 44 - alter table to add columns, remove columns

# Interactive - 45 - alter table to add constraint





# Interactive - 46 -  NULL - differences between databases
	coalesce, nullif  (Oracle nvl)
	oracle "dual"
	# Interactive - 47 - null, NULL, case coalesce nullif
	See:https://www.postgresqltutorial.com/ 




# Interactive - 47 - Rename Stuff - fix spelling errors
	ALTER TABLE venue RENAME COLUMN venueseats TO venuesize;	
	ALTER TABLE table_name RENAME TO new_table_name;	

	https://www.techonthenet.com/postgresql/tables/alter_table.php	






ToDo
---------------------------------------------------------------------------------------------------------------


# Interactive - 48 - window functions
	https://www.postgresql.org/docs/current/tutorial-window.html	

# Interactive - 49 - PostgreSQL database maintenance
	vacuum operation
	find unused indexes
	find slow queries
	find size of tables

# Interactive - 50 - NoSQL databases ( mongoDB ) v.s. JSONb in PostreSQL














40 - 30m
38 - 2h
39 - 20m
43 - 20m
44 - 20m
46 - 30m
47 - 30m += 4h
















# Assignment 1 - Install stuff  
	- PostgreSQL	
	- psql	
	- create database	
	- pythnon
	- access d.b. from python
	- bottle
# Assignment 2 - Data Loading - generating SQL statements (Assignment 2)

# Assignment 3 - Key World Search                           
	- load data from csv file
	- dump data to csv file

# Assignment 8 - performance turning - finding and fixing bad queries
	4. Copy CSV in
	5. Copy out to CSV
		\copy v.s. copy














Tool  / tool / TOOL
	1. Display select data	
	2. Button to describe tables/views
	3. List of tables	
	4. Button to run selected files - hw13_4.sql for example
	5. Score List - homework done/todo graded.
	6. List of files for homework.


User interface - determines set of things that are seen in database


# Other Topics

	1. Data Modeling and Design
		- non-crows foot model: PostgreSQL-Python-Sample-Database-Diagram.png
	2. NoSQL databases ( mongoDB ) v.s. JSONb in PostreSQL
	3. JSONb in PostreSQL and GIN indexes
	4. Spacial Data
	5. NoSQL - Redis and caching
	6. Blockchain as a Database
	7. Time Seeries Database
	8. Elastisearch (text reverse key)
	8. Volume of Data
	9. Performance
	10. Query Tuning
	11. Backup



create domain - validation of data w/ r.e. in a table.



50 interactive hw * 10pts = 500
5 assignments = 500
2 tests * 300 = 600
5 discussions * 100 = 500  
	+= 2000
50 more homeworks = 
	0. Add columns to table
	1. Install
	2. Configure Remote Login
	3. Dump
	4. Copy CSV in
	5. Copy out to CSV
	6. Make CSV in excel
	7. Create Soundex-like stored function `(*)`
	8. Calculate average of set	`(*)`
	9. Encrypt passwords `(*)`
	10. Add to application new API end point
	11. GIN index
	12. Search JSON data
	13. Backup database
	14. MongoDB ?
	14. Redis ?
	15. reverse key index GIST

	


https://www.postgresqltutorial.com/plpgsql-function-returns-a-table/

https://startupclass.samaltman.com/

https://dba.stackexchange.com/questions/173831/convert-right-side-of-join-of-many-to-many-into-array
https://heap.io/blog/engineering/postgresqls-powerful-new-join-type-lateral
https://popsql.com/learn-sql/postgresql/how-to-use-lateral-joins-in-postgresql

https://www.postgresqltutorial.com/postgresql-cube/

https://www.enterprisedb.com/postgres-tutorials/how-use-grouping-sets-cube-and-rollup-postgresql

https://www.compose.com/articles/deeper-into-postgres-9-5-new-group-by-options-for-aggregation/

HAVING

WITH
https://www.tutorialspoint.com/postgresql/postgresql_with_clause.htm

LIMIT

LIKE and ILIKE and 
regular expressions


COPY (SELECT * FROM tracks WHERE genre_id = 6) TO '/Users/dave/Downloads/blues_tracks.csv' DELIMITER ',' CSV HEADER;

Transactions:   See: https://www.postgresqltutorial.com/postgresql-transaction/ 

THIS ONE: https://www.tutorialspoint.com/postgresql/postgresql_with_clause.htm

Truncate Table

Where/Expressions

Select/Expressions




Notify trigger
	https://gist.github.com/colophonemes/9701b906c5be572a40a84b08f4d2fa4e
	- Use "create rule" with an extension to do WebRTC communication?


https://stackoverflow.com/questions/23906977/refresh-a-materialized-view-automatically-using-a-rule-or-notify
----------------------------------------------------------------------------------------------------------------------

		create or replace function refresh_mat_view()
		returns trigger language plpgsql
		as $$
		begin
			refresh materialized view mat_view;
			return null;
		end $$;

		create trigger refresh_mat_view
		after insert or update or delete or truncate
		on table1 for each statement 
		execute procedure refresh_mat_view();

		create trigger refresh_mat_view
		after insert or update or delete or truncate
		on table2 for each statement 
		execute procedure refresh_mat_view();




For Client-Side Export:

\copy [Table/Query] to '[Relative Path/filename.csv]' csv header
For Server-Side Export:

COPY [Table/Query] to '[Absolute Path/filename.csv]' csv header;
Example Absolute Path: ‘/Users/matt/Desktop/filename.csv’





use GIST for LIKE/ILIKE and RE searches on data-
--------------------------------------------------------------------------------------------------------------------

I'm testing out the PostgreSQL Text-Search features, using the September data dump from StackOverflow as sample data. :-)

The naive approach of using LIKE predicates or POSIX regular expression matching to search 1.2 million rows takes about 90-105 seconds (on my Macbook) to do a full table-scan searching for a keyword.

SELECT * FROM Posts WHERE body LIKE '%postgresql%';
SELECT * FROM Posts WHERE body ~ 'postgresql';
An unindexed, ad hoc text-search query takes about 8 minutes:

SELECT * FROM Posts WHERE to_tsvector(body) @@ to_tsquery('postgresql'); 
Creating a GIN index takes about 40 minutes:

ALTER TABLE Posts ADD COLUMN PostText TSVECTOR;
UPDATE Posts SET PostText = to_tsvector(body);
CREATE INDEX PostText_GIN ON Posts USING GIN(PostText);
(I realize I could also do this in one step by defining it as an expression index.)

Afterwards, a query assisted by a GIN index runs a lot faster -- this takes about 40 milliseconds:

SELECT * FROM Posts WHERE PostText @@ 'postgresql'; 
However, when I create a GiST index, the results are quite different. It takes less than 2 minutes to create the index:

CREATE INDEX PostText_GIN ON Posts USING GIST(PostText);
Afterwards, a query using the @@ text-search operator takes 90-100 seconds. So GiST indexes do improve an unindexed TS query from 8 minutes to 1.5 minutes. But that's no improvement over doing a full table-scan with LIKE. It's useless in a web programming environment.

Am I missing something crucial to using GiST indexes? Do the indexes need to be pre-cached in memory or something? I am using a plain PostgreSQL installation from MacPorts, with no tuning.

What is the recommended way to use GiST indexes? Or does everyone doing TS with PostgreSQL skip GiST indexes and use only GIN indexes?

PS: I do know about alternatives like Sphinx Search and Lucene. I'm just trying to learn about the features provided by PostgreSQL itself.

performance
postgresql
full-text-search
share  improve this question  follow 
asked Oct 8 '09 at 20:49

Bill Karwin
446k7777 gold badges595595 silver badges749749 bronze badges
add a comment
3 Answers

6

try

CREATE INDEX PostText_GIST ON Posts USING GIST(PostText varchar_pattern_ops);
which creates an index suitable for prefix queries. See the PostgreSQL docs on Operator Classes and Operator Families. The @@ operator is only sensible on term vectors; the GiST index (with varchar_pattern_ops) will give excellent results with LIKE.





Copy of entire databse
--------------------------------------------------------------------------------------------------------------------

To create a copy of a database, run the following command in psql:

CREATE DATABASE [Database to create]
WITH TEMPLATE [Database to copy]
OWNER [Your username];

	- pull data from different PG database
	- fdw for csv

	https://www.postgresql.org/docs/9.3/rules-materializedviews.html	

	Keyword Search tsvecor/tsearch
	- tsvector/tsearch
	https://www.compose.com/articles/mastering-postgresql-tools-full-text-search-and-phrase-search/	
	https://blog.lateral.io/2015/05/full-text-search-in-milliseconds-with-postgresql/	
		- uses gin index instead of gist
		- has query with rank/limit on results from using ranking - and how to get ranking.		---- Important !
	https://alibaba-cloud.medium.com/using-postgresql-to-create-an-efficient-search-engine-d0ab8e11b7	

