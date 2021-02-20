

m4_include(../../Lect/lect-setup.m4)



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
m4_include(assignment-03.sql)
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

