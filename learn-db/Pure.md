# user_id and auth_token

`user_id` is created as a value whenever you are logged in.  It can not be passed.

To see the user_id you must be running a ./handle.go item that has login required.  You can not pass
the user_id - it is deleted from all incoming requests.
This makes:

```
			JWTKey:        true,
```

A required item.  When validation occurs  the JWT token is decoded and a auth_token is extracted.
The auth_token is looked up in t_ymux_auth_token.  If it is found then the user_id is associated
and the user is considered logged in.   The user_id is added to the request so that GetVar("user_id")
works.  The auth_token is also added to the request.


# TODO

1. ./cfg.json allow setting of user_id with a default of user_id - but settable with

```
	, "user_id_name": "__user_id__"
	, "auth_token_name": "__auth_token__"
```

2. 
