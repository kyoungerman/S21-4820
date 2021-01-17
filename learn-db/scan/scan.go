package scan

import (
	"bytes"
	"fmt"
	"os"
	"strings"

	"github.com/pschlump/MiscLib"
	"github.com/pschlump/godebug"
)

// seek peek to see if "create or replace function" or "create function" - if so go looking for '$$' in col1

func ScanPostgreSQLText(in string) (stmt_list []string, e_line_no int, e_msg string, err error) {
	var buffer bytes.Buffer
	var id_buf bytes.Buffer
	var id_list []string

	st := 0 // Start in 0 state

	line_no := 0
	e_line_no = 0
	if in == "" {
		return
	}
	pos := 0
	tok := ""
	ch := in[pos]
	pos++

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
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			case 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
				'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
				'_':
				st = 10
				buffer.WriteByte(ch)
				id_buf.WriteByte(ch)
				ch = in[pos]
				pos++
			case '\'':
				st = 20
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			case '"':
				st = 30
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			case '-':
				st = 40
				ch = in[pos]
				pos++
			case ';':
				stmt := strings.Trim(buffer.String(), " \t\n\r\f")
				if stmt != "" {
					if db0 {
						fmt.Printf("stmt ->%s<-\n", stmt)
					}
					stmt_list = append(stmt_list, stmt)
					id_list = make([]string, 0, 50)
				}
				buffer.Reset()
				ch = in[pos]
				canAs = true
				pos++
			default:
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			}

		// -------------------------------------------------------------------
		case 10: // scan across ID - not quoted
			switch ch {
			case '\n': // end of ID
				line_no++
				st = 0
				id := strings.Trim(id_buf.String(), " \t\n\r\f") // end of id - check now
				id_buf.Reset()
				id_list = append(id_list, id)
				if isAsBody(id_list) {
					id_list = make([]string, 0, 50)
					if db2 {
						fmt.Printf("%sisAsBody is true... %s\n", MiscLib.ColorCyan, MiscLib.ColorReset)
					}
					st = 60
				}
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			case 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
				'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
				'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '_':
				// st = 10 -- current state
				id_buf.WriteByte(ch)
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			case ';': // end of ID
				st = 0
				id := strings.Trim(id_buf.String(), " \t\n\r\f") // end of id - check now
				id_buf.Reset()
				id_list = append(id_list, id)
				if isAsBody(id_list) {
					id_list = make([]string, 0, 50)
					if db2 {
						fmt.Printf("%sisAsBody is true... %s\n", MiscLib.ColorCyan, MiscLib.ColorReset)
					}
					st = 60
				}
				stmt := strings.Trim(buffer.String(), " \t\n\r\f")
				if stmt != "" {
					if db0 {
						fmt.Printf("stmt ->%s<-\n", stmt)
					}
					stmt_list = append(stmt_list, stmt)
					id_list = make([]string, 0, 50)
				}
				buffer.Reset()
				ch = in[pos]
				canAs = true
				pos++
			default: // end of ID
				st = 0
				id := strings.Trim(id_buf.String(), " \t\n\r\f") // end of id - check now
				id_list = append(id_list, id)
				id_buf.Reset()
				if isAsBody(id_list) {
					id_list = make([]string, 0, 50)
					if db2 {
						fmt.Printf("%sisAsBody is true... %s\n", MiscLib.ColorCyan, MiscLib.ColorReset)
					}
					st = 60
				}
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
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			case '\'':
				st = 20
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			case ';': // end of ID
				st = 0
				id := strings.Trim(id_buf.String(), " \t\n\r\f") // end of id - check now
				id_buf.Reset()
				id_list = append(id_list, id)
				if isAsBody(id_list) {
					id_list = make([]string, 0, 50)
					if db2 {
						fmt.Printf("%sisAsBody is true... %s\n", MiscLib.ColorCyan, MiscLib.ColorReset)
					}
					st = 60
				}
				stmt := strings.Trim(buffer.String(), " \t\n\r\f")
				if stmt != "" {
					if db0 {
						fmt.Printf("stmt ->%s<-\n", stmt)
					}
					stmt_list = append(stmt_list, stmt)
					id_list = make([]string, 0, 50)
				}
				buffer.Reset()
				ch = in[pos]
				canAs = true
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
			case '"':
				st = 30
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			case ';': // end of ID
				st = 0
				id := strings.Trim(id_buf.String(), " \t\n\r\f") // end of id - check now
				id_buf.Reset()
				id_list = append(id_list, id)
				if isAsBody(id_list) {
					id_list = make([]string, 0, 50)
					if db2 {
						fmt.Printf("%sisAsBody is true... %s\n", MiscLib.ColorCyan, MiscLib.ColorReset)
					}
					st = 60
				}
				stmt := strings.Trim(buffer.String(), " \t\n\r\f")
				if stmt != "" {
					if db0 {
						fmt.Printf("stmt ->%s<-\n", stmt)
					}
					stmt_list = append(stmt_list, stmt)
					id_list = make([]string, 0, 50)
				}
				buffer.Reset()
				ch = in[pos]
				canAs = true
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
		case 60: // -- ID Token to quote body of store procedure
			switch ch {
			case ' ', '\t', '\f', '\r':
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			case '\n':
				line_no++
				ch = in[pos]
				pos++
			case '$':
				st = 61
				buffer.WriteByte(ch)
				id_buf.WriteByte(ch)
				ch = in[pos]
				pos++
			case '-':
				st = 70
				ch = in[pos]
				pos++
			default:
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			}
		case 61:
			switch ch {
			case '\n':
				buffer.WriteByte(ch)
				id_buf.WriteByte(ch)
				line_no++
				ch = in[pos]
				pos++
			case '$':
				st = 62
				buffer.WriteByte(ch)
				id_buf.WriteByte(ch)
				tok = id_buf.String()
				id_buf.Reset()
				ch = in[pos]
				pos++
			case '-':
				st = 70
				ch = in[pos]
				pos++
			default:
				buffer.WriteByte(ch)
				id_buf.WriteByte(ch)
				ch = in[pos]
				pos++
			}
		case 62:
			switch ch {
			case '\n':
				buffer.WriteByte(ch)
				line_no++
				ch = in[pos]
				pos++
			case '$':
				st = 63
				buffer.WriteByte(ch)
				id_buf.WriteByte(ch)
				ch = in[pos]
				pos++
			default:
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			}
		case 63:
			switch ch {
			case '\n':
				buffer.WriteByte(ch)
				id_buf.WriteByte(ch)
				line_no++
				ch = in[pos]
				pos++
			case '$':
				buffer.WriteByte(ch)
				id_buf.WriteByte(ch)
				tokEnd := id_buf.String()
				id_buf.Reset()
				if tokEnd == tok {
					st = 0
				}
				ch = in[pos]
				pos++
			case '-':
				st = 70
				ch = in[pos]
				pos++
			default:
				buffer.WriteByte(ch)
				id_buf.WriteByte(ch)
				ch = in[pos]
				pos++
			}

		// -------------------------------------------------------------------
		case 70: // -- comment start
			switch ch {
			case '\n':
				line_no++
				st = 60
				buffer.WriteByte('-')
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			case '-':
				st = 71
				ch = in[pos]
				pos++
			default:
				st = 60
				buffer.WriteByte('-')
				buffer.WriteByte(ch)
				ch = in[pos]
				pos++
			}
		case 71: // -- comment start
			switch ch {
			case '\n':
				line_no++
				st = 60
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

	// process end of stuff at this point based on state!
	stmt := strings.Trim(buffer.String(), " \t\n\r\f")
	if stmt != "" {
		if db0 {
			fmt.Printf("stmt ->%s<-\n", stmt)
		}
		stmt_list = append(stmt_list, stmt)
		id_list = make([]string, 0, 50)
	}
	buffer.Reset()

	return

}

var canAs = true

func isAsBody(id_list []string) bool {
	if db2 {
		fmt.Printf("%sWords are: %s%s\n", MiscLib.ColorCyan, godebug.SVar(id_list), MiscLib.ColorReset)
	}
	if len(id_list) > 0 && strings.ToLower(id_list[len(id_list)-1]) == "select" {
		canAs = false
		return false
	}
	if !canAs {
		return false
	}
	if len(id_list) > 0 && strings.ToLower(id_list[len(id_list)-1]) == "as" {
		if len(id_list) > 2 && strings.ToLower(id_list[len(id_list)-3]) == "view" {
			if db2 {
				fmt.Printf("%sview %s\n", MiscLib.ColorYellow, MiscLib.ColorReset)
			}
			return false
		}
		if db2 {
			fmt.Printf("%sReturn True!%s\n", MiscLib.ColorYellow, MiscLib.ColorReset)
		}
		return true
	}
	return false
}

var db0 = false
var db1 = false
var db2 = false
