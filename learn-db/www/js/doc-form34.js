
// Tracking - ShipStart

function submitForm34 ( event ) {
    event.preventDefault(); // Totally stop stuff happening

	console.log ( "Click of submit button for form34 - login" );

//				{ReqVar: "user_id", ParamName: "p_user_id"},
//				{ReqVar: "qr_id", ParamName: "p_qr_id"},
//				{ReqVar: "qr_enc_id", ParamName: "p_qr_enc_id"},	// generated from qr_id on server side.
//				{ReqVar: "lat", ParamName: "p_lat"},
//				{ReqVar: "lon", ParamName: "p_lon"},
//				{ReqVar: "note", ParamName: "p_note"},

	var data = {
	   	  "user_id"			: g_user_id
		, "note"			: $("#note").val()
		, "auth_key"		: g_auth_key
		, "__method__"		: "POST"
		, "_ran_" 			: ( Math.random() * 10000000 ) % 10000000
	};
	submitItData ( event, data, "/api/v1/h_evShipBeg", function(data){
		console.log ( "data=", data );
		if ( data && data.status && data.status == "success" ) {
			g_item_id = data.item_id; // sample: -- see bottom of file: www/js/pdoc-form02.js
			g_event_id = data.event_id; // sample: -- see bottom of file: www/js/pdoc-form02.js
			renderMessage ( "Successful Event Recorded", "QR Code is now associated with this item/event.<br>");
			render5SecClearMessage();
		} else {
			console.log ( "ERROR: ", data );
			renderError ( "Failed to create item.", data.msg );
		}
	}, function(data) {
		console.log ( "ERROR: ", data );
		renderError ( "Network communication failed.", "Failed to communicate with the server." );
	}
	);
}

function renderForm34 ( event ) {
	var form = [ ''
		,'<div>'
			,'<div class="row">'
				,'<div class="col-sm-6">'
					,'<div class="card bg-default">'
						,'<div class="card-header"><h2>Start Shiping</h2></div>'
						,'<div class="card-body">'
							,'<form id="form01">'
								,'<div class="form-group">'
									,'<label for="username">Additional Note</label>'
									,'<input type="text" class="form-control" id="note" name="note"/>'
								,'</div>'
								,'<button type="button" class="btn btn-primary" id="form34-submit">Start Shiping</button>'
							,'</form>'
						,'</div>'
					,'</div>'
				,'</div>'
			,'</div>'
		,'</div>'
	].join("\n");
	$("#body").html(form);
	// Add events
	$("#form34-submit").click(submitForm34);
	// xyzzy - additional click events forgot-pass, forgot-acct
}
$("#evShipStart").click(renderForm34); 	// Attach to link to paint the partial


