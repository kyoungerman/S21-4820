
# Assignment 04 - Using a database.

Storing data in a database for the sake of storing it in a database is not much fun.
Let's actually use this set of database skills to build something.

Let's build an issue tracker.   Issues are what you have when something is wrong in
some set of stofware.  They could be anything from miss spelling 'stofware' instead
of 'software' to annoying things like 'it makes the computer crash' to really horrible things like 'it kills people'.   These are
the defects.  There are commercial defect tracking systems like JIRA that are multi-million
dollar a year businesses.   We will build some features that JIRA is missing.

I will give you the front end - web pages and what they expect.
Our issue tracker is simplified - it has no user accounts (Accounts and login stuff is
actually very complicated).   Also a real tracker would include file upload.  File upload
requires special work on the server side - so we will leave that out.

The nifty features that it will have.

1. Search based on words.  This is taking Assignment 03 - Key word search and applying it.
2. Ability to have a dashboard of issues.
3. Ability to attache notes to issues.
4. A severity and a frequency of issues.

In this assignment you get to take the ERD for the model and implement the tables for it
and then implement the server that uses SELECTs, UPDATEs, DELETEs and INSERTs to
connect this model to an outside application.

The application server is in Python using the `bottle` package for handing web
requests.

The ERD is in `./assignment-04.erd.pdf`.   First take the ERD and build the tables, constraints and
triggers for the model.

The sample server is in `./a04-server.py`.  There will be a set of videos detaling adding an
endpoint to the server and how that works.

First - the 1st line in the file `#!/usr/bin/python3` is for Mac and Linux.  You man need to change
that if you are running on Windows.   On a Mac or Linux system a `#!` at the beginning of a script tells
the shell how to run the script.  The rest of the line is the path to an executable that this file will
be passed to.  In this case it is passed to `/usr/bin/python3`.   You will note that the 2nd line in
the file is my install of Anaconda Python.    Find the location of your python and change this 
to have the correct location for your python.

You can find the location of an excitable with

```
$ which python3
```

Second - Normally script files need to be executable (this is Mac and Linux again) to run.
If you do `ls -l a04-server.py` and it has

```
-rwxr-xr-x  1 philip  staff  18042 Feb 20 19:53 a04-server.py
```

something with  `-rwx` at the beginning then the executable bit is set.   That is the `x`.
If it has `-rw-` then it is not set as an executable.  To set the `x` so that yo can run it
you need to use the `chmod` program.

```
$ chmod +x a04-server.py
```

Now you need some environment variable set to be able to connect in the code.  It is not
a good idea to hard code usernames and passwords into programs.   Very often this information
is moved into environment variables.  (Amazon Web Services, AWS, has all of its coding examples
work this way!)

If you look in the file `./database.ini` there are configuration items to allow the python code
to connect to your database.

```
m4_include(database.ini)
```

m4_comment([[[

[postgresql]
host=127.0.0.1
database=ENV$DATABASE
user=ENV$DBUSER
password=ENV$PGPASSWORD
]]])

These items are, `host=` - this is the IP address of the host.  Under the assumption that you 
are running this on your Linux virtual machine then the IP address of the local machine, 127.0.0.1
is probably correct.

The other items start with an `ENV$`.  The python code will see this and then use the 2nd part to
pull this from the environment.   In my case I set and export these values.

```
$ export DATABASE=pschlump
$ export DBUSER=pschlump
$ export PGPASSWORD=not-going-to-tell-you-this
```

In the shell you can set local variables with just `NAME=Value`.  To make that into an environment
variable you use `export`.  This is true on Mac and Linux shells.   On Windows you have to go 
into some system configuration and find it and set it.  If you are doing this on windows
let me know and we will walk through the ugly details.

Now you can test this by running the python code that reads in and creates the connection to the database.



