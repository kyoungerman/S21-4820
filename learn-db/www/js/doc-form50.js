
// List Tracked QRs - table list.

// Display Results Search for "items" and "events"

var search_data = [];

function submitForm50 ( event ) {
    event.preventDefault(); // Totally stop stuff happening
	var data = {
	   	  "user_id"			: g_user_id
		, "auth_key"		: g_auth_key
		, "_ran_" 			: ( Math.random() * 10000000 ) % 10000000
	};
	submitItData ( event, data, "/api/v1/h_list_user_qr_codes", function(data){
		console.log ( "data=", data );
		search_data = data.data;
		renderForm50 ( event );
	}, function(data) {
		console.log ( "ERROR: ", data );
		renderError ( "Query Failed." );
	}
	);
	$("#msg").html("");
}

var update_data;
function updateItem(ii,undefined) {
	console.log ( "Update Item pos =", ii );
	update_data = search_data[ii];
	g_item_id = search_data[ii].item_id; 
		url_path = search_data[ii].display_url;
		url_path_orig = search_data[ii].display_url;
		url_path = url_path + "?_ran_=" + ( Math.random() * 10000001 ) % 10000001;
console.log ( "Line:35/form50 url_path = ", url_path )
	qr_id = search_data[ii].id10;
	qr_data = search_data[ii].data;
	qr_url_to = search_data[ii].url_to;
	Create_or_Update = "Update";
	renderForm30();
}

function deleteItem(ii,undefined) {
	console.log ( "Delete Item pos =", ii );
	update_data = search_data[ii];
	g_item_id = search_data[ii].item_id; 
	if ( search_data[ii].deleted ) {
		search_data[ii].deleted = 0;
		$("#row_"+ii).css("color","#495057"); // .colorBlackIsh {
		$("#del_"+ii).html("Delete");
		var data = {
			  "user_id"			: g_user_id
			, "base60"			: search_data[ii].id60
			, "base10"			: search_data[ii].id10
			, "auth_key"		: g_auth_key
			, "_ran_" 			: ( Math.random() * 10000000 ) % 10000000
		};
		submitItData ( event, data, "/api/v2/un-del", function(data){
			console.log ( "data=", data );
			renderForm50 ( event );
		}, function(data) {
			console.log ( "ERROR: ", data );
			renderError ( "Query Failed." );
		}
		);
	} else {
		search_data[ii].deleted = 1;
		$("#row_"+ii).css("color","#bbb"); // .colorGray {
		$("#del_"+ii).html("Un-Delete");
		var data = {
			  "user_id"			: g_user_id
			, "base60"			: search_data[ii].id60
			, "base10"			: search_data[ii].id10
			, "auth_key"		: g_auth_key
			, "_ran_" 			: ( Math.random() * 10000000 ) % 10000000
		};
		submitItData ( event, data, "/api/v2/del", function(data){
			console.log ( "data=", data );
			renderForm50 ( event );
		}, function(data) {
			console.log ( "ERROR: ", data );
			renderError ( "Query Failed." );
		}
		);
	}
}

function addItem(undefined) {
	// renderForm25(); 	// Attach to link to paint the partial
	setupForm30();
}

function renderForm50 ( event ) {

	renderClearMessage();
	// render5SecClearMessage();

	var thead = [ ''
		,'<tr>'
			,'<th>'
				,'QR ID'
			,'</th>'
			,'<th>'
				,'Redirect To'
			,'</th>'
			,'<th>'
				,'Data'
			,'</th>'
			,'<th>'
				,'QR Image'
			,'</th>'
			,'<th>'
				,'Action'
			,'</th>'
		,'</tr>'
	].join("\n");

	var rows = [];
	for ( var ii = 0, mx = search_data.length; ii < mx; ii++ ) {
		if ( search_data[ii].deleted ) {
			continue
		}
		rows.push ( [ ''
			,'<tr id="row_'+ii+'">'
				,'<td>'
					,search_data[ii].id10 , "<br>" , search_data[ii].id60, "<br>", search_data[ii].display_url
				,'</td>'
				,'<td>'
					,search_data[ii].url_to
				,'</td>'
				,'<td>'
					,search_data[ii].data
				,'</td>'
				,'<td>'
					,'<img src="'+search_data[ii].display_url+'" height="150" width="150">'
				,'</td>'
				,'<td>'
					,'<a href="#" onClick="updateItem(',ii,')" class="btn btn-sm btn-outline-primary" style="width:70px;margin-bottom:2px;">Update</a>'
					,'<a href="#" onClick="deleteItem(',ii,')" class="btn btn-sm btn-outline-primary" style="width:70px;margin-bottom:2px;" id="del_'+ii+'">Delete</a>'
				,'</td>'
			,'</tr>'
		].join("\n") );
	}
	var tbody = rows.join("\n");

	var formData = [ ''
		,'<div>'
			,'<div class="row">'
				,'<div class="col-sm-12">'
					,'<table class="table">'
						,'<thead id="thead">'
							,thead
						,'</thead>'
						,'<tbody id="tbody">'
							,tbody
						,'</tbody>'
						,'<tfoot id="tfoot">'
							,'<tr>'
								,'<th colspan="5">'
									,'<a href="#" onClick="addItem()" class="btn btn-sm btn-outline-primary">Add New QR Code</a>'
								,'</th>'
							,'</tr>'
						,'</tfoot>'
					,'</table>'
				,'</div>'
			,'</div>'
		,'</div>'
	];

	var form = formData.join("\n");
	$("#body").html(form);
	// $("#form50-submit").click(submitForm50);
}

$("#form50-render").click(submitForm50);
