package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"os"

	"github.com/pschlump/godebug"
	"gitlab.com/pschlump/PureImaginationServer/ymux"
)

var StoredProcConfig = []ymux.CrudStoredProcConfig{
	/*
		{
			CrudBaseConfig: ymux.CrudBaseConfig{
				URIPath:       "/api/v1/get_qr_old",
				AuthKey:       false,
				JWTKey:        true,
				TableNameList: []string{"t_avail_qr"},
				ParameterList: []ymux.ParamListItem{
					{ReqVar: "type", ParamName: "p_type"},
				},
				NoDoc: true,
			},
			StoredProcedureName: "s_get_qr_json",
		},
	*/
}

// Table based end points
var TableConfig = []ymux.CrudConfig{
	/*
		create table ct_homework_seen (
			  id						char varying (40) DEFAULT uuid_generate_v4() not null primary key
			, user_id					char varying (40)  not null
			, lesson_id					char varying (40) not null
			, when_seen					timestamp not null
			, watch_count				int default 0 not null
		);
		AuthPrivs: []string{"role:admin"},
	*/
	{
		CrudBaseConfig: ymux.CrudBaseConfig{
			URIPath:   "/api/v1/ct_homework_seen",
			AuthKey:   false,
			JWTKey:    false,
			NoDoc:     true,
			AuthPrivs: []string{"role:user"},
		},
		MethodsAllowed: []string{"GET", "POST", "PUT", "DELETE"},
		TableName:      "ct_homework_seen",
		InsertCols:     []string{"id", "user_id", "lesson_id", "when_seen", "watch_count"},
		InsertPkCol:    "id",
		UpdateCols:     []string{"id", "user_id", "lesson_id", "when_seen", "watch_count"},
		UpdatePkCol:    "id",
		WhereCols:      []string{"id", "user_id", "lesson_id", "when_seen", "watch_count"},
	},

	/*
		CREATE TABLE ct_homework (
			  homework_id				uuid DEFAULT uuid_generate_v4() not null primary key
			, homework_title			text not null
			, homework_no					text not null
			, points_avail				int not null default 10
			, video_url					text not null
			, video_img					text not null
			, lesson_body 				JSONb not null 	-- body, html, text etc.
		 	, updated 					timestamp
		 	, created 					timestamp default current_timestamp not null
		);
	*/
	{
		CrudBaseConfig: ymux.CrudBaseConfig{
			URIPath:   "/api/v1/ct_homework",
			AuthKey:   false,
			JWTKey:    false,
			NoDoc:     true,
			AuthPrivs: []string{"role:user"},
		},
		MethodsAllowed: []string{"GET", "POST", "PUT", "DELETE"},
		TableName:      "ct_homework",
		InsertCols:     []string{"homework_id", "homework_title", "homework_no", "points_avail", "video_url", "video_img", "lesson_body"},
		InsertPkCol:    "homework_id",
		UpdateCols:     []string{"homework_id", "homework_title", "homework_no", "points_avail", "video_url", "video_img", "lesson_body"},
		UpdatePkCol:    "homework_id",
		WhereCols:      []string{"homework_id", "homework_title", "homework_no", "points_avail", "video_url", "video_img", "lesson_body"},
	},
	/*
	   create table ct_val_homework (
	   	val_id m4_uuid_type() not null primary key,
	   	homework_no int not null,
	   	val_type text not null,
	   	val_data text not null
	    	, updated 				timestamp
	    	, created 				timestamp default current_timestamp not null
	   );
	*/
	{
		CrudBaseConfig: ymux.CrudBaseConfig{
			URIPath:   "/api/v1/ct_val_homework",
			AuthKey:   false,
			JWTKey:    false,
			NoDoc:     true,
			AuthPrivs: []string{"role:user"},
		},
		MethodsAllowed: []string{"GET", "POST", "PUT", "DELETE"},
		TableName:      "ct_val_homework",
		InsertCols:     []string{"val_id", "homework_no", "val_type", "val_data"},
		InsertPkCol:    "homework_id",
		UpdateCols:     []string{"val_id", "homework_no", "val_type", "val_data"},
		UpdatePkCol:    "homework_id",
		WhereCols:      []string{"val_id", "homework_no"},
	},

	/*
	   create table ct_file_list (
	   	file_list_id m4_uuid_type() not null primary key,
	   	homework_no int not null,
	   	file_name text not null
	    	, updated 				timestamp
	    	, created 				timestamp default current_timestamp not null
	   );
	*/
	{
		CrudBaseConfig: ymux.CrudBaseConfig{
			URIPath:   "/api/v1/ct_file_list",
			AuthKey:   false,
			JWTKey:    false,
			NoDoc:     true,
			AuthPrivs: []string{"role:user"},
		},
		MethodsAllowed: []string{"GET", "POST", "PUT", "DELETE"},
		TableName:      "ct_file_list",
		InsertCols:     []string{"file_list_id", "homework_no", "file_name"},
		InsertPkCol:    "homework_id",
		UpdateCols:     []string{"file_list_id", "homework_no", "file_name"},
		UpdatePkCol:    "homework_id",
		WhereCols:      []string{"file_list_id", "homework_no"},
	},
}

var QueryConfig = []ymux.CrudQueryConfig{
	/*
		// Example:
			{
				CrudBaseConfig: ymux.CrudBaseConfig{
					URIPath:       "/api/v1/h_list_user_qr_codes",
					AuthKey:       false,
					JWTKey:        true,
					NoDoc:         true,
					TableNameList: []string{"t_qr_to"},
					ParameterList: []ymux.ParamListItem{
						{ReqVar: "user_id", ParamName: "$1"},
					},
					PostProc: []string{"template_display_url"},
				},
				QueryString: `
		select "t1"."id",
			"t1"."id60",
			"t1"."id10",
			"t1"."data",
			"t1"."n_redir",
			"t1"."url_to",
			"t1"."owner_id",
			"t1"."group_tag",
			"t2"."url_path" as "display_url",
			"t2"."ord_seq"
		from "t_qr_to" as "t1", "t_avail_qr" as "t2"
		where "t1"."owner_id" = $1
		  and "t1"."id60" = "t2"."qr_enc_id"
		order by "t2"."ord_seq"
		`,
			},
	*/
	{
		CrudBaseConfig: ymux.CrudBaseConfig{
			URIPath:       "/api/v1/ct_homework_per_user",
			AuthKey:       false,
			JWTKey:        true,
			NoDoc:         true,
			TableNameList: []string{"t_ymux_user", "ct_homework", "ct_homework_seen"},
			ParameterList: []ymux.ParamListItem{
				{ReqVar: "user_id", ParamName: "$1"},
			},
		},
		// t1.homework to be remove from the semi-view (large objet)
		// use t1.homework_id to query the table for that - one row at a time
		// See /v2/ below.
		/*
			CREATE TABLE ct_homework (
				  homework_id				uuid DEFAULT uuid_generate_v4() not null primary key
				, homework_title			text not null
				, homework_no					text not null
				, points_avail				int not null default 10
				, video_url					text not null
				, video_img					text not null
				, homework_body 				JSONb not null 	-- body, html, text etc.
			 	, updated 					timestamp
			 	, created 					timestamp default current_timestamp not null
			);
		*/
		QueryString: `
			select
					  t1.homework_id
					, t1.homework_title
					, t1.homework_no
					, t1.points_avail
					, t1.video_url
					, t1.video_img
					, t1.lesson_body
					, t2.id as homework_seen_id
					, t2.when_seen
					, t2.watch_count
					, case
						when t2.watch_count = 0 then 'n'
						when t2.watch_count is null then 'n'
						else 'y'
					  end as "has_been_seen"
				from ct_homework as t1
					left outer join ct_homework_seen as t2 on ( t1.homework_id = t2.homework_id )
				where exists (
						select 1 as "found"
						from ct_login as t3
						where t3.user_id = $1
					)
				order by t1.homework_no
		`,
	},
	{
		CrudBaseConfig: ymux.CrudBaseConfig{
			URIPath:       "/api/v2/ct_homework_per_user",
			AuthKey:       false,
			JWTKey:        true,
			NoDoc:         true,
			TableNameList: []string{"t_ymux_user", "ct_homework", "ct_homework_seen"},
			ParameterList: []ymux.ParamListItem{
				{ReqVar: "user_id", ParamName: "$1"},
			},
		},
		QueryString: `
			select
					  t1.homework_id
					, t1.homework_title
					, t1.homework_no
					, t1.points_avail
					, t1.video_url
					, t1.video_img
					, t1.lesson_body
					, t2.id as homework_seen_id
					, t2.when_seen
					, t2.watch_count
					, case
						when t2.watch_count = 0 then 'n'
						when t2.watch_count is null then 'n'
						else 'y'
					  end as "has_been_seen"
				from ct_homework as t1
					left outer join ct_homework_seen as t2 on ( t1.homework_id = t2.homework_id )
				where exists (
						select 1 as "found"
						from ct_login as t3
						where t3.user_id = $1
					)
				order by t1.homework_no
		`,
	},
	{
		CrudBaseConfig: ymux.CrudBaseConfig{
			URIPath:       "/api/v1/ct_homework_done",
			AuthKey:       false,
			JWTKey:        true,
			NoDoc:         true,
			TableNameList: []string{"t_ymux_user", "ct_homework", "ct_homework_seen"},
			ParameterList: []ymux.ParamListItem{
				{ReqVar: "user_id", ParamName: "$1"},
				{ReqVar: "homework_seen_id", ParamName: "$2"},
			},
		},
		IsUpdate: true,
		QueryString: `
			update ct_homework_seen
				set when_seen = now(),
					watch_count = watch_count + 1
				where exists (
						select 1 as "found"
						from ct_login as t3
						where t3.user_id = $1
						  and t3.lang_to_use = t1.lang_to_use
					)
				  and id = $2
		`,
	},
}

func init() {
	// type PrePostFunc func(www http.ResponseWriter, req *http.Request, inData string) (outData string, status StatusType, err error)
	// func AddToPrePostTab(name string, fx PrePostFunc) {
	ymux.AddToPrePostTab("template_display_url", TemplateDisplayUrl)
	ymux.AppendConfig(StoredProcConfig, TableConfig, QueryConfig)
}

type TemplateDisplayUrlData struct {
	Status string                   `json:"status"`
	Data   []map[string]interface{} `json:"data"`
}

// OLD: func TemplateDisplayUrl(www http.ResponseWriter, req *http.Request, inData string) (outData string, status ymux.StatusType, err error) {
func TemplateDisplayUrl(www http.ResponseWriter, req *http.Request, pp ymux.PrePostFlag, cfgData, inData string) (outData string, status ymux.StatusType, err error) {
	status = ymux.OkContinueSaveOutData
	outData = inData
	var mdata TemplateDisplayUrlData
	mdata.Data = make([]map[string]interface{}, 0, 10)
	err = json.Unmarshal([]byte(inData), &mdata)
	if err != nil {
		fmt.Fprintf(logFilePtr, "Error with data ->%s<- failed to parse: %s\n", inData, err)
		status = ymux.ErrorFail
		return
	}

	if mdata.Status != "success" {
		return
	}
	if len(mdata.Data) == 0 {
		return
	}

	// BaseServerUrl       string `json:"base_server_url" default:"http://www.q8s.com"` // urlBase := "http://www.q8s.com"		// xyzzy441 - tempalte {{.scheme}}
	to, e0 := url.Parse(gCfg.QRGeneration.BaseServerUrl)
	if DbOn["edit-urls-on-output"] {
		fmt.Printf("e0 %s to=%s\n", e0, godebug.SVarI(to))
	}

	for ii, vv := range mdata.Data {
		dui, ok0 := vv["display_url"]
		if ok0 && dui != nil {
			duis, ok1 := dui.(string)
			if ok1 {
				uu, err := url.Parse(duis)
				if DbOn["edit-urls-on-output"] {
					fmt.Fprintf(os.Stderr, "Fixed at %d Orig (%s) err %s uu= %s\n", ii, duis, err, godebug.SVarI(uu))
				}
				uu.Host = to.Host
				uu.Scheme = to.Scheme
				duis = fmt.Sprintf("%s", uu)
				if DbOn["edit-urls-on-output"] {
					fmt.Fprintf(os.Stderr, "\tReplaed with: %s\n", duis)
				}
				vv["display_url"] = duis
			}
		}
	}
	outData = godebug.SVarI(mdata)

	return
}

/* vim: set noai ts=4 sw=4: */
