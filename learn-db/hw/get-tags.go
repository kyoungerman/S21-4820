package main

/*
take .md lines -> m4 -> hw04.md - convert .md -> .html, read .html - put into JSON
*/

// 1. change to take fns from CLI
// 2. add in
/*

4. Tool to go from .md file -> database + other stuff for lessons.

xyzzy100
#### Validate: 		10pts,SQL-Select-PASS,"select test_13_4()"
#### Validate: 		10pts,select-n-rows,"/validate/hw_12_2.json"

xyzzy101
###1 FilesToRun: 	./hw13_1.sql,"Cleanup in preparation for this interactive homework."
#### FilesToRun: 	./hw13_2.sql,"Some Title for Menu."
#### FilesToRun: 	./hw13_3.sql,"Some Other Title for Menu."
#### FilesToRun: 	./hw13_4.sql,"Create and populate the set of tables for this interactive homework."


/api/table/validate?hw=XX
	-> pts, cmd, how

/api/table/files_to_run?hw=XX
	-> file_name, desc

*/
// make file - auto edit - to have all hw??.raw.md files -> Makefile - or list below

import (
	"bufio"
	"encoding/csv"
	"flag"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"os/exec"
	"strconv"
	"strings"

	"github.com/pschlump/MiscLib"
	"github.com/pschlump/godebug"
	"gitlab.com/pschlump/PureImaginationServer/ymux"
)

func main() {
	flag.Parse() // Parse CLI arguments to this, --cfg <name>.json

	fns := flag.Args()

	error_cnt := 0

	for _, fn := range fns {
		n_err := readFile(fn)
		error_cnt += n_err
	}
	if error_cnt > 0 {
		fmt.Fprintf(os.Stderr, "%sFAIL - %d errors%s\n", MiscLib.ColorRed, error_cnt, MiscLib.ColorReset)
	} else {
		fmt.Printf("%sPASS%s\n", MiscLib.ColorGreen, MiscLib.ColorReset)
	}
	if db3 {
		for key, val := range tag_to_uuid {
			fmt.Printf("#-- Tag %s %s\n", key, val)
		}
	}
}

var tag_to_uuid = make(map[string]string)

func readFile(fn string) (n_err int) {
	file, err := os.Open(fn)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	line_no := 0
	body := make([]string, 0, 50)
	// body = append(body, "<pre class=\"m4-markdown\">") // xyzzy - temporary add of pre
	u1 := ymux.GenUUID()
	no := fn[2:4]
	nno, err := strconv.ParseInt(no, 10, 32)
	if err != nil {
		nno = 0
	}
	for scanner.Scan() {
		line_no++
		line := scanner.Text()
		if db1 {
			fmt.Printf("%5d:%s\n", line_no, line)
		}
		if strings.HasPrefix(line, "# Inter") {
			if db4 {
				fmt.Printf("-- title: %5d:%s\n", line_no, line)
			}
			title := line[1:]
			fmt.Printf("insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '%s', '%s', '%d', '%s', '%s', '%s' );\n",
				u1,                          // UUID
				sqlEncode(title),            // Title
				nno,                         // homework number
				fmt.Sprintf("hw%s.mp4", no), // video_url
				fmt.Sprintf("hw%s.jpg", no), // video_img
				"{}",                        // See the Update Below (implemented via update)
			)
			body = append(body, line)
		} else if strings.HasPrefix(line, "#### Tags:") {
			if db4 {
				fmt.Printf("#-- tag  : %5d:%s\n", line_no, line)
			}
			for _, tag_word := range getTags(line) {
				var t1 string
				var ok bool
				if t1, ok = tag_to_uuid[tag_word]; !ok {
					t1 = ymux.GenUUID()
					tag_to_uuid[tag_word] = t1
					fmt.Printf("insert into ct_tag ( tag_id, tag_word ) values ( '%s', '%s' );\n", t1, sqlEncode(tag_word))
				}
				fmt.Printf("insert into ct_tag_homework ( tag_id, homework_id ) values ( '%s', '%s' );\n", t1, u1)
			}
			body = append(body, line)
		} else if strings.HasPrefix(line, "#### Validate:") {
			if db4 {
				fmt.Printf("#-- validate  : %5d:%s\n", line_no, line)
			}
			uX := getTags(line)
			t1 := ymux.GenUUID()
			fmt.Printf("insert into ct_val_homework ( val_id, lesson_name, val_type, val_data  ) values ( '%s', %d, '%s', '%s' );\n", t1, nno, sqlEncode(uX[0]), sqlEncode(uX[1]))
		} else if strings.HasPrefix(line, "#### FilesToRun:") {
			if db4 {
				fmt.Printf("#-- FilesToRun  : %5d:%s\n", line_no, line)
			}
			uX := getTags(line)
			t1 := ymux.GenUUID()
			fmt.Printf("insert into ct_file_list ( file_list_uuid, lesson_name, file_name ) values ( '%s', %d, '%s' );\n", t1, nno, sqlEncode(uX[0]))
		} else if strings.HasPrefix(line, "#### ") {
			if db4 {
				fmt.Printf("Undefined Unusual Line ->%s<-\n", line)
			}
			body = append(body, line)
		} else {
			body = append(body, line)
		}
	}

	// body = append(body, "</pre>") // xyzzy - temporary add of pre

	body = append(body, "")

	type JSONBody struct {
		Lesson    string
		Lesson_no int
	}

	body_as_string := strings.Join(body, "\n")

	// --------------------------------------------------------------------
	// convert the M4 Markdown into HTML for placement into the lesson
	// --------------------------------------------------------------------

	err = ioutil.WriteFile("tmp.raw.md", []byte(body_as_string), 0644)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%sError on writing tmp.raw.md for `make runM4Markdown_to_HTML` file %s is: %s%s\n", MiscLib.ColorRed, fn, err, MiscLib.ColorReset)
		n_err++
	}
	cmd := exec.Command("make", "runM4Markdown_to_HTML")
	stdoutStderr, err := cmd.CombinedOutput()
	if err != nil {
		fmt.Printf("%s\n", stdoutStderr)
		fmt.Fprintf(os.Stderr, "%sError on running `make runM4Markdown_to_HTML` file %s is: %s%s\n", MiscLib.ColorRed, fn, err, MiscLib.ColorReset)
		n_err++
	}
	if db5 {
		fmt.Printf("%s\n", stdoutStderr)
	}
	buf, err := ioutil.ReadFile("tmp.md")
	if err != nil {
		fmt.Fprintf(os.Stderr, "%sError on reading tmp.md for `make runM4Markdown_to_HTML` file %s is: %s%s\n", MiscLib.ColorRed, fn, err, MiscLib.ColorReset)
		n_err++
	}
	sbuf := string(buf)

	if !strings.Contains(string(stdoutStderr), "PASS") {
		fmt.Fprintf(os.Stderr, "%sError on output from make for `make runM4Markdown_to_HTML`, missing PASS file %s ->%s<-%s\n", MiscLib.ColorYellow, fn, stdoutStderr, MiscLib.ColorReset)
		s := fmt.Sprintf("%sError on output from make for `make runM4Markdown_to_HTML`, missing PASS file %s ->%s<- %s\n", MiscLib.ColorYellow, fn, stdoutStderr, MiscLib.ColorReset)
		ioutil.WriteFile(",a", []byte(s), 0644)
		n_err++
	}

	// --------------------------------------------------------------------
	// Save data into struct to JSON-ify it .
	// --------------------------------------------------------------------
	jb := JSONBody{
		Lesson:    sbuf, // body_as_string,
		Lesson_no: int(nno),
	}

	// --------------------------------------------------------------------
	// Update lesson in d.b. with final data.
	// --------------------------------------------------------------------
	fmt.Printf("update ct_homework set lesson_body = '%s' where homework_id = '%s';\n\n\n", sqlEncode(godebug.SVar(jb)), u1)

	if err := scanner.Err(); err != nil {
		log.Fatalf("File:%s Error:%s\n", fn, err)
	}
	return
}

func getTags(line string) (tag_list []string) {
	// #### Tags: "hw02" "insert"
	tag_str := line[11:]
	if db2 {
		fmt.Printf("#-- Tag str ->%s<- \n", tag_str)
	}
	tag_str = strings.Trim(tag_str, " \t\r")

	r := csv.NewReader(strings.NewReader(tag_str))

	for {
		record, err := r.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			log.Fatal(err)
		}

		tag_list = append(tag_list, record...)
	}

	return
}

func sqlEncode(s string) (rv string) {
	rv = strings.Replace(s, "'", "''", -1)
	return
}

var db1 = false
var db2 = false
var db3 = false
var db4 = false
var db5 = false
