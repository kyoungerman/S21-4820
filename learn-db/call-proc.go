package main

import (
	"database/sql"
	"encoding/json"
	"fmt"

	"gitlab.com/pschlump/PureImaginationServer/ymux"
)

/*
2. Use stored-prod info
	/home/pschlump/go/src/gitlab.com/pschlump/PureImaginationServer/auth_check/validate_stored_proc.go
	do do the store procdure call - with names

	CallStoredProc ( DB, "c_login",
		"key": gCfg.EncKey,
		"enc_user_hash": EncIt(...),
		"username": unRealm
	)
	Returns map[string]inteface() ->

	var usedStoredProcConfig = []ymux.CrudStoredProcConfig{
		// FUNCTION c_login_user ( p_username varchar )
		{
			StoredProcedureName: "c_login_user",
			CrudBaseConfig: ymux.CrudBaseConfig{
				URIPath:       "n/a",
				TableNameList: []string{"t_ymux_auth_token", "t_ymux_config", "t_ymux_priv", "t_ymux_role", "t_ymux_role_priv", "t_ymux_user", "t_ymux_user_log"},
				ParameterList: []ymux.ParamListItem{
					{ReqVar: "username", ParamName: "p_username"},
				},
			},
		},
		{
			StoredProcedureName: "c_login_user_enc",
			CrudBaseConfig: ymux.CrudBaseConfig{
				URIPath:       "n/a",
				TableNameList: []string{"t_ymux_auth_token", "t_ymux_config", "t_ymux_priv", "t_ymux_role", "t_ymux_role_priv", "t_ymux_user", "t_ymux_user_log"},
				ParameterList: []ymux.ParamListItem{
					{ReqVar: "username", ParamName: "p_username"},
					{ReqVar: "key", ParamName: "p_key"},                     // 13
					{ReqVar: "enc_user_hash", ParamName: "p_enc_user_hash"}, // 14
				},
			},
		},
*/

func genPlist(name string, args []interface{}) (aa string) {
	return
}

func genVals(name string, args []interface{}) (aa []interface{}) {
	return
}

// ymux.GetStoredProcDefinition(name string) (rv CrudStoredProcConfig, err error) {
/*

 */

func CallStoredProc(DB *sql.DB, name string, args ...interface{}) (rv map[string]interface{}, err error) {
	// xyzzy0 - very can get to usedStoredProcConfig...

	plist := genPlist(name, args)
	vals := genVals(name, args)
	stmt := "select %s ( %s ) as \"x\""

	stmt = fmt.Sprintf(stmt, name, plist)
	// xyzzy - log stmt + params

	var raw string
	err = ymux.SQLQueryRowDB(DB, stmt, vals...).Scan(&raw)
	if err != nil {
		// xyzzy - log appropraite information
		// xyzzy - encrypte logs as necessary
		return
	}

	// xyzzy - log return JSON data

	rv = make(map[string]interface{})
	err = json.Unmarshal([]byte(raw), &rv)
	if err != nil {
		// xyzzy - log appropraite information
		// xyzzy - encrypte logs as necessary
		return
	}

	return
}

func GenerateCallStoredProc(DB *sql.DB, filename string) {
	// generate struct/type for return from each call
	// generate func for each call
}

/* vim: set noai ts=4 sw=4: */
