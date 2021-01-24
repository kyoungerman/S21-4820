package main

// Copyright (C) Philip Schlump 2016.
// MIT Licensed
// Source pulled from PureImagination Demo Server

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"time"

	"github.com/pschlump/godebug"
	"gitlab.com/pschlump/PureImaginationServer/auth_check"
	"gitlab.com/pschlump/PureImaginationServer/ymux"
)

// HandleExitServer - graceful server shutdown.
func HandleExitServer(www http.ResponseWriter, req *http.Request) {
	if !ymux.IsAuthKeyValid(www, req, &(gCfg.BaseConfigType)) {
		// if !ymux.IsAuthKeyValid(www, req, gCfg) {
		return
	}
	pid := os.Getpid()
	auth_check.SetJsonHdr(www, req)

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
	auth_check.SetJsonHdr(www, req)
	www.WriteHeader(http.StatusOK) // 200
	fmt.Fprintf(www, godebug.SVarI(gCfg))
}

// HandleKick - server to respond with a working message if up.
func HandleKick(www http.ResponseWriter, req *http.Request) {
	ch <- "kick" // on control-channel - send "kick"
	auth_check.SetJsonHdr(www, req)
	www.WriteHeader(http.StatusOK) // 200
	fmt.Fprintf(www, `{"status":"success","kick_sent":true}`+"\n")
	return
}

/* vim: set noai ts=4 sw=4: */
