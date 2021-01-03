
function xCallHandler_orig_one_pass ( event ) {
	event.preventDefault();
	var uri = $(event.currentTarget).data("uri");
	var method = $(event.currentTarget).data("method");
		// xyzzy  - substitute in values in URI
	var action = uri;
	console.log ( ".x-call", action, method );
		
	var frm = {
		"_ran_": ( Math.random() * 10000000 ) % 10000000
	};
	if ( auth_method === "jwt" ) {
		frm["$$jwt_token$$"] = jwt_token;		// xyzzy - should be Auth Berer
	} else {
		frm["auth_key"] = auth_key;
	}

	if ( action == "/api/v2/token" ) {
		frm["un"] = "bob";
		frm["pw"] = "builder";
	}

	$.ajax({
		type: method,
		url: action,
		data: frm,
		success: function (data) {
			$("#output").text( JSON.stringify(data, null, 4) );
			console.log ( "Success:", data, typeof data );
			if ( typeof data == "string" ) {
				data = JSON.parse ( data );
			}
			console.log ( "Success:", data, typeof data );
			if ( data && data.status && data.status == "success" ) {
				if ( action == "/api/v2/token" ) {
					if ( data.jwt_token ) {
						jwt_token = data.jwt_token;
						jwt_expire = data.expire;
					}
					if ( data.auth_token ) {
						auth_key = data.auth_token;
					}
				}
			}
		},
		error: function(resp) {
			$("#output").text( "Error!"+JSON.stringify(resp) );
			console.log("got error status="+resp.status+" "+resp.statusText);
			alert("got error status="+resp.status+" "+resp.statusText);
		}
	});
}
