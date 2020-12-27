package main

import (
	"bufio"
	"encoding/csv"
	"fmt"
	"io"
	"log"
	"os"
	"strings"

	"gitlab.com/pschlump/PureImaginationServer/ymux"
)

var fns = []string{
	"hw01.raw.md",
	"hw02.raw.md",
	"hw03.raw.md",
	"hw04.raw.md",
	"hw05.raw.md",
	"hw06.raw.md",
	"hw07.raw.md",
	"hw08.raw.md",
	"hw09.raw.md",
	"hw10.raw.md",
	"hw11.raw.md",
	"hw12.raw.md",
	"hw13.raw.md",
	"hw14.raw.md",
	"hw15.raw.md",
	"hw16.raw.md",
	"hw17.raw.md",
	"hw18.raw.md",
	"hw19.raw.md",
	"hw20.raw.md",
	"hw21.raw.md",
	"hw22.raw.md",
	"hw23.raw.md",
	"hw24.raw.md",
	"hw25.raw.md",
	"hw26.raw.md",
	"hw27.raw.md",
	"hw28.raw.md",
	"hw29.raw.md",
}

func main() {
	for _, fn := range fns {
		readFile(fn)
	}
	if db3 {
		for key, val := range tag_to_uuid {
			fmt.Printf("-- Tag %s %s\n", key, val)
		}
	}
}

var tag_to_uuid = make(map[string]string)

func readFile(fn string) {
	file, err := os.Open(fn)
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	line_no := 0
	u1 := ymux.GenUUID()
	for scanner.Scan() {
		line_no++
		line := scanner.Text()
		if db1 {
			fmt.Printf("%5d:%s\n", line_no, line)
		}
		if strings.HasPrefix(line, "# Inter") {
			fmt.Printf("-- title: %5d:%s\n", line_no, line)
			title := line[1:]
			no := fn[2:4]
			fmt.Printf("insert into ct_homework ( homework_id, homework_title, homework_no, video_url, video_img, lesson_body ) values ( '%s', '%s', '%s', '%s', '%s', '%s' );\n",
				u1,                          // UUID
				sqlEncode(title),            // Title
				no,                          // homework number
				fmt.Sprintf("hw%s.mp4", no), // video_url
				fmt.Sprintf("hw%s.jpg", no), // video_img
				"{}",                        // TODO
			)
		} else if strings.HasPrefix(line, "#### Tags:") {
			fmt.Printf("-- tag  : %5d:%s\n", line_no, line)
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
		}
	}

	if err := scanner.Err(); err != nil {
		log.Fatalf("File:%s Error:%s\n", fn, err)
	}
}

func getTags(line string) (tag_list []string) {
	// #### Tags: "hw02" "insert"
	tag_str := line[11:]
	if db2 {
		fmt.Printf("-- Tag str ->%s<- \n", tag_str)
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
