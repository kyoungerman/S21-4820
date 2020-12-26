
// User Config

function submitForm31 ( event ) {
    event.preventDefault(); // Totally stop stuff happening

	console.log ( "Click of submit button for form31 - user config" );

	var data = {
	   	  "user_id"			: g_user_id
		, "default_title"	: $("#default_title").val()
		, "auth_key"		: g_auth_key
		, "__method__"		: "POST"
		, "_ran_" 			: ( Math.random() * 10000000 ) % 10000000
	};
	submitItData ( event, data, "/api/v2/set-user-config", function(data){
		console.log ( "data=", data );
		// g_item_id = data.item_id; // sample: -- see bottom of file: www/js/pdoc-form02.js
		// g_event_id = data.event_id; // sample: -- see bottom of file: www/js/pdoc-form02.js
		renderMessage ( "Successful Update", "Your default configuraiton has been updated.<br>");
		render5SecClearMessage();
	}, function(data) {
		console.log ( "ERROR: ", data );
		renderError ( "Network communication failed.", "Failed to communicate with the server." );
	}
	);
}

function renderForm31 ( event ) {
	var form = [ ''
		,'<div>'
			,'<div class="row">'
				,'<div class="col-sm-6">'
					,'<div class="card bg-default">'
						,'<div class="card-header"><h2>User Configuration</h2></div>'
						,'<div class="card-body">'
							,'<form id="form01">'
								,'<div class="form-group">'
									,'<label for="username">Tag Line on QR Code</label>'
									,'<input type="text" class="form-control" id="default_title" name="default_title"/>'
								,'</div>'
								,'<div class="form-group">'
									,'<div class="custom-file">'
										,'<label id="file-label" for="file-id" class="custom-file-label">Upload 60 x 60 Logo .png File</label>'
										,'<input type="file" class="custom-file-input" id="file-id" name="file">'				
									,'</div>'
								,'</div>'
								,'<button type="button" class="btn btn-primary" id="form31-submit">Update User Configuration</button>'
							,'</form>'
						,'</div>'
					,'</div>'
				,'</div>'
			,'</div>'
		,'</div>'
	].join("\n");
	$("#body").html(form);
	$("#form31-submit").click(submitForm31);
	$('#file-id').on('change',function(){
		var fileName = $(this).val(); //get the file name
		// console.log ( "(2) fileName=", fileName);
		if ( fileName.startsWith('C:\\fakepath\\') ) {
			fileName = fileName.substring(12);
			// console.log ( "(3) fileName=", fileName);
		}
		//$(this).next('.custom-file-label').html(fileName); //replace the "Choose a file" label
		$('#file-label').html(fileName); //replace the "Choose a file" label
	});
}
$("#evConfigUser").click(renderForm31); 	// Attach to link to paint the partial


