
//<button type="button" class="btn btn-primary bind-click" data-click="submitQRLookup">Lookup Info</button>
function submitQRLookup ( event, resolve ) {
	// Sample Data: {"status":"success", "url":"http://localhost:8080/abc/def", "qr":"http://localhost:8333/q/10024.png", "tmpl":"", "group":"abc", "userdata":"abc"} 
	if ( event && event.preventDefault && typeof event.preventDefault == "function") { event.preventDefault(); }
	console.log ( "call to: submitQRLookup");
	var frm = $("#form01");
	var uri = frm.attr("action");
	var method = frm.attr("method");
	$("#__method__").val(method);
	$("#_ran_").val((Math.random() * 10000000 ) % 10000000);
	data = frm.serialize();
	console.log ( "uri", uri, "method", method, "data", data );
	submitItData ( event, data, uri, function(data){
		console.log( "data=", data );
		g_data[uri] = data;
		if ( data.status === "success" ) {
			renderDisplayLookup()
			$("#qr_img").attr('src',data.qr_url);
			$("#url").html(data.url);
			$("#qr").html(data.qr);			// <<<
			$("#tmpl").html(data.tmpl);
			$("#group").html(data.group);
			$("#userdata").html(data.userdata);
			$("#cnt").html(data.cnt);
		} else {
			renderDisplayError();
			$("#msg").html(data.msg);
		}
	}, function(data) {
		// TODO - error handeling
		console.log( "ERROR: ", data );
		renderError( "Error", data.responseText );																// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< this one <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		if ( resolve ) { resolve(); }
	});
}

function submitQRDel ( event, resolve ) {
	if ( event && event.preventDefault && typeof event.preventDefault == "function") { event.preventDefault(); }
	console.log ( "call to: submitQRDel");
	var frm = $("#form01");
	var uri = frm.attr("action");
	var method = frm.attr("method");
	$("#__method__").val(method);
	$("#_ran_").val((Math.random() * 10000000 ) % 10000000);
	data = frm.serialize();
	console.log ( "uri", uri, "method", method, "data", data );
	submitItData ( event, data, uri, function(data){
		console.log( "data=", data );
		g_data[uri] = data;
		if ( data.status === "success" ) {
			renderDisplayDeleteMsg()
		} else {
			renderDisplayError();
			$("#msg").html(data.msg);
		}
	}, function(data) {
		console.log( "ERROR: ", data );
		renderError( "Failed to delete - not found.", "Failed to delete:"+$("#id").val() );
		if ( resolve ) { resolve(); }
	});
}

function submitQRGen ( event, resolve ) {
	if ( event && event.preventDefault && typeof event.preventDefault == "function") { event.preventDefault(); }
	console.log ( "call to: submitQRDel");
	var frm = $("#form01");
	var uri = frm.attr("action");
	var method = frm.attr("method");
	$("#__method__").val(method);
	$("#_ran_").val((Math.random() * 10000000 ) % 10000000);
	data = frm.serialize();
	console.log ( "uri", uri, "method", method, "data", data );
	submitItData ( event, data, uri, function(data){
		console.log( "data=", data );
		g_data[uri] = data;
		if ( data.status === "success" ) {
			renderDisplayQR()
			$("#qr_img").attr('src',data.qr_url);
			$("#url").html(data.url);
		} else {
			renderDisplayError();
			$("#msg").html(data.msg);
		}
	}, function(data) {
		// TODO - error handeling
		console.log( "ERROR: ", data );
		renderError( "Error", data.responseText );																// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< this one <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		if ( resolve ) { resolve(); }
	});
}

function submitQRSet ( event, resolve ) {
	if ( event && event.preventDefault && typeof event.preventDefault == "function") { event.preventDefault(); }
	console.log ( "call to: submitQRDel");
	var frm = $("#form01");
	var uri = frm.attr("action");
	var method = frm.attr("method");
	$("#__method__").val(method);
	$("#_ran_").val((Math.random() * 10000000 ) % 10000000);
	data = frm.serialize();
	console.log ( "uri", uri, "method", method, "data", data );
	submitItData ( event, data, uri, function(data){
		console.log( "data=", data );
		g_data[uri] = data;
		if ( data.status === "success" ) {
			renderDisplayQRSet()
			$("#qr_img").attr('src',data.qr_url);
			$("#url").html(data.url);
		} else {
			renderDisplayError();
			$("#msg").html(data.msg);
		}
	}, function(data) {
		console.log( "ERROR: ", data );
		renderError( "Error", data.responseText );																// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< this one <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		if ( resolve ) { resolve(); }
	});
}

//function submitQRCount ( event, resolve ) {
//	if ( event && event.preventDefault && typeof event.preventDefault == "function") { event.preventDefault(); }
//	console.log ( "call to: submitQRDel");
//	var frm = $("#form01");
//	var uri = frm.attr("action");
//	var method = frm.attr("method");
//	$("#__method__").val(method);
//	$("#_ran_").val((Math.random() * 10000000 ) % 10000000);
//	data = frm.serialize();
//	console.log ( "uri", uri, "method", method, "data", data );
//	submitItData ( event, data, uri, function(data){
//		console.log( "data=", data );
//		g_data[uri] = data;
//		// fmt.Fprintf(www, `{"status":"success","count":%d,"data":%q,"group":%q,"when":%s}`+"\n", vv.Cnt, vv.UserData, vv.GroupTag, SVar(vv.WhenDone)) -->
//		if ( data.status === "success" ) {
//			renderDisplayCount()
//			$("#count").attr('src',data.count);
//			$("#data").html(data.data);
//			$("#group").html(data.group);
//		} else {
//			renderDisplayError();
//			$("#msg").html(data.msg);
//		}
//	}, function(data) {
//		// TODO - error handeling
//		console.log( "ERROR: ", data );
//		renderError( "Failed to Login - Network communication failed.", "Failed to communicate with the server." );
//		if ( resolve ) { resolve(); }
//	});
//}


function submitQRUpd ( event, resolve ) {
	if ( event && event.preventDefault && typeof event.preventDefault == "function") { event.preventDefault(); }
	console.log ( "call to: submitQRUpd");
	var frm = $("#form01");
	var uri = frm.attr("action");
	var method = frm.attr("method");
	$("#__method__").val(method);
	$("#_ran_").val((Math.random() * 10000000 ) % 10000000);
	data = frm.serialize();
	console.log ( "uri", uri, "method", method, "data", data );
	submitItData ( event, data, uri, function(data){
		console.log( "data=", data );
		g_data[uri] = data;
		if ( data.status === "success" ) {
			if ( data.is_set == "yes"  ) {
				renderDisplayQR0()
				$("#url").html(data.url);
			} else {
				renderDisplayQRSet()
				$("#qr_img").attr('src',data.qr_url);
				$("#url").html(data.url);
			}
		} else {
			renderDisplayError();
			$("#msg").html(data.msg);
		}
	}, function(data) {
		// TODO - error handeling
		console.log( "ERROR: ", data );
		renderError( "Error", data.responseText );																// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< this one <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		if ( resolve ) { resolve(); }
	});
}


function submitListGroups ( event, resolve ) {

	/*
	Sample Data:
		-- cut --
		-- cut --
	*/

	var y_hdrCfg = {
		ColNames: 	[ { Name:"Group Name"}, ],
	};

	var y_rowCfg = {
		cols: [
				{ Name: "Group", rowTmpl: "%{Group%}" },
		]
	};

	if ( event && event.preventDefault && typeof event.preventDefault == "function") { event.preventDefault(); }
	console.log ( "call to: submitListGroups");
	var frm = $("#form01");
	var uri = frm.attr("action");
	var method = frm.attr("method");
	$("#__method__").val(method);
	$("#_ran_").val((Math.random() * 10000000 ) % 10000000);
	data = frm.serialize();
	console.log ( "uri", uri, "method", method, "data", data );
	submitItData ( event, data, uri, function(data){
		console.log( "data=", data );
		g_data[uri] = data;
		data.data = [];
		for ( var ii = 0, mx = data.groups.length; ii < mx; ii++ ) {
			data.data.push ( { "Group": data.groups[ii] } );
		}
		g_data[uri] = data;
		console.log ( "Modified Data:", data );
		if ( data.status == "success" ) {
			renderDisplayListOfGroup()
			renderTableTo ( "#TableListOfGroup", data.data, y_hdrCfg, y_rowCfg );
		} else {
			renderDisplayError();
			$("#msg").html(data.msg);
		}
	}, function(data) {
		// TODO - error handeling
		console.log( "ERROR: ", data );
		renderError( "Error", data.responseText );																// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< this one <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		if ( resolve ) { resolve(); }
	});
}


function submitListQRs ( event, resolve ) {

	/*
	Sample Data:
		-- cut --
		-- cut --
	*/

	var y_hdrCfg = {
		ColNames: 	[ { Name:"QR ID"}, ],
	};

	var y_rowCfg = {
		cols: [
				{ Name: "QR_ID", rowTmpl: "%{QR_ID%}" },
		]
	};

	if ( event && event.preventDefault && typeof event.preventDefault == "function") { event.preventDefault(); }
	console.log ( "call to: submitListQRs");
	var frm = $("#form01");
	var uri = frm.attr("action");
	var method = frm.attr("method");
	$("#__method__").val(method);
	$("#_ran_").val((Math.random() * 10000000 ) % 10000000);
	data = frm.serialize();
	console.log ( "uri", uri, "method", method, "data", data );
	submitItData ( event, data, uri, function(data){
		console.log( "data=", data );
		g_data[uri] = data;
		data.data = [];
		for ( var ii = 0, mx = data.qr_ids.length; ii < mx; ii++ ) {
			data.data.push ( { "QR_ID": data.qr_ids[ii] } );
		}
		g_data[uri] = data;
		console.log ( "Modified Data:", data );
		if ( data.status == "success" ) {
			renderDisplayListOfQRIDs()
			renderTableTo ( "#TableListOfQRIDs", data.data, y_hdrCfg, y_rowCfg );
		} else {
			renderDisplayError();
			$("#msg").html(data.msg);
		}
	}, function(data) {
		console.log( "ERROR: ", data );
		renderError( "Error", data.responseText );																// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< this one <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
		if ( resolve ) { resolve(); }
	});
}


function postRenderStatsOn() {
	$(".hide-me").hide();
	$("#choose-type").change(function() {
		console.log( "Changed" );
		$(this).find(":selected").each(function () {
			var v = $(this).val();
			console.log( v );
			$(".hide-me").hide();
			$("#by-"+v).show();
			if ( v == "xuser" ) {
				$("#all").val("yes");
			} else {
				$("#all").val("");
			}
		});
	})
}

function submitStatsOn ( event, resolve ) {

	/*
	Sample Data:
		-- cut --
			{"status":"success","data":[
				{
					"id": "10024",
					"Count": 3,
					"gtag": "abc",
					"when": [
						1596683593321883259,
						1596683594441760386,
						1596683595985295316
					]
				},
				{
					"id": "10026",
					"Count": 3,
					"gtag": "abc",
					"when": [
						1596683593321883259,
						1596683594441760386,
						1596683595985295316
					]
				}
			]}
		-- cut --
	*/

	var y_hdrCfg = {
		ColNames: 	[ { Name:"QR ID"}, { Name:"Count" }, { Name:"Group Tag" } ],
	};

	var y_rowCfg = {
		cols: [
				{ Name: "id",    rowTmpl: "%{id%}" },
				{ Name: "Count", rowTmpl: "%{Count%}" },
				{ Name: "gtag",  rowTmpl: "%{gtag%}" },
		]
	};

	if ( event && event.preventDefault && typeof event.preventDefault == "function") { event.preventDefault(); }
	console.log ( "call to: submitStatsOn");
	var frm = $("#form01");
	var uri = frm.attr("action");
	var method = frm.attr("method");
	$("#__method__").val(method);
	$("#_ran_").val((Math.random() * 10000000 ) % 10000000);
	data = frm.serialize();
	console.log ( "uri", uri, "method", method, "data", data );
	submitItData ( event, data, uri, function(data){
		console.log( "data=", data );
		g_data[uri] = data;

		if ( data.status == "success" ) {
			renderDisplayStatsTable();
			renderTableTo ( "#TableListOfQRIDs", data.data, y_hdrCfg, y_rowCfg );
		} else {
			renderDisplayError();
			$("#msg").html(data.msg);
		}

	}, function(data) {
		console.log( "ERROR: ", data );
		renderError( "Error", data.responseText );																
		if ( resolve ) { resolve(); }
	});
}































// Render of Tables into .html

/*

# An example of how to use this.  

First an example of a standard table with a column of buttons on the Right.

Thins is a Tuple of data `{ short_desc, note, created, id }`.

So the data returned looks like 

```
{
	"data": [
			{ "short_desc": "some text", "note": "more text", "id": "uuid-uuid", "created": "date" },
			{ "short_desc": "some text", "note": "more text", "id": "uuid-0001", "created": "date" }
	]
}
```

The function to render the table and bind actions is:

```
function postRenderListThings() {
	console.log ( "Post - Things - List of things" );

	// var actionUrlTmpl = "/api/v2/user-edit?id=%{id%}&__method__=POST&_ran_=%{ran%}&act=%{act%}&%{data%}";

	function ActionFunc ( idCol, fullRow, fullTableData, rowNum, colNum, colName ) {
		return qt ( [ '',
			'       <td>\n',
			'         <button type="button" class="btn btn-primary bind-click-row" data-click="submitTakeActionAThing" data-id="%{id%}" data-pos="%{_rowNum_%}">Take Action</button>\n',
			'       </td>\n',
		].join(""), fullRow );
	}

	var y_hdrCfg = {
		ColNames: 	[ { Name:"Description"}, 		{ Name:"Created" }, 		{ Name:"Action" } 	],
	};

	var y_rowCfg = {
		cols: [
				{ Name: "Description", rowTmpl: "%{short_desc%}: %{note%}" },
				{ Name: "Created", rowTmpl: "%{created%}" },
				{ Name: "id", fx: ActionFunc },
			// Name - column nmae
			// fx - fuctnion that if set will have data past to it - more powerful - but code - for maping instead of using templates.
			// defaultValue - a default if no column value is supplied.
			// defaultIfEmpty - a default if "" is the value supplied
			// rowTmpl - a QT tempaltes - this allows for wrapping a column with HTML using a template
			// rowColTmpl - a hash by column name of QT tempaltes - this allows for wrapping a column/row number with stuff.
		]
	};

	$.ajax({
		type: 'GET',
		url: "/api/v2/list-of-things",
		data: { "_ran_": ( Math.random() * 10000000 ) % 10000000 },
		success: function (data) {
			console.log ( "success AJAX", data );
			if ( data.status == "success" ) {
				// Paint TO: <div class="ListOfUploadedFiles" id="TableListOfUploadedFiles"></div>
				renderTableTo ( "#TableListOfThings", data.data, y_hdrCfg, y_rowCfg );
				// xyzzy - may need to bind to ".bind-click" again at this point?
				// xyzzy - may need to curry a function (closure) w/ "id"
				$("#body").on('click','.bind-click-row',function(){
					var fx = $(this).data("click");
					var id = $(this).data("id");
					var pos = $(this).data("pos");
					var _this = this;
					// console.log ( "fx", fx, "id", id, "_rowNum_", pos );
					callFunc( fx, _this, id, data.data, pos );
				}); 
			} else {
				renderError ( "Error", data.msg );
				render5SecClearMessage ( );
			}
		},
		error: function(resp) {
			$("#output").text( "Error!"+JSON.stringify(resp) );
			var msg = resp.statusText;
			renderError ( "Example Error Message - TODO", msg );
			render5SecClearMessage ( );
		}
	});

}
```


## Sample Test Code

```


var x_data = [
	{
		"Name": "Bob",
		"Value": 23,
		"id": "123-id-abc"
	},
	{
		"Name": "Jane",
		"Value": 28,
		"id": "123-id-def"
	},
];

var actionUrlTmpl = "/api/v2/user-edit?id=%{id%}&__method__=POST&_ran_=%{ran%}&act=%{act%}&%{data%}"
function ActionFunc ( idCol, fullRow, fullTableData, rowNum, colNum, colName ) {
	return qt ( [ '',
		'       <td>\n',
		'         <button type="button" class="btn btn-primary bind-click" data-click="submitUpdate" data-id="%{id%}">Update</button>\n',
		'         <button type="button" class="btn btn-primary bind-click" data-click="submitDelete" data-id="%{id%}">Delete</button>\n',
		'       </td>\n',
	].join(""), fullRow );
}

var x_hdrCfg = {
	ColNames: 	[ { Name:"Name"}, 		{ Name:"Value" }, 		{ Name:"Action" } 	],
};

var x_rowCfg = {
	cols: [
			{ Name: "Name" },
			{ Name: "Value", rowTmpl: "$%{Value%}" },
			{ Name: "id", fx: ActionFunc },
// Name - column nmae
// fx - fuctnion that if set will have data past to it - more powerful - but code - for maping instead of using templates.
// defaultValue - a default if no column value is supplied.
// defaultIfEmpty - a default if "" is the value supplied
// rowTmpl - a QT tempaltes - this allows for wrapping a column with HTML using a template
// rowColTmpl - a hash by column name of QT tempaltes - this allows for wrapping a column/row number with stuff.
	]
};

renderTableTo ( "#output", x_data, x_hdrCfg, x_rowCfg );

```
*/
