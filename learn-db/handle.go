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
		create table ct_lesson_seen (
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
			URIPath:   "/api/v1/ct_lesson_seen",
			AuthKey:   false,
			JWTKey:    true,
			NoDoc:     true,
			AuthPrivs: []string{"role:admin"},
		},
		MethodsAllowed: []string{"GET", "POST", "PUT", "DELETE"},
		TableName:      "ct_lesson_seen",
		InsertCols:     []string{"id", "user_id", "lesson_id", "when_seen", "watch_count"},
		InsertPkCol:    "id",
		UpdateCols:     []string{"id", "user_id", "lesson_id", "when_seen", "watch_count"},
		UpdatePkCol:    "id",
		WhereCols:      []string{"id", "user_id", "lesson_id", "when_seen", "watch_count"},
	},

	/*
		CREATE TABLE ct_lesson (
			  lesson_id					m4_uuid_type() DEFAULT uuid_generate_v4() not null primary key
			, video_raw_file			text not null
			, video_title				text not null
			, url						text not null
			, img_url					text not null
			, lesson					jsonb not null	-- all the leson data from ./lesson/{lesson_id}.json, ./raw/{fn}
			, lesson_name				text not null
			, lang_to_use				text default 'Go' not null				-- Go or PostgreSQL
			, updated 					timestamp
			, created 					timestamp default current_timestamp not null
		);
	*/
	{
		CrudBaseConfig: ymux.CrudBaseConfig{
			URIPath:   "/api/v1/ct_lesson",
			AuthKey:   false,
			JWTKey:    false,
			NoDoc:     true,
			AuthPrivs: []string{"role:admin"},
		},
		MethodsAllowed: []string{"GET", "POST", "PUT", "DELETE"},
		TableName:      "ct_lesson",
		InsertCols:     []string{"lesson_id", "video_raw_file", "video_title", "url", "img_url", "lesson", "lesson_name", "lang_to_use"},
		InsertPkCol:    "lesson_id",
		UpdateCols:     []string{"lesson_id", "video_raw_file", "video_title", "url", "img_url", "lesson", "lesson_name", "lang_to_use"},
		UpdatePkCol:    "lesson_id",
		WhereCols:      []string{"lesson_id", "video_raw_file", "video_title", "url", "img_url", "lesson", "lesson_name", "lang_to_use"},
	},

	/*
		create table ct_lesson_validation (
			  id						char varying (40) DEFAULT uuid_generate_v4() not null primary key
		   	, lesson_id				char varying (40) DEFAULT uuid_generate_v4() not null primary key
		   	, seq					bigint DEFAULT nextval('ct_run_seq'::regclass) NOT NULL 	-- ID for passing to client as a number
		   	, qdata					jsonb not null
		   	, pass					char (1) default 'n' not null check ( "pass" in ( 'y','n' ) )
		);
	*/
	{
		CrudBaseConfig: ymux.CrudBaseConfig{
			URIPath:   "/api/v1/ct_lesson_validation",
			AuthKey:   false,
			JWTKey:    true,
			NoDoc:     true,
			AuthPrivs: []string{"role:admin"},
		},
		MethodsAllowed: []string{"GET", "POST", "PUT", "DELETE"},
		TableName:      "ct_lesson_validation",
		InsertCols:     []string{"id", "lesson_id", "seq", "qdata"},
		InsertPkCol:    "id",
		UpdateCols:     []string{"id", "lesson_id", "seq", "qdata"},
		UpdatePkCol:    "id",
		WhereCols:      []string{"id", "lesson_id", "seq", "qdata"},
	},

	/*
	   CREATE TABLE ct_login (
	   	  user_id					m4_uuid_type() not null primary key -- 1 to 1 to t_ymux_user."id"
	   	, pg_acct					char varying (20) not null
	   	, class_no					text not null				-- 4280 or 4010-BC - one of 2 classes
	   	, lang_to_use				text not null				-- Go or PostgreSQL
	   	, misc						JSONb not null				-- Whatever I forgot
	   );
	*/
	{
		CrudBaseConfig: ymux.CrudBaseConfig{
			URIPath:   "/api/v1/ct_login",
			AuthKey:   false,
			JWTKey:    true,
			NoDoc:     true,
			AuthPrivs: []string{"role:admin"},
		},
		MethodsAllowed: []string{"GET", "POST", "PUT", "DELETE"},
		TableName:      "ct_login",
		InsertCols:     []string{"user_id", "pg_acct", "class_no", "lang_to_use", "misc"},
		InsertPkCol:    "user_id",
		UpdateCols:     []string{"user_id", "pg_acct", "class_no", "lang_to_use", "misc"},
		UpdatePkCol:    "user_id",
		WhereCols:      []string{"user_id", "pg_acct", "class_no", "lang_to_use", "misc"},
	},

	/*
		Depricated .... based on a non-login view
			   create or replace view ct_video_per_user as
			   	select
			   			  t1.lesson_id
			   			, t1.id
			   			, t1.video_raw_file
			   			, t1.video_title
			   			, t1.url
			   			, t1.img_url
			   			, t1.lesson
			   			, t1.lesson_name
						, t2.id as video_seen_id
			   			, t2.when_seen
			   			, t2.watch_count
			   			, case
			   				when t2.watch_count = 0 then 'n'
			   				when t2.watch_count is null then 'n'
			   				else 'y'
			   			  end as "has_been_seen"
			   		from ct_lesson as t1
			   			left outer join ct_lesson_seen as t2 on ( t1.lesson_id = t2.lesson_id )
			   ;
		{
			CrudBaseConfig: ymux.CrudBaseConfig{
				URIPath:       "/api/v1/ct_video_per_user",
				AuthKey:       false,
				JWTKey:        true,
				NoDoc:         true,
				AuthPrivs:     []string{"role:admin"},
				TableNameList: []string{"ct_lesson", "ct_lesson_seen"},
			},
			MethodsAllowed: []string{"GET"},
			TableName:      "ct_video_per_user",
			InsertCols:     []string{},
			InsertPkCol:    "lesson_id",
			UpdateCols:     []string{},
			UpdatePkCol:    "lesson_id",
			WhereCols:      []string{"lesson_id", "video_raw_file", "video_title", "url", "img_url", "lesson", "lesson_name", "when_seen", "video_seen_id", "watch_count", "has_been_seen", "lang_to_use"},
		},
	*/
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
			URIPath:       "/api/v1/ct_lesson_per_user",
			AuthKey:       false,
			JWTKey:        true,
			NoDoc:         true,
			TableNameList: []string{"t_ymux_user", "ct_lesson", "ct_lesson_seen"},
			ParameterList: []ymux.ParamListItem{
				{ReqVar: "user_id", ParamName: "$1"},
			},
		},
		// t1.lesson to be remove from the semi-view (large objet)
		// use t1.lesson_id to query the table for that - one row at a time
		// See /v2/ below.
		QueryString: `
			select
					  t1.lesson_id
					, t1.video_raw_file
					, t1.video_title
					, t1.url
					, t1.img_url
					, t1.lesson
					, t1.lesson_name
					, t2.id as lesson_seen_id
					, t2.when_seen
					, t2.watch_count
					, case
						when t2.watch_count = 0 then 'n'
						when t2.watch_count is null then 'n'
						else 'y'
					  end as "has_been_seen"
					, t1.lang_to_use				
				from ct_lesson as t1
					left outer join ct_lesson_seen as t2 on ( t1.lesson_id = t2.lesson_id )
				where exists (
						select 1 as "found"
						from ct_login as t3
						where t3.user_id = $1
						  and t3.lang_to_use = t1.lang_to_use
					)
				order by t1.lesson
		`,
	},
	{
		CrudBaseConfig: ymux.CrudBaseConfig{
			URIPath:       "/api/v2/ct_lesson_per_user",
			AuthKey:       false,
			JWTKey:        true,
			NoDoc:         true,
			TableNameList: []string{"t_ymux_user", "ct_lesson", "ct_lesson_seen"},
			ParameterList: []ymux.ParamListItem{
				{ReqVar: "user_id", ParamName: "$1"},
			},
		},
		QueryString: `
			select
					  t1.lesson_id
					, t1.video_raw_file
					, t1.video_title
					, t1.url
					, t1.img_url
					, t1.lesson_name
					, t2.id as lesson_seen_id
					, t2.when_seen
					, t2.watch_count
					, case
						when t2.watch_count = 0 then 'n'
						when t2.watch_count is null then 'n'
						else 'y'
					  end as "has_been_seen"
					, t1.lang_to_use				
				from ct_lesson as t1
					left outer join ct_lesson_seen as t2 on ( t1.lesson_id = t2.lesson_id )
				where exists (
						select 1 as "found"
						from ct_login as t3
						where t3.user_id = $1
						  and t3.lang_to_use = t1.lang_to_use
					)
				order by t1.lesson
		`,
	},
	{
		CrudBaseConfig: ymux.CrudBaseConfig{
			URIPath:       "/api/v1/ct_lesson_done",
			AuthKey:       false,
			JWTKey:        true,
			NoDoc:         true,
			TableNameList: []string{"t_ymux_user", "ct_lesson", "ct_lesson_seen"},
			ParameterList: []ymux.ParamListItem{
				{ReqVar: "user_id", ParamName: "$1"},
				{ReqVar: "lesson_seen_id", ParamName: "$2"},
			},
		},
		IsUpdate: true,
		QueryString: `
			update ct_lesson_seen
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
