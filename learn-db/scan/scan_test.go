package scan

import (
	"fmt"
	"testing"

	"github.com/pschlump/godebug"
)

func Test_SplitIntoStmt(t *testing.T) {
	tests := []struct {
		run      bool
		strIn    string
		expected []string
	}{
		{
			run: true,
			strIn: `
drop table abc;
`,
			expected: []string{
				"drop table abc",
			},
		},
		{
			run: true,
			strIn: `
drop table abc;
create table abc ( n int );   
select 12 from abc;  
`,
			expected: []string{
				"drop table abc",
				"create table abc ( n int )",
				"select 12 from abc",
			},
		},
	}

	for ii, test := range tests {
		if test.run {

			// func ScanPostgreSQLText(in string) (stmt_list []string, e_line_no int, e_msg string, err error) {
			rv, e_line_no, e_msg, err := ScanPostgreSQLText(test.strIn)

			fmt.Printf("e_line_no = %d e_mst = %s err = %s\n", e_line_no, e_msg, err)

			if len(rv) != len(test.expected) {
				t.Errorf("Test %d Length Mismatch: Exptect(%d) %s\n Got(%d) %s\n", ii, len(test.expected), godebug.SVarI(test.expected), len(rv), godebug.SVarI(rv))
			} else {
				for jj := 0; jj < len(test.expected); jj++ {
					if test.expected[jj] != rv[jj] {
						t.Errorf("Test %d Mismatch at %d: Exptect %s\nGot      %s\n", ii, jj, godebug.SVarI(test.expected), godebug.SVarI(rv))
					}
				}
			}
		}
	}
}
