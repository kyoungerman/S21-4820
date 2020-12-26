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

	fmt.Printf("List Conn: ->%s<-\n", godebug.SVarI(G_ConnPool))
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

// if IsSelect(lesson_id, stmt, www, req) {
func IsSelect(lesson_id, stmt string, www http.ResponseWriter, req *http.Request) (rv bool) {
	ss := strings.Split(stmt, " ")
	return len(ss) > 0 && strings.ToLower(ss[0]) == "select"
}

// } else if IsUpdate(lesson_id, stmt, www, req) {
func IsUpdate(lesson_id, stmt string, www http.ResponseWriter, req *http.Request) (rv bool) {
	ss := strings.Split(stmt, " ")
	return len(ss) > 0 && strings.ToLower(ss[0]) == "update"
}
