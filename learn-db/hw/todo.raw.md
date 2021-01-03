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

# Homework 34 - Data Loading - generating SQL statements (Assignment 2)

# Interactive - 35 - views

# Interactive - 36 - stored procedures

# Interactive - 37 - encrypted/hashed passwords storage












ToDo
---------------------------------------------------------------------------------------------------------------


# Interactive - 38 - key word lookup
	Keyword Search tsvecor/tsearch
	- tsvector/tsearch

# Interactive - 39 - materialized views
	https://www.postgresql.org/docs/9.3/rules-materializedviews.html	






# Interactive - 40 - indexes on functions - soundex 

# Interactive - 41 - when - if condition in projected columns

# Interactive - 42 - foreign data wrapper

# Interactive - 43 - create rule
	https://www.postgresql.org/docs/9.2/sql-createrule.html	

# Interactive - 44 - NULL - differences between databases
	coalesce, nullif  (Oracle nvl)
	oracle "dual"
	# Interactive - 47 - null, NULL, case coalesce nullif
	See:https://www.postgresqltutorial.com/ 

# Interactive - 45 - date/time formats

# Interactive - 46 - window functions
	https://www.postgresql.org/docs/current/tutorial-window.html	

# Interactive - 47 - postgresql database maintance
	vacuum operation
	find unused indexes
	find slow queries
	find size of tables

# Interactive - 48 - NoSQL databases ( mongoDB ) v.s. JSONb in PostreSQL

# Interactive - 49 - More on JSONb









# Assignment 1 - Install stuff  
	- PostgreSQL	
	- psql	
	- create database	
	- pythnon
	- access d.b. from python
	- bottle





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

NULL Values


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
