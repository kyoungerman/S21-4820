package main

import (
	"bufio"
	"encoding/csv"
	"fmt"
	"io"
	"os"
	"strconv"

	"github.com/pschlump/godebug"
	"gitlab.com/pschlump/PureImaginationServer/base"
	"gitlab.com/pschlump/PureImaginationServer/misc"
	"gitlab.com/pschlump/q8s-server/q8stype"
)

func ReadData(fn string) (raw q8stype.UpdateData) {
	csvFile, err := os.Open(fn)
	if err != nil {
		fmt.Fprintf(os.Stderr, "Error reading data, unable to open file: %s\n", err)
		os.Exit(1)
	}
	reader := csv.NewReader(bufio.NewReader(csvFile))
	line_no := 0
	for {
		line_no++
		line, err := reader.Read()
		if err == io.EOF {
			break
		}
		if err != nil {
			fmt.Fprintf(os.Stderr, "Error reading data, unable to open file: %s\n", err)
			os.Exit(1)
		}
		if DbFlag["ShowInputLine"] {
			fmt.Printf("line = %s\n", godebug.SVarI(line))
		}
		// http://www.2c-why.com/demo3?id={{.id60}},{{.id}}
		u10 := line[0]
		u60 := line[1]
		UrlTmpl := line[2]
		Data := line[3]
		mdata := make(map[string]interface{}) // Data for template

		mdata["LineNo"] = line_no
		mdata["URL"] = UrlTmpl
		mdata["ID"] = u10
		mdata["ID10"] = u10
		mdata["ID60"] = u60

		if u10 == "" {
			nb := base.Decode60(u60)
			u10 = fmt.Sprintf("%d", nb)
			mdata["ID"] = u10
			mdata["ID10"] = u10
		}
		v, err := strconv.ParseInt(u10, 10, 64)
		if err != nil {
			fmt.Printf("Error: unable to parse int [%s] error %s line no: %d\n", u60, err, line_no)
		}
		u10n := int(v)
		mdata["id"] = u10n
		mdata["id10"] = u10n
		mdata["id60"] = base.Encode60(uint64(u10n))
		URLfinal := misc.ExecuteATemplate(UrlTmpl, mdata)
		raw.Data = append(raw.Data, q8stype.UpdateDataRow{
			URL:   URLfinal,
			ID10s: u10,
			ID10n: u10n,
			ID60:  u60,
			Data:  Data,
		})
	}
	return raw
}
