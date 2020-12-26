# Registration of a new User

## Request

```
wget -o xtest1.o -O xtest1.oo \
	'http://localhost:7001/api/v2/register?username=pschlump%40gmail.com&password=abcdefghi123&real_name=philip%20Jon%20schlump&again=abcdefghi123&__method__=POST&_ran_=538.396'
```


## Output

```
{
	"Auth2faEnabled": "yes",
	"AuthEmailConfirm": "no",
	"AuthLoginOnRegister": "no",
	"auth_key": "A93eZNGPm72CPp9JyL8uG2hkSbyNTEXs",
	"status": "success",
	"user_id": "7ca66384-e35b-4c96-67f2-88ed0a0e9acd"
}

```


if "Auth2faEnabled" == "yes" then a QR should be displayed with message
to setup an Authenticator.

1. Ask for this info in a 2nd call
2. Have the URL returned at the samd time - as part of the registration process.



func HandleQRCodeRawGenerate(www http.ResponseWriter, req *http.Request) { -- actually will generare/return image.
