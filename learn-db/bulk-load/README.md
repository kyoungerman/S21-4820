
Use a CSV file to create/setup QR Codes

3 Columns in the CSV file

1. The base10 version of the ID.

2. The base60 versio of the id or omitted.  You need to specify one of base10, or base60.

3. The Destination URL with templating to send this to.

4. The data to be associated with this QR

Example:

```
3,,http://www.2c-why.com/demo3?id60={{.id60}}
,400,http://www.2c-why.com/demo3?id60={{.id60}}&id10={{.id10}}&tom=jerry
```

On the first line set the QR with an id of 3 (base 10) to `http://www.2c-why.com/demo3?id60=3`.

ON the 2nd line set the QR with a base 60 id of 400 to `http://www.2c-why.com/demo3?id60=400&id10=5184&tom=jerry`.


