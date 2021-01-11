package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"regexp"
	"strings"

	"github.com/Univ-Wyo-Education/S21-4280/learn-db/scan"
	"github.com/pschlump/Go-FTL/server/sizlib"
	"github.com/pschlump/MiscLib"
	"github.com/pschlump/godebug"
	"gitlab.com/pschlump/PureImaginationServer/ymux"
)

// Button: RunItNow
// mux.Handle("/api/v1/run-sql-in-db", http.HandlerFunc(HandleRunSQLInDatabase)).DocTag("<h2>/api/v1/status")
func HandleRunSQLInDatabase(www http.ResponseWriter, req *http.Request) {
	found, user_id := ymux.GetVar("user_id", www, req)
	fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
	if user_id == "" || !found {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(401)
		fmt.Fprintf(www, "Missing to user_id=[%s]", user_id)
		return
	}
	_, homework_id := ymux.GetVar("homework_id", www, req)
	_, homework_no := ymux.GetVar("homework_no", www, req)
	_, stmt := ymux.GetVar("stmt", www, req)
	_, grade_it := ymux.GetVar("grade_it", www, req)
	_, rawuserdata := ymux.GetVar("rawuserdata", www, req)
	username, err := GetUsernameFromId(user_id)
	fmt.Fprintf(os.Stderr, "%suser_id %s username = ->%s<- AT: %s%s\n", MiscLib.ColorCyan, user_id, username, godebug.LF(), MiscLib.ColorReset)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(500)
		fmt.Fprintf(www, "Missing to username=[%s]", username)
		return
	}

	fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
	fmt.Printf("List Conn: ->%s<-\n", godebug.SVarI(G_ConnPool))
	fmt.Printf("username: ->%s<-\n", username)
	fmt.Printf("stmt: ->%s<-\n", stmt)
	fmt.Printf("homework_id: ->%s<-\n", homework_id)
	fmt.Printf("homework_no: ->%s<-\n", homework_no)
	fmt.Printf("grade_it: ->%s<-\n", grade_it)
	fmt.Printf("rawuserdata: ->%s<-\n", rawuserdata)

	UserDB, err := GetConn(username)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(500)
		fmt.Fprintf(os.Stderr, "%sMissing connection to database for=[%s]%s\n", MiscLib.ColorRed, username, MiscLib.ColorReset)
		fmt.Fprintf(www, "Missing connection to database for=[%s]", username)
		return
	}
	fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
	if homework_id == "" {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(406)
		fmt.Fprintf(www, "Missing homework_id")
		fmt.Fprintf(os.Stderr, "%sMissing homework_id, AT:%s%s\n", MiscLib.ColorRed, godebug.LF(), MiscLib.ColorReset)
		return
	}
	fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
	if homework_no == "" {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(406)
		fmt.Fprintf(www, "Missing homework_no")
		fmt.Fprintf(os.Stderr, "%sMissing homework_no, AT:%s%s\n", MiscLib.ColorRed, godebug.LF(), MiscLib.ColorReset)
		return
	}
	fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
	if stmt == "" {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(406)
		fmt.Fprintf(www, "Missing stmt")
		fmt.Fprintf(os.Stderr, "%sMissing stmt, AT:%s%s\n", MiscLib.ColorRed, godebug.LF(), MiscLib.ColorReset)
		return
	}
	fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)

	userdata := make([]interface{}, 0, 1)
	var nr int
	// func SQLQueryRow(stmt string, data ...interface{}) (aRow *sql.Row) {
	// var aRow *sql.Row
	// func SQLQueryDB(DB *sql.DB, stmt string, data ...interface{}) (resultSet *sql.Rows, err error) {
	// var resultSet *sql.Rows
	var resultSet []map[string]interface{}
	var rv string

	err = json.Unmarshal([]byte(rawuserdata), &userdata)
	if err != nil {
		userdata = make([]interface{}, 0, 1)
		fmt.Fprintf(os.Stderr, "%sAT: %s err=%s data->%s<- %s\n", MiscLib.ColorYellow, godebug.LF(), err, rawuserdata, MiscLib.ColorReset)
		err = nil
	}
	fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)

	rv = `{"status":"error","msg":"invalid case"}`
	stmt_set := SplitIntoStmt(stmt)
	type RvStmt struct {
		Msg           string
		Stmt          string
		Data          []map[string]interface{} `json:"Data,omitempty"` // JSON Format
		NRowsUpdated  *int                     `json:"NRowsUpdated,omitempty"`
		NRowsInserted *int                     `json:"NRowsInserted,omitempty"`
		NRowsDeleted  *int                     `json:"NRowsDeleted,omitempty"`
	}
	type RvData struct {
		Status   string
		MsgSet   []RvStmt
		GradeMsg []string `json:"GradeMsg,omitempty"`
	}
	sRv := RvData{Status: "error"}
	sRv.MsgSet = make([]RvStmt, 0, 1)

	for _, stmtX := range stmt_set {
		if IsSelect(stmtX) {
			if len(userdata) == 0 {
				fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
				// resultSet, err = ymux.SQLQueryDB(UserDB, stmtX)
				resultSet = sizlib.SelData(UserDB, stmtX)
			} else {
				fmt.Fprintf(os.Stderr, "%s >>>>>>>>>>>>> Select <<<<<<<<<<<<<< AT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
				// resultSet, err = ymux.SQLQueryDB(UserDB, stmtX, userdata...) // Xyzzy - add data as JSON array (Bind variables)
				resultSet = sizlib.SelData(UserDB, stmtX, userdata...)
			}
			if err != nil {
				fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
				sRv.Status = "error"
				sRv.MsgSet = append(sRv.MsgSet, RvStmt{Msg: fmt.Sprintf("%s", err), Stmt: stmtX})
			} else {
				fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
				sRv.Status = "success"
				// sRv.MsgSet = append(sRv.MsgSet, RvStmt{Msg: "ok", Data: godebug.SVarI(resultSet), Stmt: stmtX})
				sRv.MsgSet = append(sRv.MsgSet, RvStmt{Msg: "ok", Data: resultSet, Stmt: stmtX})
			}
		} else if IsUpdate(stmtX) {
			fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
			nr, err = ymux.SQLUpdateDB(UserDB, stmtX)
			if err != nil {
				sRv.Status = "error"
				sRv.MsgSet = append(sRv.MsgSet, RvStmt{Msg: fmt.Sprintf("%s", err), Stmt: stmtX})
			} else {
				sRv.Status = "success"
				// sRv.MsgSet = append(sRv.MsgSet, fmt.Sprintf("n_rows_update=%d", nr))
				sRv.MsgSet = append(sRv.MsgSet, RvStmt{Msg: "ok", NRowsUpdated: &nr, Stmt: stmtX})
			}
		} else if IsInsert(stmtX) {
			fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
			ni, err := ymux.SQLInsertDB(UserDB, stmtX)
			if err != nil {
				sRv.Status = "error"
				sRv.MsgSet = append(sRv.MsgSet, RvStmt{Msg: fmt.Sprintf("%s", err), Stmt: stmtX})
			} else {
				sRv.Status = "success"
				// sRv.MsgSet = append(sRv.MsgSet, fmt.Sprintf("n_rows_update=%d", nr))
				sRv.MsgSet = append(sRv.MsgSet, RvStmt{Msg: "ok", NRowsInserted: &ni, Stmt: stmtX})
			}
		} else if IsDelete(stmtX) {
			fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
			nd, err := ymux.SQLDeleteDB(UserDB, stmtX)
			if err != nil {
				sRv.Status = "error"
				sRv.MsgSet = append(sRv.MsgSet, RvStmt{Msg: fmt.Sprintf("%s", err), Stmt: stmtX})
			} else {
				sRv.Status = "success"
				// sRv.MsgSet = append(sRv.MsgSet, fmt.Sprintf("n_rows_update=%d", nr))
				sRv.MsgSet = append(sRv.MsgSet, RvStmt{Msg: "ok", NRowsDeleted: &nd, Stmt: stmtX})
			}
		} else {
			fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
			nX, err := ymux.SQLInsertDB(UserDB, stmtX)
			_ = nX
			if err != nil {
				sRv.Status = "error"
				sRv.MsgSet = append(sRv.MsgSet, RvStmt{Msg: fmt.Sprintf("%s", err), Stmt: stmtX})
			} else {
				rv = fmt.Sprintf(`{"status":"success"}`)
				sRv.Status = "success"
				// sRv.MsgSet = append(sRv.MsgSet, "ok") // xyzzy should have return ID if genrated!
				sRv.MsgSet = append(sRv.MsgSet, RvStmt{Msg: "ok", Stmt: stmtX})
			}
		}
	}

	rv = godebug.SVarI(sRv)
	fmt.Fprintf(os.Stderr, "%sOutput From Run ->%s<- AT:%s%s\n", MiscLib.ColorGreen, rv, godebug.LF(), MiscLib.ColorReset)

	/*
	   select * from ct_val_homework;
	   			   val_id                | homework_no |    val_type    |                                       val_data                                        |
	   --------------------------------------+-------------+----------------+---------------------------------------------------------------------------------------+
	   7eca9faf-575d-4716-7485-3824ee87dc25 |           1 | te: SQL-Select | select validate_hw01()                                                                |
	   c6bd189f-e90c-4c2e-7710-5c339eba8954 |           2 | te: SQL-Select | select 'PASS' from name_list where name = 'Philip Schlump'                            |
	   5f03ddb2-3620-4dac-4170-1b374bcad6a3 |          13 | te: SQL-Select | select 'PASS' from ( select count(1) as cnt from us_state ) as foo where foo.cnt = 53 |
	   16228a7b-f417-4990-78bf-224514c390c7 |          26 | te: SQL-Select | select select setup_data_26()                                                         |

	   CREATE TABLE ct_homework_grade (
	   	  user_id		uuid not null						-- 1 to 1 map to user
	   	, homework_id		uuid not null						-- assignment
	   	, tries			int default 0 not null				-- how many times did they try thisa
	   	, pass			text default 'No' not null			-- Did the test get passed
	   	, pts			int default 0 not null				-- points awarded
	   	, updated 		timestamp
	   	, created 		timestamp default current_timestamp not null
	   );
	*/
	getStr := func(row map[string]interface{}, name string, dflt string) (rv string) {
		var ok, ok2 bool
		var tmp interface{}
		rv = dflt
		if tmp, ok = row[name]; ok {
			if rv, ok2 = tmp.(string); !ok2 {
				rv = dflt
			}
		}
		return
	}

	getInt := func(row map[string]interface{}, name string, dflt int) (rv int) {
		var ok, ok2 bool
		var tmp interface{}
		rv = dflt
		if tmp, ok = row[name]; ok {
			if rv, ok2 = tmp.(int); !ok2 {
				rv = dflt
			}
		}
		return
	}

	if grade_it == "yes" {
		fmt.Fprintf(os.Stderr, "%sGrad Of Run ------------------------------------------------ AT:%s%s\n", MiscLib.ColorGreen, godebug.LF(), MiscLib.ColorReset)
		stmt := `select t1.val_type, t1.val_data, t2.points_avail
			from ct_val_homework  as t1
				join ct_homework as t2 on ( t2.homework_no::int = t1.homework_no )
			where t1.homework_no = $1`
		type CountRowsType struct {
			Nr []int
		}
		// var resultSet []map[string]interface{}
		resultSet = sizlib.SelData(DB, stmt, homework_no)
		fmt.Fprintf(os.Stderr, "%sresultSet = %s AT:%s%s\n", MiscLib.ColorCyan, godebug.SVarI(resultSet), godebug.LF(), MiscLib.ColorReset)
		for ii, row := range resultSet {

			fmt.Fprintf(os.Stderr, "%sPostion %d ------------------------------------------------ AT:%s%s\n", MiscLib.ColorGreen, ii, godebug.LF(), MiscLib.ColorReset)

			val_type := getStr(row, "val_type", "")
			val_data := getStr(row, "val_data", "")
			points_avail := getInt(row, "points_avail", 10)

			pass := ""
			switch val_type {
			case "SQL-Select":
				resultSet2 := sizlib.SelData(UserDB, val_data)
				fmt.Fprintf(os.Stderr, "%sresultSet2 = %s AT:%s%s\n", MiscLib.ColorCyan, godebug.SVarI(resultSet2), godebug.LF(), MiscLib.ColorReset)
				if len(resultSet2) > 0 {
					fmt.Fprintf(os.Stderr, "%sPASS AT:%s%s\n", MiscLib.ColorGreen, godebug.LF(), MiscLib.ColorReset)
					pass = getStr(resultSet2[0], "x", "")
				} else {
					fmt.Fprintf(os.Stderr, "%sFAIL AT:%s%s\n", MiscLib.ColorRed, godebug.LF(), MiscLib.ColorReset)
					pass = "no"
				}
			case "CountRows":
				var cnt CountRowsType
				err := json.Unmarshal([]byte(val_data), &cnt)
				if err != nil {
					pass = "no"
					// xyzzy
				} else {
					for _, xx := range sRv.MsgSet {
						if xx.Data != nil {
							l := len(xx.Data)
							if godebug.InArrayInt(l, cnt.Nr) != -1 {
								pass = "PASS"
							}
						}
					}
				}
			case "":
				pass = "no"
			}
			if pass == "PASS" {
				_ = points_avail
				// insert update stuff // insert update stuff // insert update stuff // insert update stuff
				// CREATE OR REPLACE FUNCTION grade_hw_no( p_user_id uuid, p_homework_id uuid, p_pts ) RETURNS text
				resultSet3 := sizlib.SelData(DB, "select grade_hw_no ( $1, $2, $3 ) as x", user_id, homework_id, 10)
				if len(resultSet3) > 0 {
					fmt.Fprintf(os.Stderr, "%sgraded AT:%s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
					x := getStr(resultSet3[0], "x", "")
					if x == "PASS" {
						sRv.GradeMsg = append(sRv.GradeMsg, fmt.Sprintf("Graded: got %d points out of possible %d.\n", 10, 10))
						fmt.Fprintf(os.Stderr, "%sgraded AT:%s%s\n", MiscLib.ColorGreen, godebug.LF(), MiscLib.ColorReset)
					} else {
						sRv.GradeMsg = append(sRv.GradeMsg, fmt.Sprintf("Error Grading Pleae Report: got %d points out of possible %d.\n", 0, 10))
						fmt.Fprintf(os.Stderr, "%sgraded/function failed FAIL AT:%s%s\n", MiscLib.ColorRed, godebug.LF(), MiscLib.ColorReset)
					}
				} else {
					sRv.GradeMsg = append(sRv.GradeMsg, fmt.Sprintf("Error Grading Pleae Report: got %d points out of possible %d.\n", 0, 10))
					fmt.Fprintf(os.Stderr, "%sgraded FAIL AT:%s%s\n", MiscLib.ColorRed, godebug.LF(), MiscLib.ColorReset)
				}
			} else {
				resultSet3 := sizlib.SelData(DB, "select grade_hw_no ( $1, $2, $3 ) as x", user_id, homework_id, -1)
				// sRv.GradeMsg = append(sRv.GradeMsg, fmt.Sprintf("Graded: got %d points out of possible %d.\n", 0, 10))
				if len(resultSet3) > 0 {
					fmt.Fprintf(os.Stderr, "%sgraded AT:%s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
					x := getStr(resultSet3[0], "x", "")
					if x == "PASS" {
						sRv.GradeMsg = append(sRv.GradeMsg, fmt.Sprintf("Graded: got %d points out of possible %d.\n", 10, 10))
						fmt.Fprintf(os.Stderr, "%sgraded AT:%s%s\n", MiscLib.ColorGreen, godebug.LF(), MiscLib.ColorReset)
					} else {
						sRv.GradeMsg = append(sRv.GradeMsg, fmt.Sprintf("Error Grading Pleae Report: got %d points out of possible %d.\n", 0, 10))
						fmt.Fprintf(os.Stderr, "%sgraded/function failed FAIL AT:%s%s\n", MiscLib.ColorRed, godebug.LF(), MiscLib.ColorReset)
					}
				} else {
					sRv.GradeMsg = append(sRv.GradeMsg, fmt.Sprintf("Error Grading Pleae Report: got %d points out of possible %d.\n", 0, 10))
					fmt.Fprintf(os.Stderr, "%sgraded FAIL AT:%s%s\n", MiscLib.ColorRed, godebug.LF(), MiscLib.ColorReset)
				}
			}
		}
		rv = godebug.SVarI(sRv)
		fmt.Fprintf(os.Stderr, "%sOutput From Run/Grade ->%s<- AT:%s%s\n", MiscLib.ColorGreen, rv, godebug.LF(), MiscLib.ColorReset)
		// get data
		// if 'SQL-Select"
		// 		run select
		// 		see if 'PASS'
		// if 'CountRows'
		// 		see if a "select" has that number of rows in output data
		//		see if 'PASS'
		// if 'PASS' then
		//		insert/update this hw to reflect points_avail - into ct_homework_grade - if update, increment tries, set pass & pts
	}

	www.Header().Set("Content-Type", "application/json")
	fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
	www.WriteHeader(200) // Status Success
	fmt.Fprintf(www, "%s", rv)

}

// username, err := GetUsernameFromId(user_id)
func GetUsernameFromId(user_id string) (username string, err error) {
	qry := `SELECT username FROM t_ymux_user WHERE id = $1`
	data := sizlib.SelData(DB, qry, user_id)
	if data == nil || len(data) == 0 {
		err = fmt.Errorf("Error(190532): Missing - no databases:")
		return
	}
	username = data[0]["username"].(string)
	//for _, dd := range data {
	//	db = append(db, dd["datname"].(string))
	//}
	return
}

func SplitIntoStmt(stmt string) (rv []string) {

	rv, _, _, err := scan.ScanPostgreSQLText(stmt)
	if err != nil {
		// xyzzy
	}

	return

}

func IsXXX(stmt, word string) (rv bool) {
	re := regexp.MustCompile("[ \t\n\r\f]+")

	split := re.Split(stmt, -1)
	set := []string{}

	for i := range split {
		if split[i] != "" {
			set = append(set, split[i])
		}
	}

	rv = len(set) > 0 && strings.ToLower(set[0]) == word
	return
}

func IsSelect(stmt string) (rv bool) {
	return IsXXX(stmt, "select")
}

func IsUpdate(stmt string) (rv bool) {
	return IsXXX(stmt, "update")
}

func IsDelete(stmt string) (rv bool) {
	return IsXXX(stmt, "delete")
}

func IsInsert(stmt string) (rv bool) {
	return IsXXX(stmt, "insert")
}
