package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"os"

	"github.com/pschlump/Go-FTL/server/sizlib"
	"gitlab.com/pschlump/PureImaginationServer/ymux"
)

type AConn struct {
	DatabaseName string // name of database, looks like le0000
	connToDb     *sql.DB
}

type ConnPool map[string]AConn

var G_ConnPool ConnPool

// var DB *sql.DB -- delcared in server-main.go

func ReadConnectinSetup(filename string) {
	data, err := ioutil.ReadFile(filename)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading [%s] - %s\n", filename, err)
		return
	}

	err = json.Unmarshal(data, &G_ConnPool)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error parsing [%s] - %s\n", filename, err)
		return
	}
}

func GetConn(name string) (*sql.DB, error) {

	if DB == nil {
		DB = ymux.GetDB()
	}
	if name == "pschlump" {
		return DB, nil
	}

	var conn AConn
	var ok bool

	if conn, ok = G_ConnPool[name]; !ok {
		return nil, fmt.Errorf("Invalid name [%s] is not configured to connect to database", name)
	}

	fmt.Printf("Before HasDatabase [%s]\n", name)
	if !HasDatabase(conn.DatabaseName) {
		err := CreateDatabase(conn.DatabaseName)
		if err != nil {
			fmt.Printf("Failed to create database ->%s<- err %s\n", name, err)
			return nil, err
		}

		// xyzzy - populate for startup
	}

	if conn.connToDb == nil {
		// create connection to database using NamePool info
		t1, err := ConnectToPGGeneral(gCfg.DBHost, gCfg.DBPort, gCfg.DBUser, gCfg.DBPassword, conn.DatabaseName, gCfg.DBSSLMode)
		if err != nil {
			fmt.Printf("Error Connect to PG with error: %s\n", err)
			return nil, err
		}
		conn.connToDb = t1

		G_ConnPool[name] = conn
	}

	return conn.connToDb, nil

}

/*
SELECT datname FROM pg_database WHERE datistemplate = false;
create database <name>
	qry := `SELECT * FROM information_schema.tables WHERE table_schema = $1 and table_name = $2`
	qry := `SELECT * FROM information_schema.columns WHERE table_schema = $1 and table_name = $2`

from .../ymux/crud-pg-check.go
*/

func ListOfDatabses() (db []string, err error) {
	qry := `SELECT datname FROM pg_database WHERE datistemplate = false`
	data := sizlib.SelData(DB, qry)
	if data == nil || len(data) == 0 {
		err = fmt.Errorf("Error(190532): Missing - no databases:")
		return
	}
	for _, dd := range data {
		db = append(db, dd["datname"].(string))
	}
	return
}

func HasDatabase(DatabaseName string) (rv bool) {
	qry := `SELECT datname FROM pg_database WHERE datistemplate = false and datname = $1`
	data := sizlib.SelData(DB, qry, DatabaseName)
	if data == nil || len(data) == 0 {
		return false
	}
	return true
}

func CreateDatabase(DatabaseName string) (err error) {
	qry := fmt.Sprintf("create database %s", DatabaseName)
	fmt.Printf("Create database qry=%s\n", qry)
	err = ymux.SQLInsert(qry)
	return
}

// ConnectToPG Connects to the postgresDB.  This can be called multiple times.
func ConnectToPGGeneral(DBHost string, DBPort int, DBUser, DBPassword, DBName, DBSSLMode string) (DB *sql.DB, err error) {
	psqlInfo := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=%s", DBHost, DBPort, DBUser, DBPassword, DBName, DBSSLMode)
	if DbOn["echo.connect.pg"] {
		fmt.Printf("Connect to PG with: ->%s<-\n", psqlInfo)
	}
	DB, err = sql.Open("postgres", psqlInfo)
	if err != nil {
		return
	}
	if err = DB.Ping(); err != nil {
		return
	}
	return DB, nil
}

// ----------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------
type SchemaItem struct {
	Body         string
	ErrorType    string
	ErrorMessage string
}

func InstallSchema(DB *sql.DB, schemaSet []SchemaItem) {
	for ii, vv := range schemaSet {
		fmt.Printf("Schema Setup - Item %d ->%s<-\n", ii, vv.Body)
		err := ymux.SQLInsertDB(DB, vv.Body)
		if err != nil {
			fmt.Printf("Error: at %d in setup schema ->%s<- error %s\n", ii, vv.Body, err)
		}
	}
}
