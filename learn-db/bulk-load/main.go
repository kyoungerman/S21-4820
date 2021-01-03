package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"strings"

	"github.com/pschlump/MiscLib"
	"github.com/pschlump/godebug"
	"gitlab.com/pschlump/PureImaginationServer/ReadConfig"
	"gitlab.com/pschlump/PureImaginationServer/get"
	"gitlab.com/pschlump/PureImaginationServer/misc"
	"gitlab.com/pschlump/PureImaginationServer/ymux"
	"gitlab.com/pschlump/q8s-server/q8stype"
)

// ConfigType is the global configuration that is read in from cfg.json
type ConfigType struct {
	ymux.BaseConfigType

	BaseServerURL string `json:"base_server_url" default:"http://127.0.0.1:7001"`
	ImgServerURL  string `json:"base_server_url" default:"http://127.0.0.1:7001"`
	Username      string `json:"username" default:"test_bulk_load"`
	Password      string `json:"password" default:"$ENV$bulk_load_pw"`
}

var gCfg ConfigType

var Cfg = flag.String("cfg", "cfg.json", "config file, default ./cfg.json")
var Data = flag.String("data", "data.csv", "Input to bulk update")
var Zip = flag.String("zip", "", "zipama")
var Server = flag.String("server", "", "Local q8s server.")
var Version = flag.Bool("version", false, "Report version of code and exit")
var DbFlagParam = flag.String("db_flag", "", "Additional Debug Flags")

var DbFlag = make(map[string]bool)
var GitCommit string

func main() {

	flag.Parse()
	fns := flag.Args()
	if len(fns) > 0 {
		fmt.Printf("Usage: bulk-load [--cfg cfg.json] --data data.csv [ --zip zip-file ] [ --baseurl http://www.example.com ]\n")
		os.Exit(1)
	}

	if *Version {
		fmt.Printf("Version (Git Commit): %s\n", GitCommit)
		os.Exit(0)
	}

	if Cfg == nil {
		fmt.Printf("--cfg is a required parameter\n")
		os.Exit(1)
	}

	// ------------------------------------------------------------------------------
	// Read in Configuration
	// ------------------------------------------------------------------------------
	err := ReadConfig.ReadFile(*Cfg, &gCfg)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Unable to read confguration: %s error %s\n", *Cfg, err)
		os.Exit(1)
	}

	// ------------------------------------------------------------------------------
	// Override the default if specified on command line.
	// ------------------------------------------------------------------------------
	if *Server != "" {
		gCfg.BaseServerURL = *Server
	}

	// ------------------------------------------------------------------------------
	// Debug Flag Processing
	// ------------------------------------------------------------------------------
	ymux.DebugFlagProcess(DbFlagParam, DbFlag, &(gCfg.BaseConfigType))
	get.SetupGet(DbFlag)

	if DbFlag["db4"] {
		fmt.Printf("Cfg ->%s<-\n", godebug.SVarI(gCfg))
	}

	// ------------------------------------------------------------------------------
	// Connect to PG
	// ------------------------------------------------------------------------------
	/*
		DB = ymux.ConnectToPG(&(gCfg.BaseConfigType))
		ymux.Ping()
		ymux.SetupCrud(logFilePtr, isTLS, DbFlag)

		if *Cli == "" || DbFlag["pg"] {
			fmt.Fprintf(os.Stderr, "%sConnected to PG%s\n", MiscLib.ColorGreen, MiscLib.ColorReset)
		}
	*/

	// ------------------------------------------------------------------------------
	// ------------------------------------------------------------------------------
	raw := ReadData(*Data)

	if DbFlag["db5"] {
		fmt.Printf("raw ->%s<-\n", godebug.SVarI(raw))
	}

	// ------------------------------------------------------------------------------
	// get authentication from server - un/pw -> auth key
	// ------------------------------------------------------------------------------
	jwt_token := ""
	// fmt.Fprintf(os.Stdout, "%s/api/v2/login\n", gCfg.BaseServerURL)
	status, rv := get.DoPostHeader(fmt.Sprintf("%s/api/v2/login", gCfg.BaseServerURL), nil, "username", gCfg.Username, "password", gCfg.Password)
	if DbFlag["db18"] {
		fmt.Printf("%s/api/v2/token%s status %d rv ->%s<- AT:%s\n", MiscLib.ColorYellow, MiscLib.ColorReset, status, godebug.SVarI(rv), godebug.LF())
	}
	if status == 401 { // Not Authorized
		fmt.Fprintf(os.Stderr, "%sFailed to login: %d\n%s%s\n", MiscLib.ColorRed, status, rv, MiscLib.ColorReset)
		os.Exit(1)
	}

	//{
	//	"auth_key": "",
	//	"auth_token": "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRoX3Rva2VuIjoiZTdhYTQ0MDctMDFjNS00ZjNlLTYwNTYtYWE3Zjg5OTYwYzZlIiwidXNlcl9pZCI6ImMwYjcxZGY5LWUyNTgtNDllYy1iOTEyLWJmNjlmZjMxNDgxYiJ9.Qyjj2B6wUfiFwmY-aMUeJu4-ohiif9ukzznZ0BmdHm2akVXptUZdyk4GeWc1WqRXu72HP9BxOge5UWrrXgeepQ",
	//	"status": "success",
	//	"user_id": "c0b71df9-e258-49ec-b912-bf69ff31481b"
	//}
	var at q8stype.AuthType
	err = json.Unmarshal([]byte(rv), &at)
	if err != nil {
		fmt.Printf("Failed to parse - %s\n", rv)
		os.Exit(1)
	} else if at.Status != "success" {
		fmt.Printf("Failed not successful w/ 200 status code: - %s\n", rv)
		os.Exit(1)
	} else {
		jwt_token = at.AuthToken
		fmt.Fprintf(os.Stderr, "%sSuccessful login: %d\n%s\n", MiscLib.ColorGreen, status, MiscLib.ColorReset)
		if DbFlag["db17"] {
			fmt.Fprintf(os.Stderr, "%sSuccessful login: %d\n%s%s\n", MiscLib.ColorGreen, status, rv, MiscLib.ColorReset)
		}
	}

	if DbFlag["db18"] {
		fmt.Printf("Exit Now\n")
		os.Exit(0)
	}

	if DbFlag["db5"] {
		fmt.Fprintf(os.Stderr, "Call To ->%s/api/v2/bulk-load<-\n", gCfg.BaseServerURL)
	}
	status, rv = get.DoPostHeader(fmt.Sprintf("%s/api/v2/bulk-load", gCfg.BaseServerURL), []get.HeaderType{
		{Name: "Authorization", Value: fmt.Sprintf("Bearer %s", jwt_token)},
	}, "update", godebug.SVarI(raw))

	if DbFlag["db5"] {
		fmt.Printf("status %d err: %s\nbody: %s\nAT:%s\n", status, err, rv, godebug.LF())
	}

	for ii, vv := range raw.Data {
		// mux.Handle("/api/v2/dec", http.HandlerFunc(HandleDecodeQR)).Method("GET", "POST").DocTag("<h2>/api/v2/dec").Inputs([]*ymux.MuxInput{
		uri := fmt.Sprintf("%s/api/v2/dec", gCfg.BaseServerURL)
		status, dec := get.DoGet(uri, "base10", vv.ID10s)
		if DbFlag["db21"] {
			fmt.Printf("status %d dec ->%s<-\n", status, dec)
		}
		// {
		// 	"status": "success",
		// 	"data": "test=5",
		// 	"to": "http://www.2c-why.com?test=5\u0026base10=4911\u0026base10=4911\u0026base60=AABRF\u0026hasdata=yes"
		// }
		if status != 200 {
			fmt.Printf("Failed to get a correct decode for QR at %d - ID %s/%s\n", ii, vv.ID10s, vv.ID60)
		} else {
			// decode it
			// check status
			var dd q8stype.DecType
			err = json.Unmarshal([]byte(dec), &dd)
			if err != nil {
				fmt.Printf("Failed to parse - %s\n", dd)
			} else if dd.Status != "success" {
				fmt.Printf("Invalid status - %s\n", dd)
			} else {
				// check "to" == vv..URL
				if strings.HasPrefix(vv.URL, dd.To) {
					fmt.Printf("Invalid To -    [%s]\n   Expected     [%s]\n", dd.To, vv.URL)
				}
				// check "data" == vv..Data
				if dd.Data != vv.Data {
					fmt.Printf("Invalid Data -    [%s]\n   Expected       [%s]\n", dd.Data, vv.Data)
				}
			}
		}
	}

	// for each QR Read
	//		Go get the QR Image - valiate that the image is available.
	//			Save image into ./xxx for later zipping
	//		Go decode the QR - get the destination
	//			Check that it is working
	//		Generate index.csv for this.

	nSucc := 0
	nErr := 0
	nSuccDest := 0
	nErrDest := 0
	zipfn := make([]string, 0, len(raw.Data)+1)
	var noEx string
	if strings.HasSuffix(*Zip, ".zip") {
		noEx = misc.RmExt(*Zip)
	} else {
		noEx = *Zip
		*Zip = fmt.Sprintf("%s.zip", *Zip)
	}
	for ii, vv := range raw.Data {
		uri := fmt.Sprintf("%s/qr/qr_%05d/q%05d.4.png", gCfg.ImgServerURL, vv.ID10n/100, vv.ID10n)
		status, img := get.DoGet(uri)
		if status == 200 {
			nSucc++
			if *Zip != "" {
				os.MkdirAll(fmt.Sprintf("./%s", noEx), 0755)
				fn := fmt.Sprintf("./%s/q%05d.4.png", noEx, vv.ID10n)
				ioutil.WriteFile(fn, []byte(img), 0644)
				fn = fmt.Sprintf("./q%05d.4.png", vv.ID10n)
				zipfn = append(zipfn, fn)
				nSucc++
			}
			statusDest, _ := get.DoGet(vv.URL)
			if statusDest == 200 {
				nSuccDest++
			} else {
				nErrDest++
			}
		} else {
			nErr++
			fmt.Printf("%sLine: %d Unable to get ->%s<- image for QR code, status=%d.%s\n", MiscLib.ColorRed, ii+1, uri, status, MiscLib.ColorReset)
		}
	}
	ioutil.WriteFile(fmt.Sprintf("./%s/index.json", noEx), []byte(godebug.SVarI(raw)), 0644)
	zipfn = append(zipfn, "./index.json")
	if nErr == 0 {
		fmt.Printf("%sSuccessfuil fetch of %d QR code images.%s\n", MiscLib.ColorGreen, nSucc, MiscLib.ColorReset)
		fmt.Printf("%sDestiations %d succ %d error%s\n", MiscLib.ColorGreen, nSuccDest, nErrDest, MiscLib.ColorReset)
	}
	if *Zip != "" {
		// Make the .zip file now
		os.Chdir(fmt.Sprintf("./%s", noEx))
		misc.MkZip(fmt.Sprintf("../%s", *Zip), zipfn...)
	}
}
