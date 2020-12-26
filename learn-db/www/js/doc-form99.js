
// Password Reset - Recover  Form

function toMainPage () {
	setTimeout(function() {
		window.location.replace( "/index.html" );
	},5000);
}

function submitForm99 ( event ) {
    event.preventDefault(); // Totally stop stuff happening

	console.log ( "Click of submit button for form99 - login" );
	// wget -o out/at018b.o -O out/at018b.oo "http://127.0.0.1:7001/api/v2/recover-password-pt3?token=`cat out/at018.token`&password=ben-and-jerries44&confirm=ben-and-jerries44"

	var data = {
		  "password"		: $("#password").val()
		, "confirm"			: $("#confirm").val()
		, "token"			: g_token
		, "__method__"		: "POST"
		, "_ran_" 			: ( Math.random() * 10000000 ) % 10000000
	};
	submitItData ( event, data, "/api/v2/recover-password-pt3", function(data){
		console.log ( "data=", data );
		user_id = data.user_id; // sample: -- see bottom of file: www/js/pdoc-form02.js
		g_user_id = data.user_id; // sample: -- see bottom of file: www/js/pdoc-form02.js
//		auth_token = data.auth_token; // JWT Token
//		jwt_token = data.auth_token; // JWT Token
//console.log ( "jwt_token =", jwt_token );
//SetupJWTBerrer();
if ( window.localStorage ) {
	localStorage.setItem("jwt_token",data.auth_token);
}
		g_auth_key = data.auth_key;
		LoggInDone ( auth_token );
		$(".show-anon").hide();
		$(".show-logged-in").show();
		renderMessage ( "New Password Set - Success", "You are now logged in<br>You will be redirect to the applicaiton in 5 seconds.<br>");
		render5SecClearMessage ( ) ;
		toMainPage ();
	}, function(data) {
		console.log ( "ERROR: ", data );
		renderError ( "Failed - Network communication failed.", "Failed to communicate with the server." );
	}
	);
}


function renderForm99 ( event ) {
	var form = [ ''
		,'<div>'
			,'<div class="row">'
				,'<div class="col-sm-6">'
					,'<div class="card bg-default">'
						,'<div class="card-header"><h2>Create New Password</h2></div>'
						,'<div class="card-body">'
							,'<form id="form01">'
								,'<div class="form-group">'
									,'<label for="password">Password</label>'
									,'<input type="password" class="form-control" id="password" name="password"/>'
								,'</div>'
								,'<div class="form-group">'
									,'<label for="password">Password Conformation</label>'
									,'<input type="password" class="form-control" id="confirm" name="confirm"/>'
								,'</div>'
								,'<button type="button" class="btn btn-primary" id="form99-submit">Reset Password</button>'
							,'</form>'
						,'</div>'
					,'</div>'
				,'</div>'
			,'</div>'
		,'</div>'
	].join("\n");
	$("#body").html(form);
	$("#form99-submit").click(submitForm99);
}
$("#form99-render").click(renderForm99); 	// Attach to link to paint the partial

