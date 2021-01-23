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

var dest = "/home/pschlump/go/src/github.com/Univ-Wyo-Education/S21-4820/learn-db/www/files"

func main() {
	flag.Parse() // Parse CLI arguments to this, --cfg <name>.json

	fns := flag.Args()

	error_cnt := 0

	fmt.Printf("delete from ct_tag cascade;\n")
	fmt.Printf("delete from ct_homework_ans cascade;\n")
	fmt.Printf("delete from ct_homework cascade;\n")
	fmt.Printf("delete from ct_tag cascade;\n")
	fmt.Printf("delete from ct_file_list cascade;\n")
	fmt.Printf("delete from ct_val_homework cascade;\n")
	fmt.Printf("\n\n\n")

	for _, fn := range fns {
		n_err := readFile(fn)
		error_cnt += n_err
	}
	if error_cnt > 0 {
		fmt.Fprintf(os.Stderr, "%sFAIL - %d errors%s\n", MiscLib.ColorRed, error_cnt, MiscLib.ColorReset)
	} else {
		fmt.Printf("-- %sPASS%s\n", MiscLib.ColorGreen, MiscLib.ColorReset)
	}
	if db3 {
		for key, val := range tag_to_uuid {
			fmt.Printf("#-- Tag %s %s\n", key, val)
		}
	}
	fmt.Printf("\n\n\n")
	fmt.Printf("select grade_hw_migrate();\n")
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
			title = strings.TrimSpace(title)
			// title35 := title
			// titleRem := ""
			// if len(title) > 35 {
			title35, titleRem := WordSplit(title, 35)
			// }
			ioutil.WriteFile(
				fmt.Sprintf(`../www/img/hw%s.svg`, no),
				[]byte(fmt.Sprintf(`<?xml version='1.0' standalone='no'?>
<!DOCTYPE svg PUBLIC '-//W3C//DTD SVG 1.1//EN' 'http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd'>
<svg width='100%%' height='100%%' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink'>
	<!-- Copyright (C) University of Wyoming, 2021. -->

	<title>%s</title>

	<g id='columnGroup'>
		<rect x='1' y='1' width='1800' height='750' fill='white'/>

		<text x='30' y='30' font-size='64px' font-weight='bold' fill='brown'>
			<tspan x='30' dy='1.7em' font-size='84px' fill="gold">  University of Wyoming</tspan>
			<tspan x='80' dy='1em' fill="black">	4820 Computer Science</tspan>
			<tspan x='80' dy='1em' fill="black">	Introduction to Databse</tspan>
			<tspan x='80' dy='2em' fill="black">	%s</tspan>
			<tspan x='80' dy='1em' fill="black">	%s</tspan>
		</text>
	</g>
</svg>
`, title, title35, titleRem)), 0644)
			fmt.Printf("insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '%s', '%s', '%d', '%s', '%s', '%s' );\n",
				u1,                              // UUID
				sqlEncode(rmDoubleQuote(title)), // Title
				nno,                             // homework number
				fmt.Sprintf("hw%s.mp4", no),     // video_url
				fmt.Sprintf("hw%s.svg", no),     // video_img
				"{}",                            // See the Update Below (implemented via update)
			)
			body = append(body, line)
		} else if strings.HasPrefix(line, "#### Tags:") {
			if db4 {
				fmt.Printf("#-- tag  : %5d:%s\n", line_no, line)
			}
			for _, tag_word := range getTags(line, fn, line_no) {
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
			uX := getTags(line, fn, line_no)
			t1 := ymux.GenUUID()
			fmt.Printf("insert into ct_val_homework ( val_id, homework_no, val_type, val_data  ) values ( '%s', %d, '%s', '%s' );\n", t1, nno, sqlEncode(uX[0]), sqlEncode(uX[1]))
		} else if strings.HasPrefix(line, "#### FilesToRun:") {
			if db4 {
				fmt.Printf("#-- FilesToRun  : %5d:%s\n", line_no, line)
			}
			uX := getTags(line, fn, line_no)
			t1 := ymux.GenUUID()
			fmt.Printf("insert into ct_file_list ( file_list_id, homework_no, file_name ) values ( '%s', %d, '%s' );\n", t1, nno, sqlEncode(uX[0]))
			cpTo(uX[0], dest)
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
	buf, err := ioutil.ReadFile("tmp.html")
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
		fmt.Fprintf(os.Stderr, "File:%s Error:%s\n", fn, err)
		os.Exit(2)
	}
	return
}

func getTags(line, fn string, line_no int) (tag_list []string) {
	// #### Tags: "hw02" "insert"
	// #### Validate: SQL-Select,"select select setup_data_26()"
	// #### FilesToRun: hw26_01.sql
	if db6 {
		fmt.Fprintf(os.Stderr, "line >%s<\n", line)
	}
	s0 := strings.Split(line, ":")
	if db6 {
		fmt.Fprintf(os.Stderr, "s0 >%s<\n", s0)
	}
	if len(s0) > 1 {
		tag_str := s0[1]
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
				fmt.Fprintf(os.Stderr, "Error: %s input->%s<- file:%s line:%d\n", err, record, fn, line_no)
			}

			tag_list = append(tag_list, record...)
		}
	}

	return
}

func sqlEncode(s string) (rv string) {
	rv = strings.Replace(s, "'", "''", -1)
	return
}

func rmDoubleQuote(s string) (rv string) {
	rv = strings.Replace(s, `"`, ``, -1)
	return
}

// cpTo ( uX[0], dest );
func cpTo(fn, dest string) {
	fmt.Fprintf(os.Stderr, "Processing: fn= ->%s<- dest= ->%s<-\n", fn, dest)
	dat, err := ioutil.ReadFile(fn)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to read ->%s<- %s\n", fn, err)
		return
	}
	dest = dest + "/" + fn
	err = ioutil.WriteFile(dest, dat, 0644)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Failed to write ->%s<- %s\n", fn, err)
		return
	}
}

func WordSplit(s string, atPos int) (first, rest string) {
	first = s
	rest = ""
	if len(s) > atPos {
		ch := s[atPos]
		ii := atPos
		for ch != ' ' && ii > 1 {
			ii--
			ch = s[ii]
		}
		first = s[0:ii]
		rest = s[ii:]
	}
	return
}

var db1 = false
var db2 = false
var db3 = false
var db4 = false
var db5 = false
var db6 = false
