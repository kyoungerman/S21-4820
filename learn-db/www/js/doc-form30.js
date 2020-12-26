
// get-qr

var url_path = "http://127.0.0.1:7001/qr/qr_00041/q04100.4.png";
var url_path_orig = "http://127.0.0.1:7001/qr/qr_00041/q04100.4.png";
var qr_id = "4200";
var qr_data = "";
var qr_url_to = "";
var Create_or_Update = "Create";

function runTestQR ( event ) {
	if ( event ) {
		event.preventDefault(); 
	}

	console.log ( "Run Test" );

	var data = {
		  "base10"			: $("#qr_id").val()
		, "auth_key"		: g_auth_key
		, "__method__"		: "POST"
		, "_ran_" 			: ( Math.random() * 10000000 ) % 10000000
	};
	submitItData ( event, data, "/api/v2/dec", function(data){		// h_evCreate before
		console.log ( "data=", data );
		renderMessage ( "Successful QR Test", JSON.stringify(data));
		render5SecClearMessage();
		$("#tst-output").html(
			'<iframe src="'+data.to+'" width="80%" height="1400"></iframe>'
		);
	}, function(data) {
		console.log ( "ERROR: ", data );
		renderError ( "Error.", data.msg );
	}
	);
}

function submitForm30 ( event ) {
	if ( event ) {
		event.preventDefault(); // Totally stop stuff happening
	}

	console.log ( "Click of submit button for form30 - login" );

	var data = {
	   	  "user_id"			: g_user_id
		, "base10"			: $("#qr_id").val()
		, "url_to"			: $("#url_to").val()
		, "data"			: $("#note").val()
		, "auth_key"		: g_auth_key
		, "__method__"		: "POST"
		, "_ran_" 			: ( Math.random() * 10000000 ) % 10000000
	};
	submitItData ( event, data, "/api/v2/set", function(data){		// h_evCreate before
		console.log ( "data=", data );
		url_path = url_path_orig + "?_ran_=" + ( Math.random() * 10000001 ) % 10000001;
		$("#display-img").attr("src",url_path);
		// ------------------------------------------------------------------------------------------------------
		if ( 0 ) { // comment out test for now
		$("#test-qr").html(
			'<button type=\"button\" class=\"btn btn-primary\" id=\"do-test-qr\">Test This QR Code</button>'
		);
		$("#do-test-qr").click(runTestQR);
		}
		// ------------------------------------------------------------------------------------------------------
		renderMessage ( "Successful QR Code Created", "QR Code is now associated with this URL.<br>");
		render5SecClearMessage();
	}, function(data) {
		console.log ( "ERROR: ", data );
		renderError ( "Error.", data.msg );
	}
	);
}


function setupForm30 ( event ) {
	if ( event ) {
		event.preventDefault(); // Totally stop stuff happening
	}

	var data = {
	   	  "user_id"			: g_user_id
		, "url_to"			: $("#url_to").val()
		, "note"			: $("#note").val()
		, "nqr"			    : "1"
		, "auth_key"		: g_auth_key
		, "__method__"		: "POST"
		, "_ran_" 			: ( Math.random() * 10000000 ) % 10000000
	};
	submitItData ( event, data, "/api/v2/get-qr", function(data){		// h_evCreate before
		Create_or_Update = "Create";
		console.log ( "data=", data );
		url_path = data.url_path; 
		url_path_orig = data.url_path; 
		url_path = url_path + "?_ran_=" + ( Math.random() * 10000001 ) % 10000001;
		$("#display-img").attr("src",url_path);
		qr_id = data.qr_id; 
		renderForm30(event);
	}, function(data) {
		console.log ( "ERROR: ", data );
		renderError ( "Error.", data.msg );
	}
	);

}

function renderForm30 ( event ) {
	var form = [ ''
		,'<div>'
			,'<div class="row">'
				,'<div class="col-sm-6">'
					,'<div class="card bg-default">'
						,'<div class="card-header"><h2>'+Create_or_Update+' Associated QR Code</h2></div>'
						,'<div class="card-body">'
							,'<form id="form01">'
								,'<div class="form-group">'
									,'<label for="qr_id">ID on QR Code</label>'
									,'<input type="text" class="form-control" id="qr_id" name="qr_id" value="'+qr_id+'"/>'
								,'</div>'
								,'<div class="form-group">'
									,'<label for="username">URL to assign to QR Code</label>'
									,'<input type="text" class="form-control" id="url_to" name="url_to" value="'+qr_url_to+'"/>'
								,'</div>'
								,'<div class="form-group">'
									,'<label for="username">User Memo</label>'
									,'<input type="text" class="form-control" id="note" name="note" value="'+qr_data+'"/>'
								,'</div>'
								,'<button type="button" class="btn btn-primary" id="form30-submit">Activate QR For Tracking</button>'
								,'<span id="test-qr"></span>'
							,'</form>'
						,'</div>'
					,'</div>'
				,'</div>'
				,'<div class="col-sm-6">'
					,'<img id="display-img" src="'+url_path+'">'
				,'</div>'
			,'</div>'
			,'<div class="row">'
				,'<div class="col-sm-12" id="tst-output">'
				,'</div>'
			,'</div>'
		,'</div>'
	].join("\n");
	$("#body").html(form);
	$("#form30-submit").click(submitForm30);
}
$("#evCreate").click(setupForm30); 	// Attach to link to paint the partial

