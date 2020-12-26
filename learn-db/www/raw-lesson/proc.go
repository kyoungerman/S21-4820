package main

import (
	"bufio"
	"fmt"
	"os"
	"regexp"
	"strings"

	"github.com/pschlump/MiscLib"
	"github.com/pschlump/godebug"
)

func main() {
	st := 0
	var title_raw string
	var desc, check_code []string
	var book_pages, video, call_to string

	ReadFileAsLines("l01.md", func(line, file_name string, line_no int) (err error) {
		if st == 0 && len(line) > 2 && line[0:2] == "# " {
			title_raw = line
			st = 1
		} else if st >= 1 && len(line) > 3 && line[0:3] == "## " && line == "## Description" {
			st = 2
		} else if st >= 1 && len(line) > 3 && line[0:3] == "## " && line == "## Book Section" {
			st = 3
		} else if st >= 1 && len(line) > 3 && line[0:3] == "## " && line == "## Video" {
			st = 4
		} else if st >= 1 && len(line) > 3 && line[0:3] == "## " && line == "## Validation" {
			st = 5
		} else {
			switch st {
			case 2, 8:
				if st == 2 {
					desc = append(desc, title_raw+"\n\n")
					st = 8
				}
				desc = append(desc, line+"\n")
				st = 8
			case 3:
				book_pages += line + "\n"
			case 4:
				if line != "" {
					video = line
				}
			case 5:
				if line != "" {
					call_to = line
					st = 6
				}
			case 6:
				check_code = append(check_code, line+"\n")
			}
		}
		fmt.Printf("st=%d ->%s<-\n", st, line)
		fmt.Printf("desc ->%s<-\n", desc)
		fmt.Printf("book_pages ->%s<-\n", book_pages)
		fmt.Printf("video ->%s<-\n", video)
		fmt.Printf("call_to ->%s<-\n", call_to)
		fmt.Printf("check_code ->%s<-\n", check_code)
		return
	})

	type jd struct {
		Title string
		Body  string
	}
	var jdata jd

	re := regexp.MustCompile(`# Lesson ([0-9]*) - (.*)`)
	fmt.Printf("%s%q%s\n", MiscLib.ColorYellow, re.FindSubmatch([]byte(title_raw)), MiscLib.ColorReset)
	parsed_title := re.FindSubmatch([]byte(title_raw))

	title := string(parsed_title[2])
	url_of_video := fmt.Sprintf("http://s3.xyzzy/l%s.mp4", parsed_title[1])

	jdata.Title = title
	fmt.Printf("title = %s%q%s\n", MiscLib.ColorYellow, title, MiscLib.ColorReset)
	jdata.Body = strings.Join(desc, "\n")
	lesson := godebug.SVarI(jdata)

	video_raw_file := fmt.Sprintf("l%s.mp4", parsed_title[1])
	lesson_name := fmt.Sprintf("l%s", parsed_title[1])
	url_of_img := fmt.Sprintf("/img/l%s.jpg", parsed_title[1])

	// Given "Lesson 01 - Create Table
	//
	//	  video_raw_file		- ./www/raw-lesson/l01.md
	//	, video_title			- "Create Table"
	//	, url
	//	, img_url
	//	, lesson				- Boddy of the .md file (Desc.) to .html
	//	, lesson_name			- l01

	fmt.Printf(`insert into ct_video (
		  video_raw_file		
		, video_title		
		, url			
		, img_url				
		, lesson			
		, lesson_name	
) values ( '%s', '%s', '%s', '%s', '%s', '%s')`,
		SQLEncode(video_raw_file), SQLEncode(title), SQLEncode(url_of_video),
		SQLEncode(url_of_img), SQLEncode(lesson), SQLEncode(lesson_name),
	)

}

func SQLEncode(s string) (rv string) {
	re := regexp.MustCompile(`'`)
	rv = string(re.ReplaceAll([]byte(s), []byte("''")))
	return
}

/*
create table ct_video (
	  video_id					char varying (40) DEFAULT uuid_generate_v4() not null primary key
	, video_raw_file			text  not null
	, video_title				text  not null
	, url						text not null
	, img_url					text not null
	, lesson					jsonb not null	-- all the leson data from ./lesson/{video_id}.json, ./raw/{fn}
	, lesson_name				text not null
 	, updated 		timestamp
 	, created 		timestamp default current_timestamp not null
);
*/

// Called for each line, takes the line, file_name and the current line number.  If err is not-nil, then quit reading and return.
type FileProcess func(line, file_name string, line_no int) (err error)

func ReadFileAsLines(filePath string, fx FileProcess) (err error) {

	// with the file...
	var fp *os.File

	if filePath == "-" {
		fp = os.Stdin
	} else {
		fp, err = os.Open(filePath)
		if err != nil {
			return err
		}
	}

	// ... for each line ...
	line_no := 0
	scanner := bufio.NewScanner(fp)
	for scanner.Scan() {
		line := scanner.Text() // no \n or \r\n on line - already chomped - os independent:w
		line_no++

		// process line
		err = fx(line, filePath, line_no)
		if err != nil {
			fp.Close()
			return
		}
	}
	if err = scanner.Err(); err != nil {
		fp.Close()
		return fmt.Errorf("Error scanning htpasswd file: %s", err.Error())
	}

	fp.Close()
	return
}

/*
# Lesson ## - <title>
## Description
## Book Section
## Video
## Validation

-------------------------------------------------------------------------------------------------

# Lesson 01 - Create table

## Description

One of the first things is creating a table.  Tables before you can store data in the database you have to define the structure of the data.
Tables are a set of rows, with a typed value for each column.
This is a table.

```
CREATE TABLE teachers (
	id 			serial not null PRIMARY KEY,
	first_naem 	text,
	last_name 	text not null,
	school 		varchar(50) not null,
	state 		varchar(2) not null
);
```

In this table we have a unique id.   It is a good practice to have a unique key for every row in a table.
You will save a lot of effort and frustration if you use generated unique keys.   Sometimes people think
that they can use a _natureal key_, some sort of data that forms a unique set of values.   In practice
this is almost never happens in the real world.  Things that do not make good keys:

- Name and address
- Address
- Name and Age
- Dates and times ( even down to the millionth of a second )

If you create a unique generated key it is unique - problem solved.  Encoding data in supposedly unique natural keys will almost always get you into trouble.

Create the table and then in the next lesson we will put some data in it.

Other Notes:

1. The example in the book uses `bigserial` - this data type has been dropped from PostgreSQL - all `serial` types are now the same as `bigserial`.
2. You can't have to put `CREATE TABLE` in all caps - this is just style.
3. We will use other data types (UUID) for keys also.
4. `not null` means that the value is required.
5. `PRIMARY KEY` tells it to create a unique index on the `id` field.
6. A unique key for a table is often called `id` or the table name followed with `_id`.  In this case `teachers_id`.
7. It is n ormal to see column names with `_` in them.
8. By default SQL is case insensitive.

Take the above code and create a table with it - both in this interactive environment and in your own install
of PostgreSQL.  We will use this table later with data in your local install of PosgreSQL.

## Book Section

page 5, 6, 7

## Video

l01.mp4

## Validation

checkL01

```
CREATE OR REPLACE FUNCTION checkL01() RETURNS character varying AS $BODY$
BEGIN
	-- look for the table in the schema
	-- verify the columns
	return 'PASS';
END;
$BODY$ LANGUAGE 'plpgsql';

```
*/
