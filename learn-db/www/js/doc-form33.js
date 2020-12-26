
// demo - SampleUpload

function submitSampleUpload ( event ) {
	if ( event ) { event.preventDefault(); }
	console.log ( "call to: submitSampleUpload");
	var data = {
		  "note"			: $("#note").val()
		, "__method__"		: "POST"
		, "_ran_" 			: ( Math.random() * 10000000 ) % 10000000
	};
	var url = "/api/v1/create-document";
	submitItData ( event, data, url, function(data){	
		console.log ( "data=", data );
		if ( data && data.status && data.status == "success" ) {
			g_item_id = data.item_id; 
			g_event_id = data.event_id; 
			renderMessage ( "Successful Upload", "Yep Yep.<br>");
			render5SecClearMessage();
			UploadTheFile('quality-test');	// xyzzy
		} else {
			console.log ( "ERROR: ", data );
			renderError ( "Failed to create file.", data.msg );
		}
	}, function(data) {
		console.log ( "ERROR: ", data );
		renderError ( "Network communication failed.", "Failed to communicate with the server." );
	}
	);
}

//function preRenderSampleUpload() {
//	console.log ( "call to: preRenderSampleUpload");
//}

function postRenderSampleUpload() {
	console.log ( "call to: postRenderSampleUpload");
	$('#file-id').on('change',function(){
		var fileName = $(this).val(); //get the file name
		console.log ( "(2) fileName=", fileName);
		if ( fileName.startsWith('C:\\fakepath\\') ) {
			fileName = fileName.substring(12);
			console.log ( "(3) fileName=", fileName);
		}
		//$(this).next('.custom-file-label').html(fileName); //replace the "Choose a file" label
		$('#file-label').html(fileName); //replace the "Choose a file" label
	});
}

