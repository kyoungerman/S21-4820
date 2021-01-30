package main

// Copyright (C) Philip Schlump 2016.
// MIT Licensed
// Source pulled from PureImagination Demo Server

import (
	"fmt"
	"regexp"
	"strings"

	"github.com/Univ-Wyo-Education/S21-4280/learn-db/scan"
	"github.com/pschlump/Go-FTL/server/sizlib"
)

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
	return IsXXX(stmt, "select") || IsXXX(stmt, "with")
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
