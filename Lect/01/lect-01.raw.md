
m4_include(../lect-setup.m4)

# Lecture 01 - Intro to Class

# The Slowest Sort Of All Time

Performant matters!  Cost Matters!

Let me tell you about a super-slow sort.
If correctness was the only criteria then super-slow would be just as
good as any other sort.

## Syllabus

m4_include(../../sylabus-core.m4.md)

## What are databases

There are a number of different kinds of databases.

1. SQL - this is what we will spend a large portion of the semester on.
2. NoSQL - The most popular is MongoDB - we will look at it a little.
3. Redis - Shared Data Structure
4. File System, Amazon S3, and IPFS
5. Object Store
6. Blockchain

Most applications need some sort of persistent data.  This is most often
stored in a database.

Usually a database class starts out with the database and that's it - you
don't get any context of where it all fits in.   That is not how we are going
to do it.   We are going to start out with an application and burro down into
where the database fits into the bigger picture.  By doing that we are 
going to see that just a SQL database is usually not a complete solution.


