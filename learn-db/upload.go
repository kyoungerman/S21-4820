package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"

	"github.com/pschlump/HashStrings"
	"github.com/pschlump/MiscLib"
	"github.com/pschlump/godebug"
	"gitlab.com/pschlump/PureImaginationServer/ymux"
)

//old/'
//old/'//	"github.com/ethereum/go-ethereum/accounts/keystore"
//old/'//	"github.com/ethereum/go-ethereum/common"
//old/'//	"github.com/ethereum/go-ethereum/crypto"
//old/'
//old/'func UploadFileClosure(pth string) func(w http.ResponseWriter, r *http.Request) {
//old/'
//old/'	if !filelib.Exists(pth) {
//old/'		fmt.Printf("Missing directory [%s] creating it\n", pth)
//old/'		os.MkdirAll(pth, 0755)
//old/'	}
//old/'
//old/'	// UploadFile uploads a file to the server
//old/'	return func(w http.ResponseWriter, r *http.Request) {
//old/'		if r.Method != "POST" {
//old/'			fmt.Printf("AT: %s\n", godebug.LF())
//old/'			jsonResponse(w, http.StatusBadRequest, "Should be a POST request.")
//old/'			return
//old/'		}
//old/'
//old/'		r.ParseMultipartForm(32 << 20)
//old/'		id := r.FormValue("id")
//old/'		fmt.Printf("Id=%s\n", id)
//old/'		file, handle, err := r.FormFile("file")
//old/'		if err != nil {
//old/'			fmt.Printf("AT: %s err [%v]\n", godebug.LF(), err)
//old/'			jsonResponse(w, http.StatusBadRequest, fmt.Sprintf(`{"status":"error","msg":"Error reading file data: %s"}`, err))
//old/'			return
//old/'		}
//old/'		defer file.Close()
//old/'
//old/'		mimeType := handle.Header.Get("Content-Type")
//old/'		fmt.Printf("mimeType [%s]\n", mimeType)
//old/'
//old/'		var file_name, aws_file_name, orig_file_name, file_hash, url_file_name string
//old/'		_ = file_hash
//old/'		switch mimeType {
//old/'		case "image/jpeg":
//old/'			file_name, aws_file_name, orig_file_name, file_hash, url_file_name, err = saveFile(w, file, handle, ".jpg", pth)
//old/'		case "image/png":
//old/'			file_name, aws_file_name, orig_file_name, file_hash, url_file_name, err = saveFile(w, file, handle, ".png", pth)
//old/'		case "application/pdf":
//old/'			file_name, aws_file_name, orig_file_name, file_hash, url_file_name, err = saveFile(w, file, handle, ".pdf", pth)
//old/'		default:
//old/'			fmt.Printf("AT: %s\n", godebug.LF())
//old/'			jsonResponse(w, http.StatusBadRequest, fmt.Sprintf(`{"status":"error","msg":"The file format (mimeType=%s) is not valid."}`, mimeType))
//old/'			return
//old/'		}
//old/'
//old/'		// push file to AWS S3
//old/'		if DbOn["push-to-aws"] {
//old/'			err = awss3.AddFileToS3(awsSession, file_name, aws_file_name)
//old/'			if err != nil {
//old/'				fmt.Printf("AT: %s err=%v\n", godebug.LF(), err)
//old/'				jsonResponse(w, http.StatusBadRequest, `{"status":"error","msg":"Failed to push file to S3."}`)
//old/'				return
//old/'			}
//old/'		}
//old/'
//old/'		/*
//old/'			   update "t_paper_docs" set "file_name" = $2, "orig_file_name" = $3 where "id" = $1, id=e02587d8-8084-4856-563e-806b92c2e2e9,
//old/'					file_name=./files/e8a864cb348747641cb1be134829f754515204347874550d316520dda0b37f78.jpg, orig_file_name=alaska.jpg aws_file_name=%!s(MISSING)
//old/'			   		stmt := `update "documents" set "file_name" = $2, "orig_file_name" = $3 where "id" = $1`
//old/'			   AT: File: /Users/corwin/go/src/github.com/Univ-Wyo-Education/S19-4010/l/23/ssvr/upload.go LineNo:63 err=no such table: t_paper_docs
//old/'		*/
//old/'		stmt := `update "documents" set "file_name" = $2, "orig_file_name" = $3, "url_file_name" = $4 where "id" = $1`
//old/'		fmt.Printf("stmt = %s, id=%s, file_name=%s, orig_file_name=%s\n", stmt, id, file_name, orig_file_name)
//old/'
//old/'		_, err = ymux.SQLUpdate(stmt, id, file_name, orig_file_name, url_file_name)
//old/'		if err != nil {
//old/'			fmt.Printf("AT: %s err=%v\n", godebug.LF(), err)
//old/'			jsonResponse(w, http.StatusBadRequest, fmt.Sprintf(`{"status":"error","msg":"Failed to save data to PG. error=%s"}`, err))
//old/'			return
//old/'		}
//old/'
//old/'		/* ----- PJS - temp comment out
//old/'		// call contract at this point.
//old/'		app := fmt.Sprintf("%x", HashStrings.HashStrings("app.signedcontract.com"))
//old/'		msgHash, signature, err := SignMessage(file_hash, gCfg.AccountKey)
//old/'		if err != nil {
//old/'			fmt.Printf("Failed to sign message: error: %s\n", err)
//old/'			jsonResponse(w, http.StatusBadRequest, fmt.Sprintf(`{"status":"error","msg":"Failed to sign document. error=%s"}`, err))
//old/'			return
//old/'		}
//old/'
//old/'		// name := fmt.Sprintf("%x", msgHash)
//old/'		// sig := fmt.Sprintf("%x", signature)
//old/'
//old/'		var txID string
//old/'
//old/'		tx, err := gCfg.ASignedDataContract.SetData(app, msgHash, signature)
//old/'		if err != nil {
//old/'			fmt.Printf("AT: %s err=%v\n", godebug.LF(), err)
//old/'			// AT: File: /Users/pschlump/go/src/github.com/pschlump/tools/hemp-demo/upload.go LineNo:103 err=failed to retrieve account nonce: write tcp 127.0.0.1:63407->127.0.0.1:9545: i/o timeout --- xyzzyNonce
//old/'			// jsonResponse(w, http.StatusBadRequest, fmt.Sprintf(`{"status":"error","msg":"Failed to call contract. error=%s"}`, err))
//old/'			// return
//old/'
//old/'			txID = "pending"
//old/'			stmt = `update "documents" set "txid" = $2, "hash" = $3, "signature" = $4 where "id" = $1`
//old/'			fmt.Printf("stmt = %s, id=%s, txID=%s name(hash)=%s signature=%s\n", stmt, id, txID, msgHash, signature)
//old/'
//old/'			err = ymux.SQLUpdate(stmt, id, txID, msgHash, signature)
//old/'			if err != nil {
//old/'				fmt.Printf("AT: %s err=%v\n", godebug.LF(), err)
//old/'				jsonResponse(w, http.StatusBadRequest, fmt.Sprintf(`{"status":"error","msg":"Failed to save txID to PG. error=%s"}`, err))
//old/'				return
//old/'			}
//old/'
//old/'		} else {
//old/'
//old/'			fmt.Printf("*** Type of tx %T\ndata=%s", tx, godebug.SVarI(tx))
//old/'
//old/'			txID = fmt.Sprintf("%x", godebug.SVar(tx))
//old/'			stmt = `update "documents" set "txid" = $2, "hash" = $3, "signature" = $4 where "id" = $1`
//old/'			fmt.Printf("stmt = %s, id=%s, txID=%s name(hash)=%s signature=%s\n", stmt, id, txID, msgHash, signature)
//old/'
//old/'			err = ymux.SQLUpdate(stmt, id, txID, msgHash, signature)
//old/'			if err != nil {
//old/'				fmt.Printf("AT: %s err=%v\n", godebug.LF(), err)
//old/'				jsonResponse(w, http.StatusBadRequest, fmt.Sprintf(`{"status":"error","msg":"Failed to save txID to PG. error=%s"}`, err))
//old/'				return
//old/'			}
//old/'
//old/'		}
//old/'
//old/'		jsonResponse(w, http.StatusCreated, fmt.Sprintf(`{"status":"success","txID":%q,"aws_file_name":%q,"id":%q}`, txID, aws_file_name, id))
//old/'		*/
//old/'		jsonResponse(w, http.StatusCreated, fmt.Sprintf(`{"status":"success","txID":%q,"aws_file_name":%q,"id":%q}`, "xyzzy", aws_file_name, id))
//old/'
//old/'	}
//old/'}
//old/'
//old/'// 15e42502-e7a5-44e2-6920-b410b9308412
//old/'//    insert into t_paper_docs ("id" ) values ( '15e42502-e7a5-44e2-6920-b410b9308412' );
//old/'
//old/'func saveFile(w http.ResponseWriter, file multipart.File, handle *multipart.FileHeader, ext string, pth string) (file_name, aws_file_name, orig_file_name, file_hash, url_file_name string, err error) {
//old/'	var data []byte
//old/'	data, err = ioutil.ReadAll(file)
//old/'	if err != nil {
//old/'		jsonResponse(w, http.StatusBadRequest, fmt.Sprintf(`{"status":"error","msg":"Failed to save read file. error=%s"}`, err))
//old/'		return
//old/'	}
//old/'
//old/'	orig_file_name = handle.Filename
//old/'	file_hash_byte := HashStrings.HashBytes(data)
//old/'	file_hash = fmt.Sprintf("%x", file_hash_byte)
//old/'	aws_file_name = fmt.Sprintf("%s%s", file_hash, ext)
//old/'	url_file_name = fmt.Sprintf("%s/%s%s", gCfg.URLUploadPath, file_hash, ext)
//old/'	file_name = fmt.Sprintf("%s/%s%s", pth, file_hash, ext)
//old/'
//old/'	err = ioutil.WriteFile(file_name, data, 0644)
//old/'	if err != nil {
//old/'		jsonResponse(w, http.StatusBadRequest, fmt.Sprintf(`{"status":"error","msg":"Failed to save write file. error=%s"}`, err))
//old/'		return
//old/'	}
//old/'	return
//old/'}

func HashFile(file_name string) (file_hash string, err error) {
	var data []byte
	data, err = ioutil.ReadFile(file_name)
	if err != nil {
		err = fmt.Errorf(`Failed to read file. error:%s`, err)
		return
	}

	file_hash_byte := HashStrings.HashBytes(data)
	file_hash = fmt.Sprintf("%x", file_hash_byte)
	return
}

func jsonResponse(w http.ResponseWriter, code int, message string) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(code)
	fmt.Fprint(w, message)
}

/* ----- PJS - temp comment out
func SignMessage(message string, key *keystore.Key) (msgHash string, signature string, err error) {
	messageByte, err := hex.DecodeString(message)
	if err != nil {
		return "", "", fmt.Errorf("unabgle to decode message (invalid hex data) Error:%s", err)
	}
	rawSignature, err := crypto.Sign(signHash(messageByte), key.PrivateKey) // Sign Raw Bytes, Return hex of Raw Bytes
	if err != nil {
		return "", "", fmt.Errorf("unable to sign message Error:%s", err)
	}
	signature = hex.EncodeToString(rawSignature)
	return message, signature, nil
}

func ValidateMessage(file_name, sig string, key *keystore.Key) error {
	msg, err := HashFile(file_name)
	if DbOn["ValidateMessage"] {
		fmt.Printf("hash from reading file [%s]\n", msg)
	}
	if err != nil {
		return err
	}
	_, _, err = VerifySignature(gCfg.FromAddress, sig, msg)
	return err
}

// VerifySignature takes hex encoded addr, sig and msg and verifies that the signature matches with the address.
func VerifySignature(addr, sig, msg string) (recoveredAddress, recoveredPublicKey string, err error) {
	message, err := hex.DecodeString(msg)
	if err != nil {
		return "", "", fmt.Errorf("unabgle to decode message (invalid hex data) Error:%s", err)
	}
	if !common.IsHexAddress(addr) {
		return "", "", fmt.Errorf("invalid address: %s", addr)
	}
	address := common.HexToAddress(addr)
	signature, err := hex.DecodeString(sig)
	if err != nil {
		return "", "", fmt.Errorf("signature is not valid hex Error:%s", err)
	}

	if DbOn["ValidateMessage"] {
		fmt.Printf("AT: %s\n", godebug.LF())
	}

	recoveredPubkey, err := crypto.SigToPub(signHash([]byte(message)), signature)
	if err != nil || recoveredPubkey == nil {
		return "", "", fmt.Errorf("signature verification failed Error:%s", err)
	}
	recoveredPublicKey = hex.EncodeToString(crypto.FromECDSAPub(recoveredPubkey))
	rawRecoveredAddress := crypto.PubkeyToAddress(*recoveredPubkey)
	if DbOn["ValidateMessage"] {
		fmt.Printf("AT: %s recoveredPublicKey: [%s] recoved address [%x] compare to [%x]\n", godebug.LF(), recoveredPublicKey, rawRecoveredAddress, address)
	}
	if address != rawRecoveredAddress {
		return "", "", fmt.Errorf("signature did not verify, addresses did not match")
	}
	recoveredAddress = rawRecoveredAddress.Hex()
	return
}

// signHash is a helper function that calculates a hash for the given message
// that can be safely used to calculate a signature from.
//
// The hash is calulcated as
//   keccak256("\x19Ethereum Signed Message:\n"${message length}${message}).
//
// This gives context to the signed message and prevents signing of transactions.
func signHash(data []byte) []byte {
	msg := fmt.Sprintf("\x19Ethereum Signed Message:\n%d%s", len(data), data)
	return crypto.Keccak256([]byte(msg))
}
*/

func HandleValidateDocument(www http.ResponseWriter, req *http.Request) {

	if !ymux.IsAuthKeyValid(www, req, &(gCfg.BaseConfigType)) {
		fmt.Printf("%sAT: %s api_key wrong\n%s", MiscLib.ColorRed, godebug.LF(), MiscLib.ColorReset)
		return
	}

	// parameters id= Id of the document - use to get signature info, file name etc.
	found, id := ymux.GetVar("id", www, req)
	if !found || id == "" {
		www.WriteHeader(406) // Invalid Request
		return
	}

	//

	stmt := "select file_name, hash, signature from documents where id = $1"
	var file_name, msg, sig string
	err := ymux.SQLQueryRow(stmt, id).Scan(&file_name, &msg, &sig)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error fetching return data form ->%s<- id=%s error %s at %s\n", stmt, id, err, godebug.LF())
		www.WriteHeader(http.StatusInternalServerError) // 500
		return
	}
	if DbOn["HandleValidateDocument"] {
		fmt.Printf("AT:%s document_file_name [%s] hash [%s] signature [%s]\n", godebug.LF(), file_name, msg, sig)
	}

	rv := `{"status":"success"}`
	/* ----- PJS - temp comment out
	app := fmt.Sprintf("%x", HashStrings.HashStrings("app.signedcontract.com"))
	sig2, err := gCfg.ASignedDataContract.GetData(app, msg)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error fetching return data form getData/Contract id=%s error %s at %s\n", id, err, godebug.LF())
		www.WriteHeader(http.StatusInternalServerError) // 500
		return
	}

	if sig != sig2 {
		fmt.Fprintf(os.Stderr, "%s signature did not match data \n>%s< sig vs \n>%s< sig2%s\n", MiscLib.ColorRed, sig, sig2, MiscLib.ColorReset)
	} else {
		fmt.Fprintf(os.Stderr, "%s signature match \n>%s< sig vs \n>%s< sig2%s\n", MiscLib.ColorGreen, sig, sig2, MiscLib.ColorReset)
	}

	// Check signature, if ok then JSON {success}
	err = ValidateMessage(file_name, sig, gCfg.AccountKey)
	if err != nil {
		rv = `{"status":"error","msg":"signature did not verify"}`
	}
	if DbOn["HandleValidateDocument"] {
		fmt.Printf("AT:%s rv [%s]\n", godebug.LF(), rv)
	}
	*/

	if isTLS {
		www.Header().Add("Strict-Transport-Security", "max-age=63072000; includeSubDomains")
	}
	www.Header().Set("Content-Type", "application/json; charset=utf-8")
	www.WriteHeader(http.StatusOK) // 200
	fmt.Fprintf(www, "%s", rv)
	return
}
