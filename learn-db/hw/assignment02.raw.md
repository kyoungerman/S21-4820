
m4_include(setup.m4)

# Assignment 2 - Data Loading - generating SQL statements - easy with UUID's.

You will need to do this assignment on your computer using your install of PostgreSQL.

Turn in you source code and output files as uploads to the UW canvas  system.

200 Pts  - Assignment 2 in the canvas system.  Note that the interactive homework are worth 10pts.  So this is an important homework!

Write a program in Go, Python, C++ or C (or talk to me and use another language like Haskell, F#, Swift, Kotlan, node.js(JavaScript)  etc. (No Java!)) that will read in all the
`*.raw.md` files and pick out the 1st '# ' - main title and the `#### Tags: ` line
and generate the insert statements to create ct_homework, ct_tag, ct_tag_homework.

Input: the set of files to parse to get the data.


## Outline

1. In python 3.x get a sample program to run and generate a UUID.  This is the hello world for this assignment.  The sample code for this is included in this assignment. Test.  See that you get a unique UUID each time the program is run.
2. Develop code that will read in a file and parse for the title and the `#### Tags:` line.   Make this a function so that you can call it with all the files. Test.
3. Enter a list of the files into the code (read in list or hard-code list) so you can iterate over each file.  Test.
4. Generate insert statement for ct_homework from the title and other fields.  Parse the title to get the homework number.  Test.
5. Write some code that allows you to associate a keyword with a UUID.  In python this is a dictionary - easy.  Test it.
6. Write a little parser that takes the tags and returns an array or list of individual tags.  The format is a common-separated value and
there are libraries for parsing CSV data.  Examples are provided in each language of doing this.   See  csv.py.
You will need to split the line after the `#### Tags:` and remove any leading or taring blanks or tabs.  Then call the CSV parsing code to 
get back the set of tags.
7. Remember to quote strings that go into insert statements.   A single quote needs to be converted into a pair of single quotes in
strings.   The title of this homework has a quote mark in it.   Write a function that takes a string and SQL escapes it so that each
quote comes back as a pair of quote marks.   Test.
7. Combine into a single program that generates all the insert statments.  Test.  Load data and test.  Verify the syntax on your
insert statments.   Add "deletes" before the inserts so that you can run this over and over and it runs.
8. run it and turn in the appropriate files.  INCLUDE YOUR NAME in your source code as a comment - Required if you want to get points
for the homework.



## Output

1. A file with insert statements that creates the data in the 3 tables.
2. A run of your answer to homework 29 on your data.


## Turn In

1. your source code
2. your insert statements (output from your program)
3. the psql output from homework 29 -- xyzzy?????


## Grading

I am going to run your .sql output and verify that you got the correct data.  100pts

I am going to compile and run your code and verify that your code generates the correct data. 100pts.

I am going to read your code, in detail. This is a code review.  If the code has errors or dubious construes in it I will send it back to you for revision. 100pts.
This means that you should have meaningful comments.  This also means that you should have a set of automated tests for the functions in your code
that demonstrate that each of the functions works.


## Code Examples

### Python  Generate UUID

File: test1.py

```
m4_include(test1.py)

```

### Python  Get Command Line Arguments and Print

### Python  Open and read a file

### Python  Parse through the liens of a file

### Python  Open a file for output and write to it


