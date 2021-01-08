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
		Status string
		MsgSet []RvStmt
	}
	sRv := RvData{Status: "error"}

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
