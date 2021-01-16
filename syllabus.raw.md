
<style>
.pagebreak { page-break-before: always; }
.half { height: 200px; }
</style>

# Syllabus: University of Wyoming Computer Science 4280 Database 

## Spring 2021

- Instructor: Prof. Philip Schlump
- Office: Office hours will be online using Zoom. M,W,F from 8:00am to 9:00am and by appointment.  The Zoom link to join will be emailed out to the class.
- Contact via email (pschlump@uwyo.edu) or (for emergencies only): 720-209-7888 (my cell)
and pschlump@gmail.com (personal email).
- Class Time:  Lectures are online and pre-recorded. 

If you call me to set up an appointment, you will need to send me a SMS message
first so that I enter your name into my contact list.  I get 10+ robo-calls a day and
I will not answer a random number.  Text me with your name and that you are a student
in 4280 class.

### Overview

Database is one of the code technologies behind most applications.
That makes this a very important class.

The class will have a set of pre-recorded lectures.  These are available
for both download and from YouTube.

There will be a set of Interactive Homework.  Each of these has a sort
video, text and an interactive box for doing the work.  The first 2 videos
are critical as they show how to use the tool and how to get your grade
for these assignments.

There are 5 Interactive discussions.  These are required.  They will be
on zoom.  Choose a time of day to attend.  They will be held at 3 different
times a day - so you only need to attend one of the 3 on that a day.
Each of the synchronous zoom discussions will be at 9:00am, 3:00pm and
6:00pm on a Monday.  If you are unable to make one of the times let me
know and I will find a time.  These will be about 45 minutes long.

There will be  8 assignments.  The number of points varies.  Assignment 3 and 4
are a single project broken into 2 parts.  You have to complete 3 to do 4.

There will be a midterm and a final.   They will be online.

### Lectures

m4_define([[[m4_comment]]],[[[]]])
m4_comment([[[
    January 2021      
Su Mo Tu We Th Fr Sa  
17 18 19 20 21 22 23  
			^-------------- 1st day of clsss
24 25 26 27 28 29 30  
31                  

   February 2021      2
Su Mo Tu We Th Fr Sa  
    1  2  3  4  5  6  
 7  8  9 10 11 12 13  
14 15 16 17 18 19 20  
21 22 23 24 25 26 27  
28                    
    
     March 2021       3
Su Mo Tu We Th Fr Sa  
    1  2  3  4  5  6  
 7  8  9 10 11 12 13  
          ^--------------------- Midterm
14 15 16 17 18 19 20  
21 22 23 24 25 26 27  
28 29 30 31           
      
     April 2021       4
Su Mo Tu We Th Fr Sa  
             1  2  3  
 4  5  6  7  8  9 10  
11 12 13 14 15 16 17  
18 19 20 21 22 23 24  
25 26 27 28 29 30     
                      
      May 2021        5
Su Mo Tu We Th Fr Sa  
                   1  
 2  3  4  5  6  7  8  
 9 10 11 12 13 14 15  
16 17 18 19 20 21 22  
23 24 25 26 27 28 29  
30 31                 
]]])

| Lecture                                                                    | Week | Date    |
|----------------------------------------------------------------------------|:----:|:--------|
|  1. Syllabus -- Class Requirements                                         |   1  | Jan 21  |
|  	- Interactive Homework                                                   |   1  | Jan 21  |
|  	- Assignments                                                            |      |         |
|  	- Interactive Discussions (zoom)                                         |      |         |
|  	- Tests                                                                  |      |         |
|                                                                            |      |         |  
|  2. Why Database                                                           |   2  | Jan 25  |
|  3. Installing PostgreSQL and other tools (Assignment 1)                   |   2  | Jan 25  | 
|  	- PostgreSQL                                                             |      |         |
|  	- Python                                                                 |      |         |
|  	- bottle                                                                 |      |         |
|  	- python libraries                                                       |      |         |
|  	- JavaScript (jQuery)                                                    |      |         |
|  	- style sheets and fonts (Bootstrap)                                     |      |         |
|                                                                            |      |         |  
|  4. My Database Background                                                 |   3  | Feb 1   |
|  5. How applications work today                                            |   3  | Feb 1   |
|                                                                            |      |         |  
|  6. Future of Database                                                     |   4  | Feb 7   |
|  7. Global Variables Considered Harmful                                    |   4  | Feb 7   |
|                                                                            |      |         |  
|  8. Jobs In Database                                                       |   5  | Feb 14  |
|  9. ERD and Modeling                                                       |   5  | Feb 14  |
|                                                                            |      |         |  
|  10. Data Modeling ( Entity Relationship Model )                           |   6  | Feb 21  |
|  11. ACID compliance and history of database                               |   6  | Feb 21  |
|                                                                            |      |         |  
|  12. The Rise of NoSQL - MongoDB (MongoDB v.s. PostgreSQL JSONb data type) |   7  | Feb 28  |
|  13. F1 a world scale database                                             |   7  | Feb 28  |
|                                                                            |      |         |  
|  14. Midterm Review                                                        |   8  | Mar 1   |
|  15. Practical NoSQL - Redis                                               |   8  | Mar 1   |
|                                                                            |      |         |  
|  16. Hash Based Databases v.s. SqLite                                      |   9  | Mar 7   |
|  17. Scaling SQL                                                           |   9  | Mar 7   |
|                                                                            |      |         |  
|  18. Testing with Database                                                 |  10  | Mar 14  |
|  19. Blockchain as a Database                                              |  10  | Mar 14  |
|                                                                            |      |         |  
|  20. Data Growth                                                           |  11  | Mar 21  |
|  21. PostGIS - Geographic Information System                               |  11  | Mar 21  |
|                                                                            |      |         |  
|  22. MongoDB / NoSQL                                                       |  12  | Mar 28  |
|  23. PostGIS - Geographic Information System                               |  12  | Mar 28  |
|                                                                            |      |         |  
|  24. Column stores like Cassandra                                          |  13  | Apr  5  |
|                                                                            |      |         |  
|  25. Time-series databases, InfluxDB                                       |  14  | Apr 12  |
|  26. Timescale - the PosgreSQL Time Series Database                        |  14  | Apr 12  |
|                                                                            |      |         |  
|  26. Performance Tuning SQL (1)                                            |  15  | Apr 19  |
|  27. Performance Tuning SQL (2)                                            |  15  | Apr 19  |
|                                                                            |      |         |  
|  28. Conclusions / Final Review                                            |  16  | Apr 26  |



### Class Interactive Discussions

1. Application Supply Chain - Feb 15
2. Security - Feb 22
3. Backup and the Law - Mar 8
4. Future of Database - Mar 15
5. SQL or NoSQL - Mar 29




### Interactive Homework

The interactive tool is at [https://easy-2c-why.com/](https://easy-2c-why.com/) . You should have
received and email with this location and your login and password to tool.
The Interactive is 255 of your semester grade.   The tool is not tied directly to
the UW Canvas system so I will have a "Interactive Homework" assignment that is the
cumulative number of points for this set of work.

### Homework on your computer

You will need to install and use a number of database tools on your computer.
If you are using a Microsoft Surface that is not x86 based this may be difficult to
impossible to do.   In that case get a free AWS EC3 instance or a $5.00 a month
Linode and load the database and other tools on that and run them remotely.

### Grading

| Points      | Percentage  | Grade |
|-------------|-------------|-------|
| 2000...1800 | 100% to 90% | A     |
| 1800...1600 |  90% to 80% | B     |
| 1600...1400 |  80% to 70% | C     |
| 1400...1200 |  70% to 60% | D     |
| 1200...0    |   below 60% | F     |

### Assignments.

1000pts total.


| Assignments    | Pts  | Description                                | Due Date   | Duration |
|----------------|-----:|--------------------------------------------|------------|---------:|
| 01 - Install   |   50 | Install PosgreSQL, Redis, Python, pgAdmin  | 2021-02-15 | 2 weeks  |
| 02 - Insert    |  200 | Parse text / generate data                 | 2021-03-01 | 2 weeks  |
| 03 - Keyword   |  200 | Key World Search                           | 2021-03-22 | 2 weeks  |
| 04 - App       |  300 | Issue Tracking Application                 | 2021-03-29 | 3 weeks  |
| 05 - Data dump |   50 | Use pgdump to dump data                    | 2021-04-05 | 1 weeks  |
| 06 - Backup    |   50 | Use tar to backup entire database          | 2021-04-12 | 1 weeks  |
| 07 - Remote    |   50 | Setup database security                    | 2021-04-26 | 1 weeks  |
| 08 - Tune SQL  |  100 | Find and Tune SQL                          | 2021-05-07 | 1+ weeks  |
|                |      |                                            |            |          |
| Total          | 1000 |                                            |            | 11 weeks |




1000 pts - Assignments
 500 pts - Interactive Homework
 500 pts - 2 tests (midterm, final) Midterm Date: 2021-03-10 Final Date: 2021-05-11

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


### Tests (Midterm, Final)

2 tests each worth 250 points.

Midterm will be due on March 19.  You will have about a week to
do it.  It will be online.

Final will available on May 6th and due on the last day of finals, May 14.


### Tools

PostgreSQL:

PgAdmin:

Redis:

Python 3.8 - Anaconda: https://www.anaconda.com/products/individual


### Extra credit

No extra credit is planned at this time.

### Required texts

The interactive homework lists sections of the book.  The textbook book is required.


## Office Hours 

Online: Office hours are online - you can make an appointment but I will be online in Zoom
Monday, Wednesday, Friday from 8:00am till 9:00am.  Additional office hours will be
announced.


### Late work.

Generally it is a good idea to get the homework done on time.   Normally I take 10% off for each
week day that a homework is late until it is worth only 40% of the original points.  The last day
for turning in homework is Dec 12.  

### Original work policy (in this class).

Homework is turned in online via file upload.   The homework is really, really important.  Do your own 
work.  That is how you learn.  If you use google or other web sources, then note where you got the
code or answer from.  If you copy from the web, then expect that on a one-on-one basis I will be asking
you how the code works.   Help each other.  It is legitimate in this class, (it may not be in other 
classes), for you to help your fellow student.   If you do then note it in your code.  Code is very
unique to each person.  If two of you turn in the same code - that is very bad.  If you note that
you worked on it together - and then I ask each of you to explain how it works - that's alright.
If you have questions about this email me.

                         

### Title IX – Duty to Report
 
The University of Wyoming faculty are committed to helping create a safe learning environment for all students and for
the university as a whole. If you have experienced any form of gender or sex-based discrimination or harassment,
including sexual assault, sexual harassment, relationship violence, or stalking, know that help and support are
available. The University has staff members trained to support survivors in navigating campus life, accessing health and
counseling services, providing academic and housing accommodations, and more. The University strongly encourages all
students to report any such incidents to the University. Please be aware that all University of Wyoming employees,
including student staff, are required to report all Title IX related concerns to the Title IX Coordinator or their
supervisor. This means that if you tell a faculty member about a situation of sexual harassment or sexual violence, or
other related misconduct, the faculty member must share that information with the University’s Title IX Coordinator.
UW’s Title IX Coordinator is Jim Osborn (Manager of Investigations, Equal Opportunity Report and Response). He is
located in Room 320 of the Bureau of Mines Building, and can be reached via email at report-it@uwyo.edu or via phone at
766-5200 or 766-5228. For more information, go to:
[http://www.uwyo.edu/reportit/learn-more/faqs.html](http://www.uwyo.edu/reportit/learn-more/faqs.html) .

### Attendance and Absence policies

You have to watch the lectures.  This class has prerecorded lectures 
that you are expected to watch/listen to.   This is your "required" attendance.

### SARS-Cov-2 / COVID-19 Related Policies 

During this pandemic, you must abide by all UW policies and public health rules
put forward by the City of Laramie (or by Natrona County if at UW-Casper), the University of Wyoming
and the State of Wyoming to promote the health and well-being of fellow students and your own personal
self-care. Please review our current policy.
As with other disruptive behaviors, we have the right to dismiss you from the classroom (Zoom and
physical), or other class activities if you fail to abide by these COVID-19 policies. These behaviors will
be referred to the Dean of Students Office using the UWYO Cares Reporting Form for Student Code of
Conduct processes.

### Syllabus Changes

I will alert you to any possible course format changes in response to UW decisions
about community safety during the semester.

## Classroom Behavior Policy

(This section is not really applicable to this class - we will have class discussions that this applies to)

At all times, treat your presence in the classroom and your enrollment in this course as you would a job. Act
professionally, arrive on time, pay attention, complete your work in a timely and professional manner. You will be
respectful towards your classmates and instructor. Spirited debate and disagreement are to be expected in any classroom
and all views will be heard fully, but at all times we will behave civilly and with respect towards one another.
Personal attacks, offensive language, name-calling, and dismissive gestures are not warranted in a learning atmosphere.
As the instructor, I have the right to dismiss you from the classroom.

## Classroom Statement on Diversity

The University of Wyoming values an educational environment that is diverse, equitable, and inclusive. The diversity
that students and faculty bring to class, including age, country of origin, culture, disability, economic class,
ethnicity, gender identity, immigration status, linguistic, political affiliation, race, religion, sexual orientation,
veteran status, worldview, and other social and cultural diversity is valued, respected, and considered a resource for
learning. 

## Disability Support

If you have a physical, learning, sensory or psychological disability and require accommodations, please register as
soon as possible and provide documentation of your disability to Disability Support Services (DSS), Room 109 Knight
Hall. You may also contact DSS at (307) 766-3073 or udss@uwyo.edu. Visit their website for more
information: www.uwyo.edu/udss

## Academic Dishonesty Policies

Don't cheat on the exams. I expect you to take full advantage of all the online resources you can get your hands on.
That includes Stack Overflow, Github etc. If you do use someone else's code, put in a link to where you found it.
Don't cheat on the projects - do you own work.  Most of the learning in the class is from *doing* the projects.

## Substantive changes to syllabus

All deadlines, requirements, and course structure are subject to change if deemed necessary by the instructor. Students
will be notified verbally in class, on our WyoCourses page announcement, and via email of these changes. I do travel
during the semester. Class could be canceled or assignments due dates changed.

# Copyright

Copyright (C) University of Wyoming, 2021.



<div class="pagebreak"> </div>

m4_comment([[[

https://stackoverflow.blog/2021/01/14/have-the-tables-turned-on-nosql/

	Indexed document stores like MongoDB
	Graph databases like Neo4j
	Column stores like Cassandra
	Time-series databases, which index data by time stamps, like InfluxDB. 
	Hybrid forms that use multiple of the previous paradigms

https://www.digitalocean.com/community/tutorials/how-to-install-postgresql-on-ubuntu-20-04-quickstart

]]])
