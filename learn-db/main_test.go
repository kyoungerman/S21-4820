package main

import (
	"net/http"
	"net/url"
	"testing"

	"gitlab.com/pschlump/PureImaginationServer/CliResponseWriter"
)

// Test all of the functions in the main program

func Test_BulkLoad(t *testing.T) {
	// t.Fatal("not implemented")
	// mux.Handle("/api/v2/bulk-load", http.HandlerFunc(HandleBulkLoadQR)).Method("GET", "POST").AuthRequired().NoDoc() // xyzzy - imlement.

	Cli := "/api/v2/bulk-load"

	www := CliResponseWriter.NewCliResonseWriter() // www := http.ResponseWriter
	/*
	   type url.URL struct {
	   	Scheme     string
	   	Opaque     string    // encoded opaque data
	   	User       *Userinfo // username and password information
	   	Host       string    // host or host:port
	   	Path       string    // path (relative paths may omit leading slash)
	   	RawPath    string    // encoded path hint (see EscapedPath method)
	   	ForceQuery bool      // append a query ('?') even if RawQuery is empty
	   	RawQuery   string    // encoded query values, without '?'
	   	Fragment   string    // fragment for references, without '#'
	   }
	   // From: https://golang.org/src/net/url/url.go?s=9736:10252#L353 :363
	*/
	// qryParam := GetVar.GenQryFromCli()
	qryParam := "user_id=xyzzy"

	u := url.URL{
		User:     nil,
		Host:     "127.0.0.1:80",
		Path:     Cli,
		RawQuery: qryParam,
	}
	req := &http.Request{ // https://golang.org/src/net/http/request.go:113
		Method:     "GET",
		URL:        &u, // *url.URL
		Proto:      "HTTP/1.0",
		ProtoMajor: 1,
		ProtoMinor: 0,
		Header:     make(http.Header),
		// Body io.ReadCloser // :182 -- not used, GET request - no body.
		// Form url.Values -- Populate with values from CLI
		Host:       "127.0.0.1:80",
		RequestURI: Cli + "?" + qryParam, // "RequestURI": "/api/v1/status?id=dump-request",
	}
	HandleBulkLoadQR(www, req)
}
