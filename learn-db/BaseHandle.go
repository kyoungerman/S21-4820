package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"time"

	"github.com/pschlump/godebug"
	"gitlab.com/pschlump/PureImaginationServer/ymux"
)

// HandleStatus - server to respond with a working message if up.
func HandleStatus(www http.ResponseWriter, req *http.Request) {
	var add string
	add = ""
	found, id := ymux.GetVar("id", www, req)
	if found {
		if id == "dump-request" {
			add = fmt.Sprintf(`, "request": %s `, godebug.SVarI(req))
		}
	}
	pid := os.Getpid()
	setJsonHdr(www)
	www.WriteHeader(http.StatusOK) // 200
	fmt.Fprintf(www, `{"status":"success", "version":%q, "pid":%v %s}`+"\n", GitCommit, pid, add)
	return
}

// HandleExitServer - graceful server shutdown.
func HandleExitServer(www http.ResponseWriter, req *http.Request) {
	if !ymux.IsAuthKeyValid(www, req, &(gCfg.BaseConfigType)) {
		return
	}
	pid := os.Getpid()
	setJsonHdr(www)

	www.WriteHeader(http.StatusOK) // 200
	fmt.Fprintf(www, `{"status":"success", "version":%q, "pid":%v}`+"\n", GitCommit, pid)

	go func() {
		// Implement graceful exit with auth_key
		fmt.Fprintf(os.Stderr, "\nShutting down the server... Received /exit-server?auth_key=...\n")
		fmt.Fprintf(logFilePtr, "\nShutting down the server... Received /exit-server?auth_key=...\n")
		for _, httpServer := range httpServerList {
			ctx, cancel := context.WithTimeout(context.Background(), shutdownWaitTime*time.Second)
			defer cancel()
			err := httpServer.Shutdown(ctx)
			if err != nil {
				fmt.Printf("Error on shutdown: [%s]\n", err)
			}
		}
	}()
}

func HandleConfig(www http.ResponseWriter, req *http.Request) {
	if !ymux.IsAuthKeyValid(www, req, &(gCfg.BaseConfigType)) {
		return
	}
	setJsonHdr(www)
	www.WriteHeader(http.StatusOK) // 200
	fmt.Fprintf(www, godebug.SVarI(gCfg))
}

// HandleKick - server to respond with a working message if up.
func HandleKick(www http.ResponseWriter, req *http.Request) {
	ch <- "kick" // on control-channel - send "kick"
	setJsonHdr(www)
	www.WriteHeader(http.StatusOK) // 200
	fmt.Fprintf(www, `{"status":"success","kick_sent":true}`+"\n")
	return
}

/* vim: set noai ts=4 sw=4: */
