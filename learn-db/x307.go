package main

// xyzzy000 Set per-user QR stuff

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"os"
	"strconv"
	"strings"

	"github.com/pschlump/MiscLib"
	"github.com/pschlump/godebug"
	"gitlab.com/pschlump/PureImaginationServer/base"
	"gitlab.com/pschlump/PureImaginationServer/q8stype"
	"gitlab.com/pschlump/PureImaginationServer/ymux"
)

func HandleQR307(www http.ResponseWriter, req *http.Request) {
	id := req.URL.Path[1:]
	if !base.IsBase60QRId(id) {
		www.WriteHeader(500) // Internal Server Error
		fmt.Fprintf(www, "Invalid ID reaced HandleQR307")
		return
	}

	foundQr60, qr60 := ymux.GetVar("qr60", www, req)
	fmt.Fprintf(os.Stderr, "qr60 = [%s] %v\n", qr60, foundQr60)

	nb := base.Decode60(id) // normalize ID
	id = base.Encode60(uint64(nb))

	// fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
	toURL, data, err := LookupID(www, req, id)
	if err != nil {
		fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
		www.WriteHeader(404) // Not Found
		fmt.Fprintf(www, "Unable to find id=[%s]", id)
		return
	}

	hasData := "no"
	if len(data) > 0 {
		hasData = "yes"
	}

	add := fmt.Sprintf("base10=%d&base60=%s&hasdata=%s", nb, id, hasData)

	qry := req.URL.RawQuery

	if DbOn["HandleQR307"] {
		fmt.Printf("qry [%s]\n", qry)
	}

	u, e := url.Parse(string(toURL))
	if e != nil {
		// xyzzy
		// xyzzy
		// xyzzy
		// xyzzy
	} else {
		if DbOn["HandleQR307"] {
			fmt.Printf("u.RawQuery [%s] at:%s\n", u.RawQuery, godebug.LF())
		}
		if u.RawQuery != "" {
			u.RawQuery = u.RawQuery + "&" + add
		} else {
			u.RawQuery = add
		}
		if DbOn["HandleQR307"] {
			fmt.Printf("u.RawQuery [%s] at:%s\n", u.RawQuery, godebug.LF())
		}
	}
	if qry != "" {
		if DbOn["HandleQR307"] {
			fmt.Printf("u.RawQuery [%s] at:%s\n", u.RawQuery, godebug.LF())
		}
		if u.RawQuery != "" {
			u.RawQuery = u.RawQuery + "&" + qry
		} else {
			u.RawQuery = qry
		}
		if DbOn["HandleQR307"] {
			fmt.Printf("u.RawQuery [%s] at:%s\n", u.RawQuery, godebug.LF())
		}
	}

	toURL = fmt.Sprintf("%s", u)

	// fmt.Fprintf(os.Stderr, "%sAT: %s%s\n", MiscLib.ColorYellow, godebug.LF(), MiscLib.ColorReset)
	// http.Redirect(www, req, toURL, http.StatusTemporaryRedirect) // 307
	// ymux.Redirect(www, req, toURL, http.StatusTemporaryRedirect) // 307
	ymux.Redirect(www, req, toURL, http.StatusSeeOther) // 303				-- Really ???
	return
}

/*
CREATE TABLE "t_qr_to" (
	  "id"				m4_uuid_type() DEFAULT uuid_generate_v4() not null primary key
	, "id60"			text not null
	, "id10"			bigint
	, "data"			text
	, "n_redir"			bigint default 0 not null
	, "url_to"			text
	, "owner_id"		char varying (40)
	, "group_tag"		text
	, "updated" 		timestamp
	, "created" 		timestamp default current_timestamp not null
);

*/

func LookupID(www http.ResponseWriter, req *http.Request, id string) (to, data string, err error) {
	stmt := `select "url_to", "data" from "t_qr_to" where "id60" = $1`
	err = ymux.SQLQueryRow(stmt, id).Scan(&to, &data)
	if err != nil {
		fmt.Fprintf(os.Stderr, "stmt [%s] id [%s] err [%s]\n", stmt, id, err)
		www.WriteHeader(404) // Not Found
		fmt.Fprintf(www, "Unable to find id=[%s]", id)
		return
	}
	return
}

func SetID(www http.ResponseWriter, req *http.Request, id, to, data, user_id string) (err error) {
	stmt := `update "t_qr_to" set "url_to" = $1, "data" = $3, "owner_id" = $4 where "id60" = $2`
	nb := base.Decode60(id) // normalize ID
	id = base.Encode60(uint64(nb))
	nr, err := ymux.SQLUpdate(stmt, to, id, data, user_id)
	if err != nil {
		fmt.Printf("xyzzy oopsy: %s error:%s\n", godebug.LF(), err)
		www.WriteHeader(500) // Not Found
		fmt.Fprintf(www, "Unable to update id=[%s]", id)
		return
	}
	if nr == 0 {
		stmt := `insert into "t_qr_to" ( "id60", "id10", "url_to", "data", "owner_id" ) values ( $1, $2, $3, $4, $5 )`
		err = ymux.SQLInsert(stmt, id, fmt.Sprintf("%d", nb), to, data, user_id)
		if err != nil {
			fmt.Printf("xyzzy oopsy: %s error:%s\n", godebug.LF(), err)
			www.WriteHeader(500) // Not Found
			fmt.Fprintf(www, "Unable to insert id=[%s]", id)
			return
		}
	}
	return
}

func SetData(www http.ResponseWriter, req *http.Request, id, data string) (err error) {
	stmt := `update "t_qr_to" set "data" = $1 where "id60" = $2`
	nb := base.Decode60(id) // normalize ID
	id = base.Encode60(uint64(nb))
	nr, err := ymux.SQLUpdate(stmt, data, id)
	if err != nil {
		fmt.Printf("xyzzy oopsy: %s error:%s\n", godebug.LF(), err)
		www.WriteHeader(500) // Not Found
		fmt.Fprintf(www, "Unable to update data on id=[%s], error:%s", id, err)
		return
	}
	if nr == 0 {
		fmt.Printf("xyzzy oopsy: %s error:%s\n", godebug.LF(), "0 rows updated")
		www.WriteHeader(404) // Not Found
		fmt.Fprintf(www, "Unable to update data on id=[%s], id not found", id)
		return
	}
	return
}

func GetID10and60(www http.ResponseWriter, req *http.Request) (id10 int, id10s, id60 string, err error) {
	var id10_64 int64
	found, id60 := ymux.GetVar("base60", www, req)
	if !found {
		found, id10s = ymux.GetVar("base10", www, req)
		if !found {
			www.WriteHeader(406) // Mal formed
			fmt.Fprintf(www, "Missing 'base60' or 'base10' in input")
			err = fmt.Errorf("Missing or invalid")
			return
		}
		id10_64, err = strconv.ParseInt(id10s, 10, 64)
		if err != nil {
			www.WriteHeader(406) // Mal formed
			fmt.Fprintf(www, "Invalbase 'base10', error:%s", err)
			return
		}
		id10 = int(id10_64)
		id60 = base.Encode60(uint64(id10_64))
	} else {
		id10 = int(base.Decode60(id60)) // normalize ID
		id60 = base.Encode60(uint64(id10))
		id10s = fmt.Sprintf("%d", id10)
	}
	return
}

// Return same as HandlQR307 but return as JSON instead of 307 redirect.
func HandleDecodeQR(www http.ResponseWriter, req *http.Request) {
	id10, _, id60, err := GetID10and60(www, req)
	if err != nil {
		return
	}

	toURL, data, err := LookupID(www, req, id60)
	if err != nil {
		www.WriteHeader(404) // Not Found
		fmt.Fprintf(www, "Unable to find id=[%s]", id60)
		return
	}

	hasData := "no"
	if len(data) > 0 {
		hasData = "yes"
	}
	add := fmt.Sprintf("base10=%d&base60=%s&hasdata=%s", id10, id60, hasData)

	qry := req.URL.RawQuery

	uu := string(toURL)
	sep := "?"
	if strings.Contains(toURL, "?") {
		sep = "&"
	}
	if qry != "" {
		uu += sep + qry
		sep = "&"
	}
	uu += sep + add

	toURL = uu

	setJsonHdr(www)
	fmt.Fprintf(www, `{"status":"success","to":%q,"data":%q}`+"\n", toURL, data)
	return
}

// Set QR of 'id' to a 307 redirect destination.
func HandleSetQR(www http.ResponseWriter, req *http.Request) {
	id10, id10s, id60, err := GetID10and60(www, req)
	if err != nil {
		return
	}
	_ = id10s

	found, to := ymux.GetVar("url_to", www, req)
	if !found {
		www.WriteHeader(406) // Mal formed
		fmt.Fprintf(www, "Missing 'url_to' input")
		return
	}

	foundData, data := ymux.GetVar("data", www, req)
	if !foundData {
		data = ""
	}
	foundUserID, user_id := ymux.GetVar("user_id", www, req)
	if !foundUserID {
		user_id = ""
	}

	// ---------------------------------------------------------------------------------------------------------------------
	// xyzzy000 Set per-user QR stuff
	// ---------------------------------------------------------------------------------------------------------------------
	nth := id10
	pth := fmt.Sprintf("./qr/qr_%05d", nth/100)
	// func UserDecorateQR(pth string, beg, end int, Tag, ImageTag string) {
	Tag := "Salvation Army"
	ImageTag := "./www/user/c0b71df9-e258-49ec-b912-bf69ff31481b/sa-60x60.png"
	UserDecorateQR(pth, nth, nth, Tag, ImageTag)
	// ---------------------------------------------------------------------------------------------------------------------

	err = SetID(www, req, id60, to, data, user_id)
	if err != nil {
		return
	}

	setJsonHdr(www)
	www.WriteHeader(200) // Not Found
	fmt.Fprintf(www, `{"status":"success"}`)
}

// Set QR of 'id' data for later retreval.
func HandleSetDataQR(www http.ResponseWriter, req *http.Request) {
	/*id10 */ _ /*id10s*/, _, id60, err := GetID10and60(www, req)
	if err != nil {
		return
	}

	found, data := ymux.GetVar("data", www, req)
	if !found {
		www.WriteHeader(406) // Mal formed
		fmt.Fprintf(www, "Missing 'data' input")
		return
	}

	err = SetData(www, req, id60, data)
	if err != nil {
		return
	}
	setJsonHdr(www)
	www.WriteHeader(200) // Not Found
	fmt.Fprintf(www, `{"status":"success"}`)
}

// UpdateRespItem is a output type used to respond to bulk udpate
// request.  It itemises success/fail and error messages for each
// of the bulk items.
type UpdateRespItem struct {
	ID  string `json:"Id"` // base 10 id
	Msg string `json:"msg"`
	Pos int
}

// HandleBulkLoadQR returns a closure that handles /enc/ path.
func HandleBulkLoadQR(www http.ResponseWriter, req *http.Request) {
	if DbOn["bulk-load"] {
		fmt.Printf("BulkLoad: %s, %s\n", godebug.SVarI(req), godebug.LF())
	}
	foundUpdate, updateStr := ymux.GetVar("update", www, req)
	if !foundUpdate {
		www.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(www, "Error: Missing 'update' parameter\n")
		return
	}
	foundUserID, user_id := ymux.GetVar("user_id", www, req)

	_ = foundUserID // xyzzy

	var update q8stype.UpdateData
	if DbOn["bulk-load"] {
		fmt.Printf("->%s<-, %s\n", updateStr, godebug.LF())
	}
	err := json.Unmarshal([]byte(updateStr), &update)
	if err != nil {
		www.WriteHeader(http.StatusInternalServerError) // 500 is this the correct error to return at this point?
		fmt.Fprintf(logFilePtr, "BulkLoad: parse error: %v, %s, %s\n", update, err, godebug.LF())
		fmt.Fprintf(www, "Error: parse error: %s\n", err)
		return
	}
	if DbOn["bulk-load"] {
		fmt.Printf("Parsed Data: ->%s<-, %s\n", godebug.SVarI(update), godebug.LF())
	}

	var respSet []UpdateRespItem
	for ii, dat := range update.Data {
		e := ""
		if dat.ID60 == "" && dat.ID10s == "" {
			e = fmt.Sprintf("missing id10 and id60 parameter")
			respSet = append(respSet, UpdateRespItem{ID: dat.ID10s, Msg: e, Pos: ii})
			continue
		} else if dat.ID10s != "" && dat.ID60 == "" {
			nb, _ := strconv.ParseInt(dat.ID10s, 10, 64)
			dat.ID60 = base.Encode60(uint64(nb))
		} else if dat.ID60 != "" && dat.ID10s == "" {
			if !base.IsBase60QRId(dat.ID60) {
				e = fmt.Sprintf("Invalid base60 parameter, [%s]", dat.ID60)
				respSet = append(respSet, UpdateRespItem{ID: dat.ID10s, Msg: e, Pos: ii})
				continue
			}
			nb := base.Decode60(dat.ID60)
			dat.ID10s = fmt.Sprintf("%d", nb)
		}
		err = SetID(www, req, dat.ID60, dat.URL, dat.Data, user_id)
		if err != nil {
			e = fmt.Sprintf("Error: %s", err)
		}
		respSet = append(respSet, UpdateRespItem{ID: dat.ID10s, Msg: e, Pos: ii})
	}
	resp := godebug.SVarI(respSet)

	www.Header().Set("Content-Length", fmt.Sprintf("%d", len(resp)))
	www.Header().Set("Length", fmt.Sprintf("%d", len(resp)))
	setJsonHdr(www)
	fmt.Fprintf(www, "%s", resp)
	fmt.Fprintf(logFilePtr, "Bulk Load: %s = %s\n", updateStr, godebug.SVarI(respSet))
	return
}

func HandleDelQR(www http.ResponseWriter, req *http.Request) {
	/*id10*/ _ /*id10s*/, _, id60, err := GetID10and60(www, req)
	if err != nil {
		return
	}

	stmt := `update "t_qr_to" set "owner_id" = 'del:'||"owner_id", "url_to" = 'http://app.q8s.co/demo.html' where "id60" = $1`
	nr, err := ymux.SQLUpdate(stmt, id60)

	_ = nr
	_ = err

	setJsonHdr(www)
	fmt.Fprintf(www, `{"status":"success"}`)
	return
}

func HandleUnDelQR(www http.ResponseWriter, req *http.Request) {
	/*id10*/ _ /*id10s*/, _, id60, err := GetID10and60(www, req)
	if err != nil {
		return
	}

	_ = id60

	setJsonHdr(www)
	fmt.Fprintf(www, `{"status":"success"}`)
	return
}
