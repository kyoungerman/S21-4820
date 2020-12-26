package main

import (
	"fmt"
	"net/http"
	"net/url"
	"strconv"
	"strings"

	"github.com/pschlump/godebug"
	"gitlab.com/pschlump/PureImaginationServer/base"
	"gitlab.com/pschlump/PureImaginationServer/ymux"
)

func setJsonHdr(www http.ResponseWriter) {
	if isTLS {
		www.Header().Add("Strict-Transport-Security", "max-age=63072000; includeSubDomains")
	}
	www.Header().Set("Content-Type", "application/json; charset=utf-8")
}

// HandleConv60To10 convert from a base 60 ID to a base 10 version. The base 60 is used inside the QR code.
// Limited to 63 bit integers.
func HandleConv60To10(www http.ResponseWriter, req *http.Request) {
	/*id10*/ _ /*id10s*/, _, id60, err := GetID10and60(www, req)
	if err != nil {
		return
	}
	nb := base.Decode60(id60)
	setJsonHdr(www)
	www.WriteHeader(http.StatusOK) // 200
	fmt.Fprintf(www, `{"status":"success","base10":%d}`, nb)
}

// HandleConv10To60 convert from a base 10 ID to a base 60 version. The base 60 is used inside the QR code.
// Limited to 63 bit integers.
func HandleConv10To60(www http.ResponseWriter, req *http.Request) {
	id10 /*id10s*/, _ /*id60*/, _, err := GetID10and60(www, req)
	if err != nil {
		return
	}
	rv := base.Encode60(uint64(id10))
	setJsonHdr(www)
	www.WriteHeader(http.StatusOK) // 200
	fmt.Fprintf(www, `{"status":"success","base60":%q}`, rv)
}

// HandleGenQRURL will generate the QR iamge URL for a ID.
func HandleGenQRURL(www http.ResponseWriter, req *http.Request) {
	id10 /*id10s*/, _ /*id60*/, _, err := GetID10and60(www, req)
	if err != nil {
		return
	}
	found1, baseUrl := ymux.GetVar("baseUrl", www, req)
	if !found1 {
		baseUrl = gCfg.QRGeneration.BaseServerUrl
	}

	// chop off last char if it is a '/'
	if baseUrl[len(baseUrl)-1:] == "/" {
		baseUrl = baseUrl[0 : len(baseUrl)-1]
	}

	URLToUse := fmt.Sprintf("%s/qr/qr_%05d/q%05d.4.png", baseUrl, id10/100, id10)
	rv := fmt.Sprintf(`{"status":"success", "url":%q}`, URLToUse)

	setJsonHdr(www)
	www.WriteHeader(http.StatusOK) // 200
	fmt.Fprintf(www, `%s`, rv)
	return
}

// HandleParseQRURL will take the URL for a QR image and parse it and return the parts.
func HandleParseQRURL(www http.ResponseWriter, req *http.Request) {
	var rv string
	found, rawUrl := ymux.GetVar("qr_url", www, req)
	if found {
		uu, err := url.Parse(rawUrl)
		if err != nil {
			rv = fmt.Sprintf(`{"status":"error", "msg":"invalid url parameter, %s"}`, err)
		} else {
			if DbOn["HandleParseQRURL"] {
				fmt.Printf("%s, AT:%s\n", godebug.SVarI(uu), godebug.LF())
			}
			Path := uu.Path // "/qr/qr_00026/q02611.4.png"
			Comp := strings.Split(Path, "/")
			if DbOn["HandleParseQRURL"] {
				fmt.Printf("Comp: %s\n", godebug.SVarI(Comp))
			}
			if len(Comp) == 4 && len(Comp[2]) > 3 && len(Comp[3]) > 6 {
				Set, err1 := strconv.ParseInt(Comp[2][3:], 10, 64)
				Id10, err2 := strconv.ParseInt(Comp[3][1:6], 10, 64)
				if DbOn["HandleParseQRURL"] {
					fmt.Printf("Set:%d err1:%s Id10:%d err2:%s\n", Set, err1, Id10, err2)
				}
				Id60 := base.Encode60(uint64(Id10))
				rv = fmt.Sprintf(`{"status":"success", "set":%d, "id10":%d, "id60":%q}`, Set, Id10, Id60)
			} else {
				rv = fmt.Sprintf(`{"status":"error", "msg":"invalid url parameter, %s"}`, "incorrect format for QR url")
			}
		}
	} else {
		rv = `{"status":"error", "msg":"missing val parameter"}`
	}
	setJsonHdr(www)
	www.WriteHeader(http.StatusOK) // 200
	fmt.Fprintf(www, `%s`, rv)
	return
}

/* vim: set noai ts=4 sw=4: */
