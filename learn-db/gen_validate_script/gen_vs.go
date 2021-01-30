package main

// Copyright (C) Philip Schlump 2015-2019.
// MIT Licensed
// Source pulled from PureImagination Demo Server

// Generate GO code to validate tables/columns.

/*
Sample Call:
	// ------------------------------------------------------------------------------
	// Check that the DDL / Table / Sequences are in PG and ready to use.
	// ------------------------------------------------------------------------------
	good, bad := ValidateTablesDDL(false)

	if *ChkTables {
		fmt.Fprintf(os.Stderr, "%sPG Tables Passed: %s%s\n", MiscLib.ColorGreen, good, MiscLib.ColorReset)
		if len(bad) > 0 {
			fmt.Fprintf(os.Stderr, "%sPG Tables Failed: %s%s\n", MiscLib.ColorGreen, bad, MiscLib.ColorReset)
		} else {
			fmt.Fprintf(os.Stderr, "%sPG All Tables passed:%s\n", MiscLib.ColorGreen, MiscLib.ColorReset)
		}
		fmt.Fprintf(os.Stderr, "%sPG Validated - tables checked early exit%s\n", MiscLib.ColorGreen, MiscLib.ColorReset)
		os.Exit(0)
	}
Sample Makefile:
	gen:
		check-json-syntax --ignore-tab-warning cfg.json
		~/go/src/gitlab.com/pschlump/PureImaginationServer/bin/validate_script.sh \
			"t_ymux_2fa_dev_otk" \
			"t_output" "t_ymux_2fa" "t_ymux_auth_token" "t_ymux_config"  \
			"t_ymux_origin_ok" "t_ymux_priv" "t_ymux_role" "t_ymux_role_priv" "t_ymux_user" \
			"ct_lesson" "ct_login" "ct_lesson_seen" "ct_homework_grade" "ct_homework_list" "ct_lesson_validation"

*/

import (
	"database/sql"
	"flag"
	"fmt"
	"log"
	"os"
	"strings"

	"github.com/pschlump/MiscLib"
	"github.com/pschlump/filelib"
	"github.com/pschlump/godebug"
	"gitlab.com/pschlump/PureImaginationServer/ReadConfig"
)

var Cfg = flag.String("cfg", "../../cfg.json", "config file for this call")
var Out = flag.String("out", "out/x.go", "Output in Go")
var DbFlag = flag.String("db_flag", "", "Additional Debug Flags")

// Configuration to conenect to the dataase.  - All fields are exported to allow read of JSON file.
type GlobalConfigData struct {
	// connect to Postgres Stuff
	DBHost      string `json:"db_host" default:"$ENV$PG_HOST"`
	DBPort      int    `json:"db_port" default:"5432"`
	DBUser      string `json:"db_user"`
	DBPassword  string `json:"db_password" default:"$ENV$PG_AUTH"`
	DBName      string `json:"db_name"`
	DBSSLMode   string `json:"db_sslmode" default:"disable"`
	LogFileName string `json:"log_file_name"`

	// debug flags:
	DebugFlag string `json:"db_flag"`
}

var gCfg GlobalConfigData
var DB *sql.DB
var db_flag map[string]bool
var logFilePtr *os.File

func init() {
	db_flag = make(map[string]bool)
}

func main() {

	flag.Parse() // Parse CLI arguments to this, --cfg <name>.json

	tablesToProcess := flag.Args()
	if len(tablesToProcess) == 0 {
		fmt.Printf("No tables listed\n")
		os.Exit(1)
	}

	if Cfg == nil {
		fmt.Printf("--cfg is a required parameter\n")
		os.Exit(1)
	}

	// ------------------------------------------------------------------------------
	// Read in Configuraiton
	// ------------------------------------------------------------------------------
	err := ReadConfig.ReadFile(*Cfg, &gCfg)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to read confguration: %s error %s\n", *Cfg, err)
		os.Exit(1)
	}

	// ------------------------------------------------------------------------------
	// Logging File
	// ------------------------------------------------------------------------------
	if gCfg.LogFileName != "" {
		fp, err := filelib.Fopen(gCfg.LogFileName, "a")
		if err != nil {
			log.Fatalf("log file confiured, but unable to open, file[%s] error[%s]\n", gCfg.LogFileName, err)
		}
		LogFile(fp)
	}

	// ------------------------------------------------------------------------------
	// Debug Flag Processing
	// ------------------------------------------------------------------------------
	if gCfg.DebugFlag != "" {
		ss := strings.Split(gCfg.DebugFlag, ",")
		// fmt.Printf("gCfg.DebugFlag ->%s<-\n", gCfg.DebugFlag)
		for _, sx := range ss {
			// fmt.Printf("Setting ->%s<-\n", sx)
			db_flag[sx] = true
		}
	}
	if *DbFlag != "" {
		ss := strings.Split(*DbFlag, ",")
		// fmt.Printf("gCfg.DebugFlag ->%s<-\n", gCfg.DebugFlag)
		for _, sx := range ss {
			// fmt.Printf("Setting ->%s<-\n", sx)
			db_flag[sx] = true
		}
	}
	if db_flag["dump-db-flag"] {
		fmt.Fprintf(os.Stderr, "%sDB Flags Enabled Are:%s\n", MiscLib.ColorGreen, MiscLib.ColorReset)
		for x := range db_flag {
			fmt.Fprintf(os.Stderr, "%s\t%s%s\n", MiscLib.ColorGreen, x, MiscLib.ColorReset)
		}
	}
	ConnectToPG()
	Ping()
	fmt.Fprintf(os.Stderr, "%sConnected to PG%s\n", MiscLib.ColorGreen, MiscLib.ColorReset)

	// ------------------------------------------------------------------------------
	// Do actual Procesisng
	// ------------------------------------------------------------------------------

	// XYZZY - this would be better done with a template.
	// XYZZY - this would be nice if it used goimports in code instead of a shell script.

	outFp, err := filelib.Fopen(*Out, "w")
	fmt.Fprintf(outFp, `package main

// Copyright (C) Philip Schlump 2015-2018.
// MIT Licensed
// Source pulled from PureImagination Demo Server

//
// DO NOT EDIT THIS FILE
// This file is automatically generated from the Makefile
//
// make ValidateTables.go
//
// or:
//
// make gen
//

import (
	"fmt"
	"os"

	"gitlab.com/pschlump/PureImaginationServer/ymux"
)

// ValidateTablesDDL is the fuction that is called to validate the tables and stored procedures.
// it returns a list of tables that validated.
func ValidateTablesDDL( exitOnError... bool ) ( good, bad []string ) {
	var err error
`)

	errOcc := false
	for _, tn := range tablesToProcess {
		cols, err := GetColumnMap("public", tn)
		if err != nil {
			errOcc = true
			fmt.Fprintf(os.Stderr, "Error: misssing table %s\n", tn)
			continue
		}
		fmt.Fprintf(outFp, `
	// Table: %s
`, tn)
		fmt.Fprintf(outFp, `	/* %s */
`, godebug.SVarI(cols))

		fmt.Fprintf(outFp, `
	err = ymux.PGCheckTableColumns(ymux.PGTable{
		TableName: %q,
		Columns: []ymux.PGColumn{
`, tn)
		for kk := range cols {
			fmt.Fprintf(outFp, "\t\t{ColumnName: %q},\n", kk)
		}
		fmt.Fprintf(outFp, `
		},
	})
	if err != nil {
		fmt.Fprintf(os.Stderr, "Missing %%s - PG not setup correctly.  Table missing column or missing.\n", err)
		bad = append ( bad, %q )
	} else {
		good = append ( good, %q )
	}
`, tn, tn)
	}
	fmt.Fprintf(outFp, `
	if len(exitOnError) > 0 {
		if exitOnError[0] == true {
			if len(bad) > 0 {
				os.Exit(1)
			}
		}
	} else {
		if len(bad) > 0 {
			os.Exit(1)
		}
	}
	return
}
`)

	if errOcc {
		os.Exit(2)
	} else {
		fmt.Fprintf(os.Stderr, "%sValidation Generated%s\n", MiscLib.ColorGreen, MiscLib.ColorReset)
	}
}
