package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"os"
	"strings"

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
	_, lesson_id := ymux.GetVar("lesson_id", www, req)
	_, stmt := ymux.GetVar("stmt", www, req)
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
	fmt.Printf("lesson_id: ->%s<-\n", lesson_id)
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
	if lesson_id == "" {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(406)
		fmt.Fprintf(www, "Missing lesson_id")
		fmt.Fprintf(os.Stderr, "%sMissing lesson_id, AT:%s%s\n", MiscLib.ColorRed, godebug.LF(), MiscLib.ColorReset)
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
	type RvData struct {
		Status string
		MsgSet []string
	}
	sRv := RvData{Status: "error"}

	for ss, stmtX := range stmt_set {
		if IsSelect(lesson_id, stmtX, www, req) {
			if len(userdata) == 0 {
				fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
				// resultSet, err = ymux.SQLQueryDB(UserDB, stmtX)
				resultSet = sizlib.SelData(UserDB, stmtX)
			} else {
				fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
				// resultSet, err = ymux.SQLQueryDB(UserDB, stmtX, userdata...) // Xyzzy - add data as JSON array (Bind variables)
				resultSet = sizlib.SelData(UserDB, stmtX, userdata...)
			}
			if err != nil {
				fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
				sRv.Status = "error"
				sRv.MsgSet = append(sRv.MsgSet, fmt.Sprintf("%s", err))
			} else {
				fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
				// rv = fmt.Sprintf(`{"status":"success","data":%s}`, godebug.SVarI(resultSet))
				sRv.Status = "success"
				sRv.MsgSet = append(sRv.MsgSet, fmt.Sprintf("%s", godebug.SVarI(resultSet)))
			}
		} else if IsUpdate(lesson_id, stmtX, www, req) {
			fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
			nr, err = ymux.SQLUpdateDB(UserDB, stmtX)
			if err != nil {
				// rv = fmt.Sprintf(`{"status":"error","msg":%q}`, err)
				sRv.Status = "error"
				sRv.MsgSet = append(sRv.MsgSet, fmt.Sprintf("%s", err))
			} else {
				// rv = fmt.Sprintf(`{"status":"success","n_rows_updated":%d}`, nr)
				sRv.Status = "success"
				sRv.MsgSet = append(sRv.MsgSet, fmt.Sprintf("n_rows_update=%d", nr))
			}
		} else {
			fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
			err = ymux.SQLInsertDB(UserDB, stmtX)
			if err != nil {
				// rv = fmt.Sprintf(`{"status":"error","msg":%q}`, err)
				sRv.Status = "error"
				sRv.MsgSet = append(sRv.MsgSet, fmt.Sprintf("%s", err))
			} else {
				rv = fmt.Sprintf(`{"status":"success"}`)
				sRv.Status = "success"
				sRv.MsgSet = append(sRv.MsgSet, "ok")
			}
		}
	}

	rv = godebug.SVarI(sRv)
	fmt.Fprintf(os.Stderr, "%sOutput From Run ->%s<- AT:%s%s\n", MiscLib.ColorGreen, rv, godebug.LF(), MiscLib.ColorReset)

	www.Header().Set("Content-Type", "application/json")
	fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
	www.WriteHeader(200) // Status Success
	fmt.Fprintf(www, "%s", rv)

}

// Button: Auto Test
// mux.Handle("/api/v1/validate-sql-in-db", http.HandlerFunc(HandleValidateSQLInDatabase)).DocTag("<h2>/api/v1/status")
func HandleValidateSQLInDatabase(www http.ResponseWriter, req *http.Request) {
	// xyzzy
	// xyzzy
	// xyzzy
	// xyzzy
	// xyzzy
	found, user_id := ymux.GetVar("user_id", www, req)
	fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
	if user_id == "" || !found {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(401)
		fmt.Fprintf(www, "Missing to user_id=[%s]", user_id)
		return
	}
	_, lesson_id := ymux.GetVar("lesson_id", www, req)
	_, stmt := ymux.GetVar("stmt", www, req)
	_, rawuserdata := ymux.GetVar("rawuserdata", www, req)
	username, err := GetUsernameFromId(user_id)
	fmt.Fprintf(os.Stderr, "%suser_id %s username = ->%s<- AT: %s%s\n", MiscLib.ColorCyan, user_id, username, godebug.LF(), MiscLib.ColorReset)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(500)
		fmt.Fprintf(www, "Missing to username=[%s]", username)
		return
	}

	fmt.Printf("List Conn: ->%s<-\n", godebug.SVarI(G_ConnPool))
	fmt.Printf("username: ->%s<-\n", username)
	fmt.Printf("stmt: ->%s<-\n", stmt)
	fmt.Printf("lesson_id: ->%s<-\n", lesson_id)
	fmt.Printf("rawuserdata: ->%s<-\n", rawuserdata)

	UserDB, err := GetConn(username)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(500)
		fmt.Fprintf(www, "Missing connection to database for=[%s]", username)
		return
	}
	fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
	if lesson_id == "" {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(406)
		fmt.Fprintf(www, "Missing lesson_id")
		return
	}
	fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
	if stmt == "" {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(406)
		fmt.Fprintf(www, "Missing stmt")
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
	if IsSelect(lesson_id, stmt, www, req) {
		if len(userdata) == 0 {
			fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
			// resultSet, err = ymux.SQLQueryDB(UserDB, stmt)
			resultSet = sizlib.SelData(UserDB, stmt)
		} else {
			fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
			// resultSet, err = ymux.SQLQueryDB(UserDB, stmt, userdata...) // Xyzzy - add data as JSON array (Bind variables)
			resultSet = sizlib.SelData(UserDB, stmt, userdata...)
		}
		if err != nil {
			fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
			rv = fmt.Sprintf(`{"status":"error","msg":%q}`, err)
		} else {
			fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
			rv = fmt.Sprintf(`{"status":"success","data":%s}`, godebug.SVarI(resultSet))
		}
	} else if IsUpdate(lesson_id, stmt, www, req) {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
		nr, err = ymux.SQLUpdateDB(UserDB, stmt)
		if err != nil {
			rv = fmt.Sprintf(`{"status":"error","msg":%q}`, err)
		} else {
			rv = fmt.Sprintf(`{"status":"success","n_rows_updated":%d}`, nr)
		}
	} else {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
		err = ymux.SQLInsertDB(UserDB, stmt)
		if err != nil {
			rv = fmt.Sprintf(`{"status":"error","msg":%q}`, err)
		} else {
			rv = fmt.Sprintf(`{"status":"success"}`)
		}
	}

	www.Header().Set("Content-Type", "application/json")
	fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
	www.WriteHeader(200) // Status Success
	fmt.Fprintf(www, "%s", rv)

}

// Button: Submit Answer
// mux.Handle("/api/v1/submit-answer-db", http.HandlerFunc(HandleSubmitAnswerInDatabase)).DocTag("<h2>/api/v1/status")
func HandleSubmitAnswerInDatabase(www http.ResponseWriter, req *http.Request) {
	// xyzzy
	// xyzzy
	// xyzzy
	// xyzzy
	// xyzzy
	found, user_id := ymux.GetVar("user_id", www, req)
	fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
	if user_id == "" || !found {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(401)
		fmt.Fprintf(www, "Missing to user_id=[%s]", user_id)
		return
	}
	_, lesson_id := ymux.GetVar("lesson_id", www, req)
	_, stmt := ymux.GetVar("stmt", www, req)
	_, rawuserdata := ymux.GetVar("rawuserdata", www, req)
	username, err := GetUsernameFromId(user_id)
	fmt.Fprintf(os.Stderr, "%suser_id %s username = ->%s<- AT: %s%s\n", MiscLib.ColorCyan, user_id, username, godebug.LF(), MiscLib.ColorReset)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(500)
		fmt.Fprintf(www, "Missing to username=[%s]", username)
		return
	}

	fmt.Printf("List Conn: ->%s<-\n", godebug.SVarI(G_ConnPool))
	fmt.Printf("username: ->%s<-\n", username)
	fmt.Printf("stmt: ->%s<-\n", stmt)
	fmt.Printf("lesson_id: ->%s<-\n", lesson_id)
	fmt.Printf("rawuserdata: ->%s<-\n", rawuserdata)

	UserDB, err := GetConn(username)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(500)
		fmt.Fprintf(www, "Missing connection to database for=[%s]", username)
		return
	}
	fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
	if lesson_id == "" {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(406)
		fmt.Fprintf(www, "Missing lesson_id")
		return
	}
	fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
	if stmt == "" {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(406)
		fmt.Fprintf(www, "Missing stmt")
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
	if IsSelect(lesson_id, stmt, www, req) {
		if len(userdata) == 0 {
			fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
			// resultSet, err = ymux.SQLQueryDB(UserDB, stmt)
			resultSet = sizlib.SelData(UserDB, stmt)
		} else {
			fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
			// resultSet, err = ymux.SQLQueryDB(UserDB, stmt, userdata...) // Xyzzy - add data as JSON array (Bind variables)
			resultSet = sizlib.SelData(UserDB, stmt, userdata...)
		}
		if err != nil {
			fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
			rv = fmt.Sprintf(`{"status":"error","msg":%q}`, err)
		} else {
			fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
			rv = fmt.Sprintf(`{"status":"success","data":%s}`, godebug.SVarI(resultSet))
		}
	} else if IsUpdate(lesson_id, stmt, www, req) {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
		nr, err = ymux.SQLUpdateDB(UserDB, stmt)
		if err != nil {
			rv = fmt.Sprintf(`{"status":"error","msg":%q}`, err)
		} else {
			rv = fmt.Sprintf(`{"status":"success","n_rows_updated":%d}`, nr)
		}
	} else {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorCyan, godebug.LF(), MiscLib.ColorReset)
		err = ymux.SQLInsertDB(UserDB, stmt)
		if err != nil {
			rv = fmt.Sprintf(`{"status":"error","msg":%q}`, err)
		} else {
			rv = fmt.Sprintf(`{"status":"success"}`)
		}
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
	eq := 0
	sp := 0
	for ii, cc := range stmt {
		if eq == 1 {
		} else if cc == '\'' {
			eq = 1
		} else if cc == '"' {
			eq = 1
		} else if cc == ';' {
			rv = append(rv, strings.Trim(stmt[sp:ii], " \n\t\f\r"))
			sp = ii + 1
		}
	}
	return
}

// if IsSelect(lesson_id, stmt, www, req) {
func IsSelect(lesson_id, stmt string, www http.ResponseWriter, req *http.Request) (rv bool) {
	ss := strings.Split(strings.Trim(stmt, " \t\f\n\r"), " \t\f\n\r")
	return len(ss) > 0 && strings.ToLower(ss[0]) == "select"
}

// } else if IsUpdate(lesson_id, stmt, www, req) {
func IsUpdate(lesson_id, stmt string, www http.ResponseWriter, req *http.Request) (rv bool) {
	ss := strings.Split(strings.Trim(stmt, " \t\f\n\r"), " \t\f\n\r")
	return len(ss) > 0 && strings.ToLower(ss[0]) == "update"
}
