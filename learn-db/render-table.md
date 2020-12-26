
# Render of Tables into .html


## An example of how to use this.  

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
