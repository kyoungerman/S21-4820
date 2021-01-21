## /api/v1/status
### Methods: Any

### Description

Report the status of the service.

The status includes the process id for the currently running process. If you are
killing and restarting a process this is a very useful. When you kill it lists
the current process. Then you can click status to verify that the new process is
running.

This is also useful to verify that the service is up and running.

### See /status

### Example Output

```
{
	"pid": 57351,
	"status": "success",
	"version": "be972fefdd5500aeaaf6848b03b0344f66f132ee-Sun-May-12-16:01:27-MDT-2019"
}
```

If `LastGen` is empty then this run of q8s-server has never created any new QR codes.


## /status
### Methods: GET POST

### Description

Report the status of the service.

The status includes the process id for the currently running process. If you are
killing and restarting a process this is a very useful. When you kill it lists
the current process. Then you can click status to verify that the new process is
running.

This is also useful to verify that the service is up and running.

### See /api/v1/status

### Example Output

```
{
	"pid": 57351,
	"status": "success",
	"version": "be972fefdd5500aeaaf6848b03b0344f66f132ee-Sun-May-12-16:01:27-MDT-2019"
}
```

If `LastGen` is empty then this run of q8s-service has never created any new QR codes.




## /api/v1/config
### Methods: GET

Return the current config for this micro service.

A valid JWT token is required to make this call.





## /api/v1/kick
### Methods: GET POST

Kick the service into checking that a sufficient number of QR codes are available.
The default is to keep 100 pre-generated and it checks once a minute.  If you are
using more than this then a periodic kick may be necessary.

A valid JWT token is required to make this call.





## /api/v1/exit-server
### Methods: GET POST

Exit the currently running server.   The server is normally run in a recovery
loop so a new one will start.  The server is designed to  be gracefully 
exited so as to not leave any open sockets or other resources.   This is the
normal method for an upgrade.   Copy the new executable up to the system then
call this.  The Process ID will be printed out.  Then click on status to verify
that a new process has been stared.

A valid JWT token is required to make this call.


## /api/v1/conv-60-to-10
### Methods: GET POST

Convert from a base 60 id (used in URL shortening) to a base 10 id.

## /api/v1/conv-10-to-60
### Methods: GET POST

Convert from a base 10 id to a base 60 id.


## /api/v1/gen-qr-url
### Methods: GET POST

Use the current configuration to go from a ID base10 or base36 to a URL
for the QR Image.



## /api/v1/parse-qr-url
### Methods: GET POST

Given the URL of a QR Image - decode it into its components.


## /api/v2/get-qr
### Methods: GET 

Return a newly allocated QR code from the available supply.  Sets the redirection 
for this to url_to if supplied - or an empty page if not supplied.

## /api/v2/user-get-qr
### Methods: GET 

Return a newly allocated QR code from the available supply.  Sets the redirection 
for this to url_to if supplied - or an empty page if not supplied.

## /api/v2/dec
### Methods: GET POST

Decode a QR code ID (base60 or base10) and return the associated destination
and data.

### Input

| Item       |  Desc
|------------|-------------------------------------------------------------------
| base60     | Base 60 QR ID - input either base60 or base10.
| base10     | Base 10 QR ID - input either base60 or base10.

## /api/v2/set
### Methods: GET POST

Set the destination URL for a particular QR ID
and data.

### Input

| Item       |  Desc
|------------|-------------------------------------------------------------------
| base60     | Base 60 QR ID - input either base60 or base10.
| base10     | Base 10 QR ID - input either base60 or base10.
| url_to     | Destination to redirect this to.




## /api/v2/set-data
### Methods: GET POST

Set the data for a particular QR ID

### Input

| Item       |  Desc
|------------|-------------------------------------------------------------------
| base60     | Base 60 QR ID - input either base60 or base10.
| base10     | Base 10 QR ID - input either base60 or base10.
| data	     | data from 1 byte to 1024 bytes for this.


## /api/v2/token
### Methods: GET POST

### Example Output

```
{
	"expire": "never",
	"jwt_token": "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRoL...more.data...",
	"status": "success"
}
```






## /api/v2/assign-qr
### Methods: GET POST

Get a set of QR codes and associated them with a user.  

Login required.

### Input

| Item       |  Desc
|------------|-------------------------------------------------------------------
| nqr	     | Integer number of QR codes to assign.
| user_id	 | User that is logged in.

### Example Output

```
	{
		"status":"success",
		"nqr":1,
		"data":[
			{ "qr10":10, "qr60":"AAAAh", "raw":"http://www.q8s.co/qr/qr_00000/q00000h.png",
					"logo":"http://www.q8s.co/qr/qr_00000/q00000h.4.png",
					"user":"http://www.q8s.co/qr/qr_00000/q00000h.2.png",
					"tag":"http://www.q8s.co/qr/qr_00000/q00000h.1.png"
			}
		]
	} 
```




## /api/v2/logout
### Methods: GET POST

Perform server side portion of logout.  This request always returns success.
If you are not logged in or your login has expired it will still return
success.

If you are logged in then the jwt_token is invalidated.

### Input

| Item       |  Desc
|------------|-------------------------------------------------------------------
| jwt_token | Can come from a JWT token.





## /api/v2/status_login
### Methods: Any

### Description

Report the status of the service.  This is the same as /status but requires
login.

The status includes the process id for the currently running process. If you are
killing and restarting a process this is a very useful. When you kill it lists
the current process. Then you can click status to verify that the new process is
running.

This is also useful to verify that the service is up and running.

### See /status





## /api/v2/login
### Methods: GET POST

### Description

Validate a username/password in a relm and return a JWT token if successful.

### Input

| Item       |  Desc
|------------|-------------------------------------------------------------------
| username   | User's email for login
| password   | Password 

### Output Sample

```
{
	"jwt_token": "eyJhbGciOiJFUzI1...",
	"status": "success"
}
```






## /api/v2/register
### Methods: GET POST

### Description

Register for an account.  This will send an email to the specified address to
confirm the registration.   The account will require a confirmed email before
the next login.

### Input

| Item       |  Desc
|------------|-------------------------------------------------------------------
| email	     | User's email for will be used as the username.
| username	 | User's email.
| password   | Password 
| again      | Password repeated - must match password
| real_name  | Name of the person registering

### Output Sample

Status of 200 and

```
{
	"jwt_token": "eyJhbGciOiJFUzI1...",
	"status": "success"
}
```





## /api/v2/confirm-email
### Methods: GET POST

### Description

Confirm that the email that is specified for an account is real.

At the end of confirmation this will perform a 307 redirect to the application 
and the user will be logged in.

### Input

| Item       |  Desc
|------------|-------------------------------------------------------------------
| token	     | The one-time token generated at registration that is used to lookup the user.

### Output Sample

Status of 200 and

```
{
	"jwt_token": "eyJhbGciOiJFUzI1...",
	"status": "success"
}
```




## /api/v2/change-password
### Methods: GET POST

### Description

This is to change the users password when they are logged in.   They have to know 
the current password.

Note that on success this generates a new JWT authentication token that must replace the
existing token.

### Input

| Item       |  Desc
|------------|-------------------------------------------------------------------
| old_pw	 | The current password - it will be verified before the change is implemented.
| password   | Password 
| confirm    | Password repeated - must match password


### Output Sample

Status of 200 and

```
{
	"jwt_token": "eyJhbGciOiJFUzI1...",
	"status": "success"
}
```







## /api/v2/recover-password-pt1
### Methods: GET POST

### Description

First of 3 parts of password recovery.

This part requests that an email be sent to re-set the password on the account.
The user has a recovery token set in "t_ymux_user" also.

## /api/v2/recover-password-pt2
### Methods: GET POST

### Description

Second of 3 parts of password recovery.

This uses a template to convert from a token to a URL for a password update page.
The token is verified to be real.

## /api/v2/recover-password-pt3
### Methods: GET POST

### Description

Third of 3 parts of password recovery.

Take the token and the new password and set these.  Clear the recovery token 
from the user.  The user now has a reset password.  A new JWT token is returned
to the user.   A new jwt_token is created.  The user is logged in.

## /api/contract/ItemToken/BuyItem
### Methods: GET POST

### Description

First part of setup of ERC-721 contract that creates a sellable item with an
ID in the 721 contract.

## /api/contract/ItemToken/BreedItems
### Methods: GET POST

### Description

TBD

## /api/contract/ItemToken/OwnenedItems
### Methods: GET POST

### Description

List the set of items that have ERC-721 contrqct IDs.

## /api/contract/ItemToken/BalanceOf
### Methods: GET POST

### Description

Get the number of items that have been listed in the ERC-721 contract.


## /api/contract/ItemToken/SetPriceOfItem
### Methods: GET POST

### Description

Set the price of the item so that it can be sold in ETH.

## /api/contract/ItemToken/BuySpecificItem
### Methods: GET POST

### Description

Request the purcase of a item in ETH.

## /api/contract/ItemToken/PriceAndCommision
### Methods: GET POST

### Description

Get the price of a item and the amount that is being payed in commission to the contract.

## /api/contract/ItemToken/Commision
### Methods: GET POST

### Description

Get the rate of the commision on a sale.

## /api/contract/ItemToken/Init
### Methods: GET POST

### Description

Initialize the contract for use with a proxy contract.  Only callable by the contract owner.

## /api/contract/ItemToken/Approve
### Methods: GET POST

### Description

Approve of sales that are requested by BuySpecificItem.  This will result in trasfer of
ownership to the new owner.

## /api/key/PrivateKey
### Methods: GET POST

### Description

Create a private key pair that is encrypted in the key store.

## /api/key/KeyFile
### Methods: GET POST

### Description

Upload an encrypted key pair file to the key store.

## /api/key/DeleteKey
### Methods: GET POST

### Description

Delete a private key or a key file.

## /api/key/ValidateKey
### Methods: GET POST

### Description

Validate that you have a correct keyfile with the correct encryption information to use it.
Note that this is an intentionally slow request.





## /api/v2/2fa-validate-pin
### Methods: GET POST

### Description

Validate a 2fa pin for a login to an account.

This is the second part of the login process.




## /api/v2/2fa-setup
### Methods: GET POST

### Description

Return the 2FA information to the client for a non-device 2fa validation.  This will include
the set of one-time keys that the user can print out and use.


## /api/v2/2fa-dev-setup
### Methods: GET POST

### Description

Return the set of device specific one time keys and other information for the setup of a
device for 2fa authentication.


## /api/v2/2fa-get-more-dev-otk
### Methods: GET POST

### Description

TBD - not implemented yet - but required.



## /api/v2/complete-2fa-setup
### Methods: GET POST

### Description

Tell the system on registration that the device is now setup and that an immediate login
can proceeded.  Usually `/api/v2/is-2fa-setup` is being polled waiting for the device to
be setup.


## /api/v2/is-2fa-setup
### Methods: GET POST

### Description

Polling interface to see if the 2fa auth has been completed.








## /api/v2/is-email-used

Input `email`

Output:
```
	{"status":"success","used":"y"}
```

Used will be `y` or `n`.

## /api/v2/is-username-used

Input `username`

Output:
```
	{"status":"success","used":"y"}
```

Used will be `y` or `n`.

## /api/v2/is-password-valid

Input `password`

Output when the password is at least 10 characters long and is not pwned.

```
	{"status":"success","password_ok":"y"}
```

If the password is too short:

```
	{"status":"error","password_ok":"n","msg":"Password is too short.  Use atlest 10 characters.\n"}
```

If a lookup indicates that the password has been pwned:

```
	{"status":"error","password_ok":"n","msg":"Password is a known to be leaked (pwned) password - you will need to use a different password.\n"}
```






## /api/v2/create-dev-un-pw

TODO

## /api/v2/delete-dev-un-pw

TODO

## /api/v2/list-sub-acct

TODO






## /api/v2/create-token-user

### Methods: GET POST

### Description

Creates a user that authenticates with a single strong token.   This is for direct API usage.
Token users do not use 2FA, can not login via the web, can not recover passwords etc...

Roles and privileges are granted and controlled by the creating account.

TODO






## /api/v2/getState

TODO

## /api/v2/getAllState

TODO

## /api/v2/resetToDefaultState

TODO

## /api/v2/delState

TODO

## /api/v2/setState

TODO

## /api/v2/pstateStatus

TODO


## /api/status

TODO

## /api/v1/create-document

TODO

## /api/v1/statusxyzzy1

TODO

## /api/v2/list-registration-tokens

TODO

## /api/v2/re-validate-login

TODO

## /api/v2/admin-set-password

TODO

## /api/v2/create-registration-token

TODO





## The End...

