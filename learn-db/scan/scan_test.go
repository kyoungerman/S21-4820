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
drop table abc
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
		{
			run: true,
			strIn: `

CREATE OR REPLACE function t_ymux_auth_token_upd()
RETURNS trigger AS $$
BEGIN
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$$ LANGUAGE 'plpgsql';

`,
			expected: []string{
				`CREATE OR REPLACE function t_ymux_auth_token_upd()
RETURNS trigger AS $$
BEGIN
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$$ LANGUAGE 'plpgsql'`,
			},
		},
		{
			run: true,
			strIn: `

-- -------------------------------------------------------- -- --------------------------------------------------------
-- Note the "auth_token" is the "ID" for this row. (Primnary Key)
-- -------------------------------------------------------- -- --------------------------------------------------------

drop TABLE if exists "t_ymux_auth_token" ;
CREATE TABLE "t_ymux_auth_token" (
	  "id"					uuid DEFAULT uuid_generate_v4() not null primary key
	, "user_id"				uuid not null
	, "updated" 			timestamp
	, "created" 			timestamp default current_timestamp not null
);

create index "t_ymux_auth_token_p1" on "t_ymux_auth_token" ( "user_id" );
create index "t_ymux_auth_token_p2" on "t_ymux_auth_token" ( "created" );


ALTER TABLE "t_ymux_auth_token"
	ADD CONSTRAINT "t_ymux_auth_token_user_id_fk1"
	FOREIGN KEY ("user_id")
	REFERENCES "t_ymux_user" ("id")
;

CREATE OR REPLACE function t_ymux_auth_token_upd()
RETURNS trigger AS $$
BEGIN
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$$ LANGUAGE 'plpgsql';


CREATE TRIGGER t_ymux_auth_token_trig
BEFORE update ON "t_ymux_auth_token"
FOR EACH ROW
EXECUTE PROCEDURE t_ymux_auth_token_upd();



`,
			expected: []string{
				`drop TABLE if exists "t_ymux_auth_token"`,
				`CREATE TABLE "t_ymux_auth_token" (
	  "id"					uuid DEFAULT uuid_generate_v4() not null primary key
	, "user_id"				uuid not null
	, "updated" 			timestamp
	, "created" 			timestamp default current_timestamp not null
)`,
				`create index "t_ymux_auth_token_p1" on "t_ymux_auth_token" ( "user_id" )`,
				`create index "t_ymux_auth_token_p2" on "t_ymux_auth_token" ( "created" )`,
				`ALTER TABLE "t_ymux_auth_token"
	ADD CONSTRAINT "t_ymux_auth_token_user_id_fk1"
	FOREIGN KEY ("user_id")
	REFERENCES "t_ymux_user" ("id")`,
				`CREATE OR REPLACE function t_ymux_auth_token_upd()
RETURNS trigger AS $$
BEGIN
	NEW.updated := current_timestamp;
	RETURN NEW;
END
$$ LANGUAGE 'plpgsql'`,
				`CREATE TRIGGER t_ymux_auth_token_trig
BEFORE update ON "t_ymux_auth_token"
FOR EACH ROW
EXECUTE PROCEDURE t_ymux_auth_token_upd()`,
			},
		},
	}
	for ii, test := range tests {
		if test.run {

			// func ScanPostgreSQLText(in string) (stmt_list []string, e_line_no int, e_msg string, err error) {
			rv, e_line_no, e_msg, err := ScanPostgreSQLText(test.strIn)

			if db10 {
				fmt.Printf("e_line_no = %d e_mst = %s err = %s\n", e_line_no, e_msg, err)
			}

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

var db10 = false
