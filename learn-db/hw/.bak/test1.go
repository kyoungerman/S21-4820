package main

/*
	To setup go do a google search for "install golang" and follow the OS specific instructions.

	Then do

		$ go get
		$ go run test1.go
*/

import (
	"fmt"

	"gitlab.com/pschlump/PureImaginationServer/ymux"
)

func main() {
	uuid := ymux.GenUUID()
	fmt.Printf("%s\n", uuid)
}
