package scan

import (
	"bytes"
	"fmt"
	"os"
	"strings"
)

func ScanPostgreSQLText(in string) (stmt_list []string, e_line_no int, e_msg string, err error) {
	// Initialize return Values
	// e_line_no = 0
	// e_msg = ""
	// err = nil
	// stmt_list = make([]string, 0, 50)
	var buffer bytes.Buffer
	/*
		for i := 0; i < 1000; i++ {
			buffer.WriteString("a")
		}

		fmt.Println(buffer.String())
	*/

	st := 0 // Start in 0 state

	line_no := 0
	e_line_no = 0
	if in == "" {
		return
	}
	pos := 0
	bs := 0 // must use buffer and write to it
	_ = bs

	ch := in[pos]
	pos++
	id_st := 0
	id := ""

	for pos < len(in) {
		if db1 {
			fmt.Printf("pos=%d st=%d ch=->%c<-%02x ->%s<-\n", pos, st, ch, ch, in[pos:])
		}
		switch st {
		case 0: // beginning text
			switch ch {
			case ' ', '\t', '\f', '\r':
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			case '\n':
				line_no++
				ch = in[pos]
				pos++
			case 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
				'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
				'_':
				st = 10
				id_st = pos
				buffer.WriteByte(ch)
				bs = pos
				ch = in[pos]
				pos++
			case '\'':
				st = 20
				buffer.WriteByte(ch)
				id_st = pos
				ch = in[pos]
				pos++
			case '"':
				st = 30
				buffer.WriteByte(ch)
				id_st = pos
				ch = in[pos]
				pos++
			case '-':
				st = 40
				id_st = pos
				ch = in[pos]
				pos++
			case ';':
				id_st = pos
				stmt := strings.Trim(buffer.String(), " \t")
				if stmt != "" {
					if db0 {
						fmt.Printf("stmt ->%s<-\n", stmt)
					}
					stmt_list = append(stmt_list, stmt)
				}
				buffer.Reset()
				ch = in[pos]
				pos++
				bs = pos
			default:
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			}

		// -------------------------------------------------------------------
		case 10: // scan across ID - not quoted
			switch ch {
			case '\n':
				line_no++
				st = 0
				id = in[id_st:pos]
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			case 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
				'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
				'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '_':
				st = 10
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			case ';':
				st = 0
				id_st = pos
				stmt := strings.Trim(buffer.String(), " \t")
				if stmt != "" {
					if db0 {
						fmt.Printf("stmt ->%s<-\n", stmt)
					}
					stmt_list = append(stmt_list, stmt)
				}
				buffer.Reset()
				ch = in[pos]
				pos++
			default: // end of ID
				st = 0
				id = in[id_st:pos]
				// xyzzy - sneed peek to see if "create or replace function" or "create function" - if so go looking for '$$' in col1
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			}

		// -------------------------------------------------------------------
		case 20: // 'text'
			switch ch {
			case '\n':
				line_no++
				st = 0
				id = in[id_st:pos]
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			case '\'':
				st = 21
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			default: // end of ID
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			}
		case 21: // 'text'
			switch ch {
			case '\n':
				line_no++
				st = 0
				id = in[id_st : pos-1]
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			case '\'':
				st = 20
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			default: // end of ID
				st = 0
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			}

		// -------------------------------------------------------------------
		case 30: // "text"
			switch ch {
			case '\n':
				line_no++
				st = 0
				id = in[id_st:pos]
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			case '"':
				st = 31
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			default: // end of ID
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			}
		case 31: // 'text'
			switch ch {
			case '\n':
				line_no++
				st = 0
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
				id = in[id_st : pos-1]
			case '"':
				st = 30
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			default: // end of ID
				st = 0
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			}

		// -------------------------------------------------------------------
		case 40: // -- comment start
			switch ch {
			case '\n':
				line_no++
				st = 0
				buffer.WriteByte('-')
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			case '-':
				st = 41
				ch = in[pos]
				pos++
			default:
				st = 0
				buffer.WriteByte('-')
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			}
		case 41: // -- comment start
			switch ch {
			case '\n':
				line_no++
				st = 0
				ch = in[pos]
				pos++
			default:
				ch = in[pos]
				pos++
			}

		// -------------------------------------------------------------------
		default:
			fmt.Fprintf(os.Stderr, "Invalid state - setting back to 0\n")
			st = 0
		}
	}

	if false {
		fmt.Printf("id=%s\n", id)
	}
	// process end of stuff at this point based on state!
	stmt := strings.Trim(buffer.String(), " \t")
	if stmt != "" {
		if db0 {
			fmt.Printf("stmt ->%s<-\n", stmt)
		}
		stmt_list = append(stmt_list, stmt)
	}
	buffer.Reset()

	return

}

var db0 = false
var db1 = false
