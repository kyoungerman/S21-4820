# Design

## /api/get-qr?n=XXX

Allocates a QR code from available supply - non-user.

Returns a QR Id in base 10 and 60, the URL for the qr image.  If n is not supplied then 1 QR
is returned.  if n is supplied then a set of QRs can be allocated.  Max is 35.


## /api/user-get-qr?n=XXX

Allocates a QR code from available supply - non-user for this user.  If none left then will pull one from
available supply (global)

Returns a QR Id in base 10 and 60, the URL for the qr image.  If n is not supplied then 1 QR
is returned.  if n is supplied then a set of QRs can be allocated.  Max is 3500.

A "logo" in the top left can be merged with the QR codes.  The images are returned in 3 formats.
1. just the QR
2. QR + text and ID info on image.
3. QR + test and ID info and logo merged with image.

Logo images are 60x60 pixels.

Login required.

## /Build the Wbesite!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

## /Test with auth stuff in prod.








## /api/v2/bulk-load"

Partially complete - TODO

## /api/del-qr

Deltas a QR referral.  Will associate this QR back to a default page on `http://q8s.co/deleted.html?event={{.event_id}}&base60={{.id60}}`

Login required.

## /api/v2/sign-data?method=eth|pgp&base10= &base60=

Sign the data associated with a QR so that it can not be changed.

This will set 

```
	t_qr_to.singed = 'pgp' | 'eth' | 'both'
	t_qr_to.signature = signature string in JSON format
	t_qr_to.update_ok = 'no'	
```

Login required.







## /api/v2/monitor-qr?freq=20&action=Notif

Turn on monitoring for the destination of this QR code.  Once every X minutes (minimum 2, default 60) the desitation
url will be verified to exist.  The results of this can be fetch with `/api/v2/get-monitor`.

Login required.


## /api/v2/get-monitor-data

Return the list of monitoring status information for your selected monitored URLs.

Login required.


## TODO

1. Todo - upload user logo.
2. List user logos
3. QR codes in different formats (.svg | JavaScript)
4. Color other than black.
5. Logo in center of QR - with concomitant risks.
6. "read"/"decode" qr code and extract text ( upload file, deocode result )
7. "upload" qr - for read

8. Pages of QR printed - Avery Form - Page Image.

## Potential Markets

1. Track of documents w/ QR
2. Setup to push to S3 or ipfs (both?)


## Notes

https://protonmail.com/blog/openpgp-golang/

