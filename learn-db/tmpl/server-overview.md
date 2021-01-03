# Server Overview

## Validation of Stored Procedures

At startup a check is made that all declared stored procedures (database functions)
are availabe.  If they are then a message 
```
Found function: name
```
is printed for each one.  All of these functions are from ./handle.go and from the
checks included in the Makefile build process.

## Validation of Tables 

The makefile includes:
```
gen:
	check-json-syntax cfg.json
	~/go/src/gitlab.com/pschlump/PureImaginationServer/bin/validate_script.sh "t_ymux_user"  "t_ymux_2fa" "t_ymux_2fa_dev_otk"
```
that generates a check for the tables and columns for the listed tables.  It is assumed that when this is run the
table will be correct in the database and this is what you want to check for.

At startup this list of tables and columns is validated.  Tables may contain extra columns.


## Import of Mustache Templates into index.html

The tool `./mtp/mtp.go` (the ./mt processor) takes the templates in ./mt and converts them to be included in the ./www/index.html.
The source for this is ./www-src/index.html.  ./www/index.html is generated.  Also the tool will
look for a cache-burst value and replace that with a counter that counts up.  All of the files in
./www/js will result in this re-generate and cache burst effect.

The makefile includes

```
start_watch:
	( cd mtp ; go build )
	./mtp/mtp --watch \
		--cache-burst-override 108 \
		./www-src/index.html \
		&
```

to continuously watch for changes and update the index.html file.

