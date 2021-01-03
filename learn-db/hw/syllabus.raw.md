
# Syllabus: University of Wyoming Computer Science 4280 Database 

## Spring 2021

## Instructor: Prof. Philip Schlump


### Lectures

1. Syllabus -- Class Requirements
	- Interactive Homework
	- Assignments
	- Interactive Discussions (zoom)
	- Tests
2. Why Database
3. My Database Background
4. Future of Database
5. How applications work today
6. Jobs In Database
7. Installing PostgreSQL and other tools (Assignment 1)
	- PostgreSQL
	- Python
	- bottle
	- python libraries
	- JavaScript (jQuery)
	- style sheets and fonts (Bootstrap)
8. Global Variables Considered Harmful
9. Data Modeling
10. ACID compliance and history of database
11. The Rise of NoSQL - MongoDB (MongoDB v.s. PostgreSQL JSONb data type)
12. F1 a world scale database
13. Practical NoSQL - Redis
14. Scaling SQL
15. Hash Based Databases v.s. SqLite
16. Testing with Database
17. Blockchain as a Database
18. Data Growth
19. PostGIS - Geographic Information System
20. 

### Class Interactive Discussions

### Interactive Homework

### Homework on your computer

### Grading


#### Assignments.

1000pts total.

| Assignments    | Pts  | Description                                | Due Date   | Duration |
|----------------|-----:|--------------------------------------------|------------|---------:|
| 01 - Install   |   50 | Install PosgreSQL, Redis, Python, pgAdmin  | 2021-02-01 | 2 weeks  |
| 02 - Insert    |  200 | Parse text / generate data                 | 2021-02-15 | 2 weeks  |
| 03 - Keyword   |  200 | Key World Search                           | 2021-03-01 | 2 weeks  |
| 04 - App       |  300 | Issue Tracking Application                 | 2021-03-22 | 3 weeks  |
| 05 - Data dump |   50 | Use pgdump to dump data                    | 2021-03-29 | 1 weeks  |
| 06 - Backup    |   50 | Use tar to backup entire database          | 2021-04-05 | 1 weeks  |
| 07 - Remote    |   50 | Setup database security                    | 2021-04-12 | 1 weeks  |
| 08 - Tune SQL  |  100 | Find and Tune SQL                          | 2021-04-26 | 2 weeks  |
|                |      |                                            |            |          |
| Total          | 1000 |                                            |            | 11 weeks |




1000 pts - Assignments
 500 pts - Interactive Homework
 500 pts - 2 tests (midterm, final) Midterm: 2021-03-10 Final: 2021-05-11

2000 pts - total

50 Interactive (10pts each)
	10 per week = 4 weeks ( >>

| iHW Num. | Due Date   |
|----------|------------| 
| 01 .. 09 | 2021-02-01 |
| 10 .. 19 | 2021-02-08 |
| 20 .. 29 | 2021-02-15 |
| 30 .. 39 | 2021-02-22 |
| 40 .. 50 | 2021-03-08 |


                            2021
      January               February               March          
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  
                1  2      1  2  3  4  5  6      1  2  3  4  5  6  
 3  4  5  6  7  8  9   7  8  9 10 11 12 13   7  8  9 10 11 12 13  
10 11 12 13 14 15 16  14 15 16 17 18 19 20  14 15 16 17 18 19 20  
                                                            ^------------ Midterm
17 18 19 20 21 22 23  21 22 23 24 25 26 27  21 22 23 24 25 26 27  
			 ^----------------------------------------------------------- 1st day
24 25 26 27 28 29 30  28                    28 29 30 31           
31                                                                

       April                  May                   June          
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  
             1  2  3                     1         1  2  3  4  5  
 4  5  6  7  8  9 10   2  3  4  5  6  7  8   6  7  8  9 10 11 12  
                                ^---------------------------------------- Last Day
11 12 13 14 15 16 17   9 10 11 12 13 14 15  13 14 15 16 17 18 19  
18 19 20 21 22 23 24  16 17 18 19 20 21 22  20 21 22 23 24 25 26  
25 26 27 28 29 30     23 24 25 26 27 28 29  27 28 29 30           
                      30 31                                       


Hw 03 & 04 - 
	1. Model design (issue, note, work-state, severity)
	2. Tables
	3. Data	
	4. App w/ 1 page - provided	
		1. Create issue	
		2. Edit issue	
		3. Add/Update note
		- Examples of data
	5. Keyword Search for Issue/Note
	6. List if API end-points
		/api/get-config
		/api/search-keword

		/api/issue-list
		/api/create-issue
		/api/update-issue

		/api/add-note-to-issue
		/api/upd-note-to-issue
		/api/upd-severity
		/api/upd-state
	7. Tables
		issue
		note
		state (ref)
		severity (ref)

	1. Connect to d.b.
	2. Create tables	
	3. Mock end points
	4. Mock data for end points
	5. Front end (web pages)
	6. Demo front end with mocks (test)
	7. .sh test code for API (wget/curl)
	8. Test as a system
	
	Full Text Search Indexes: https://www.compose.com/articles/indexing-for-full-text-search-in-postgresql/ 
		https://www.compose.com/articles/mastering-postgresql-tools-full-text-search-and-phrase-search/	


