#!/use/bin//python3
#!/home/pschlump/anaconda3/bin/python

from bottle import get, route, static_file, run, error, response, request, abort, put, delete, post
import psycopg2
import datetime
import os
from config import config
from urllib.parse import parse_qs
import json
import uuid
        
# Xyzzy510 - error with "error" with quote marks in it. 

cwd = ""
# Xyzzy - pull from config file the "base_root"  add current run directory if not '/' path
# root_dir = '/home/pschlump/go/src/github.com/Univ-Wyo-Education/S21-4280/py-bottle/www'
root_dir = './www'


#################################################################################################################################
# General Suppot Functions
#################################################################################################################################
def gen_uuid():
    u = "{}".format(uuid.uuid4())
    return u

def required_param( param, req ):
    # print ( "param={} req={}".format ( param, req ) )
    for item in req:
        # print ( "item={}".format(item) )
        if not ( item in param ) :
            # print ( "Error occuring, missing {} parameter".format(item))
            abort(406, "Missing {} from parameters".format(item))
            return False
    return True

#################################################################################################################################
# Database Interface
#################################################################################################################################

db_conn = None
db_connection_info = None
db_version_str = ""

def connect():
    """ Connect to the PostgreSQL database server """
    global db_conn
    global db_connection_info
    db_conn = None
    param = None
    try:
        db_connection_info = config() # read database connection parameters
        # print ( "db_connetion_info = {}".format(db_connection_info ) )

        # connect to the PostgreSQL server
        print('Connecting to the PostgreSQL database...')
        db_conn = psycopg2.connect(**db_connection_info)
		
        cur = db_conn.cursor()              
        cur.execute('SELECT 123 as "x"')
        t = cur.fetchone()
        # print ( "t={}".format(t) )
        cur.close()
       
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)

def disconnect():
    global db_conn
    if db_conn is not None:
        db_conn.close() # close the communication with the PostgreSQL
        db_conn = None

def default(o):
    if isinstance(o, (datetime.date, datetime.datetime)):
        return o.isoformat()

def create_dict(obj, fields):
    mappings = dict(zip(fields, obj))
    return mappings

def run_select ( stmt, data ):
    global db_conn
    cur = None
    try:
        cur = db_conn.cursor()                      # create a cursor
        cur.execute(stmt, data)
        colnames = [desc[0] for desc in cur.description]
        #d# print ( "colnames={}".format ( colnames ) )
        rows = cur.fetchall()
        n_rows = cur.rowcount
        result = []
        for row in rows:
            result.append(create_dict(row, colnames)) 
        cur.close()

        ss = json.dumps(
          result,
          sort_keys=True,
          indent=1,
          default=default
        )

        return "{"+"\"status\":\"success\",\"n_rows\":{},\"data\":{}".format(n_rows,ss)+"}"

    except (Exception, psycopg2.DatabaseError) as error:
        print ( "Database Error {}".format(error) )
        return "{"+"\"status\":\"error\",\"msg\":\"{}\"".format(error)+"}"
        # Xyzzy510 - error with "error" with quote marks in it. 
    finally:
        if cur is not None:
            cur.close()
    
def run_select_raw ( stmt, data ):
    global db_conn
    cur = None
    try:
        cur = db_conn.cursor()                      # create a cursor
        cur.execute(stmt, data)
        colnames = [desc[0] for desc in cur.description]
        #d# print ( "colnames={}".format ( colnames ) )
        rows = cur.fetchall()
        n_rows = cur.rowcount
        result = []
        for row in rows:
            result.append(create_dict(row, colnames)) 
        cur.close()

        ss = json.dumps(
          result,
          sort_keys=True,
          indent=1,
          default=default
        )

        datarv = {
            "status": "success",
            "result": result,
            "n_rows": n_rows,
            "column_names": colnames,
            "rows": rows,
            "json_str": ss
        }

        # print ( "return data is {}".format(datarv) )

        db_conn.commit()
        return datarv

    except (Exception, psycopg2.DatabaseError) as error:
        print ( "Database Error {}".format(error) )
        datarv = {
            "status": "error",
            "msg": "{}".format(error)
        }
        db_conn.commit()
        return datarv
        # Xyzzy510 - error with "error" with quote marks in it. 
    finally:
        if cur is not None:
            cur.close()
   
 
def run_insert ( stmt, data ) :
    global db_conn
    cur = None
    try:
        cur = db_conn.cursor()                      # create a cursor
        cur.execute(stmt, data)
        cur.close()
        return "{"+"\"status\":\"success\",\"id\":\"{}\"".format(data["id"])+"}"

    except (Exception, psycopg2.DatabaseError) as error:
        return "{"+"\"status\":\"error\",\"msg\":\"{}\"".format(error)+"}"
        # Xyzzy510 - error with "error" with quote marks in it. 
    finally:
        if cur is not None:
            cur.close()
    
def run_update ( stmt, data ) :
    global db_conn
    cur = None
    try:
        cur = db_conn.cursor()                      # create a cursor
        cur.execute(stmt, data)
        rowcount = cur.rowcount
        cur.close()

        return "{"+"\"status\":\"success\",\"n_rows\":{}".format(rowcount)+"}"

    except (Exception, psycopg2.DatabaseError) as error:
        return "{"+"\"status\":\"error\",\"msg\":\"{}\"".format(error)+"}"
        # Xyzzy510 - error with "error" with quote marks in it. 
    finally:
        if cur is not None:
            cur.close()
    
def run_delete ( stmt, data ) :
    global db_conn
    cur = None
    try:
        cur = db_conn.cursor()                      # create a cursor
        cur.execute(stmt, data)
        rowcount = cur.rowcount
        cur.close()
        return "{"+"\"status\":\"success\",\"n_rows\":{}".format(rowcount)+"}"

    except (Exception, psycopg2.DatabaseError) as error:
        return "{"+"\"status\":\"error\",\"msg\":\"{}\"".format(error)+"}"
        # Xyzzy510 - error with "error" with quote marks in it. 
    finally:
        if cur is not None:
            cur.close()

    



#################################################################################################################################
# Routes 
#################################################################################################################################

@get('/api/v1/hello')
def hello():
    response.content_type = "application/json"
    return "{\"msg\":\"hello world\"}"

@get('/api/v1/status')
def status():
    response.content_type = "application/json"
    cur = None
    try:
        cur = db_conn.cursor()              
        cur.execute('SELECT \'Database-OK\' as "x"')
        t = cur.fetchone()
        # print ( "server status t={}".format(t) )
        cur.close()
        db_conn.commit()
        return "{"+"\"server_status\":\"Server-OK\",\"database_status\":\"{}\"".format(t[0])+"}"
    except (Exception, psycopg2.DatabaseError) as error:
        return "{"+"\"status\":\"error\",\"msg\":\"{}\"".format(error)+"}"
    finally:
        if cur is not None:
            cur.close()


@get('/api/v1/db-version')
def db_version():
    response.content_type = "application/json"
    global db_version_str
    if db_version_str == "" or db_version_str == None:
        db_version_str = run_select ( 'SELECT version()', {} )
    db_conn.commit()
    return db_version_str

@get('/api/v1/search-keyword')
def search_keyword():
    response.content_type = "application/json"
    dict = parse_qs(request.query_string)
    if not required_param(dict,["kw"]):
        return
    kw = dict["kw"]
    # print ( "kw={}".format( kw ) )
    lang = 'english'
    try:
        cur = db_conn.cursor()              
        cur.execute('SELECT value FROM i_config where name = \'language\'')
        t = cur.fetchone()
        # print ( "server status t={} t[0]=->{}<-".format(t, t[0]) )
        lang = t[0]
        cur.close()
        db_conn.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        lang = 'english'
    finally:
        if cur is not None:
            cur.close()
    # return run_select ( "SELECT * FROM i_issue_st_sv where words @@ to_tsquery('english'::regconfig,%(kw)s)", { "kw":kw[0] } )
    return run_select ( "SELECT * FROM i_issue_st_sv where words @@ to_tsquery('{}'::regconfig,%(kw)s)".format(lang), { "kw":kw[0] } )


@get('/api/v1/get-config')
def get_config():
    response.content_type = "application/json"
    return run_select ( "SELECT * FROM i_config", {})

# /api/issue-list
@get('/api/v1/issue-list')
def issue_list():
    response.content_type = "application/json"
    return run_select ( "SELECT * FROM i_issue_st_sv", {} )


# /api/create-issue
@get('/api/v1/create-issue')
def create_issue():
    global db_conn
    response.content_type = "application/json"
    dict = parse_qs(request.query_string)
    if not required_param(dict,["title","body"]):
        return
    title = dict["title"][0]
    body = dict["body"][0]
    if "severity_id" in dict :
        severity_id = dict["severity_id"][0]
    else:
        severity_id = "1"
    if "state_id" in dict :
        state_id = dict["state_id"][0]
    else:
        state_id = "1"
    if "issue_id" in dict:
        issue_id = dict["issue_id"][0]
    else:
        issue_id = gen_uuid()
    # print ( "title={} body={}".format( title, body ) )
    s = run_insert ( "insert into i_issue ( id, title, body, severity_id, state_id ) values ( %(issue_id)s, %(title)s, %(body)s, %(severity_id)s, %(state_id)s )",
        { "title":title, "body":body, "issue_id":issue_id, "id":issue_id, "severity_id":severity_id, "state_id":state_id } )
    db_conn.commit()
    return s

# /api/delete-issue
@get('/api/v1/delete-issue')
def delete_issue():
    global db_conn
    response.content_type = "application/json"
    dict = parse_qs(request.query_string)
    if not required_param(dict,["issue_id"]):
        return
    issue_id = dict["issue_id"][0]
    # Delete any notes first - to get past the FK
    s = run_delete ( "delete from i_note where issue_id = %(issue_id)s ", { "issue_id":issue_id, "id":issue_id } )
    # print ( "delete i_note = {}".format(s) )
    s = run_delete ( "delete from i_issue where id = %(issue_id)s ", { "issue_id":issue_id, "id":issue_id } )
    db_conn.commit()
    return s

# /api/update-issue
@get('/api/v1/update-issue')
def update_issue():
    global db_conn
    response.content_type = "application/json"
    dict = parse_qs(request.query_string)
    if not required_param(dict,["title","body","issue_id"]):
        return
    title = dict["title"][0]
    body = dict["body"][0]
    issue_id = dict["issue_id"][0]
    if "severity_id" in dict :
        severity_id = dict["severity_id"][0]
        stmt_sev = ", severity_id = %(severity_id)s "
    else:
        severity_id = "1"
        stmt_sev = ""
    if "state_id" in dict :
        state_id = dict["state_id"][0]
        stmt_state = ", state_id = %(state_id)s "
    else:
        state_id = "1"
        stmt_state = ""
    stmt = "update i_issue set title = %(title)s, body = %(body)s "+stmt_sev+stmt_state+" where id = %(issue_id)s"
    data = { "title":title, "body":body, "issue_id":issue_id, "severity_id":severity_id, "state_id":state_id } 
    # print ( "stmt= ->{}<- data={}".format ( stmt, data ) )
    s = run_update ( stmt, data )
    db_conn.commit()
    return s


# /api/v1/get-issue-details - get an issue with all of its notes
@get('/api/v1/get-issue-detail')
def get_issue_detail():
    response.content_type = "application/json"

    dict = parse_qs(request.query_string)
    if not required_param(dict,["issue_id"]):
        return
    issue_id = dict["issue_id"][0]

    issue_data = run_select_raw ( "SELECT * FROM i_issue where id = %(issue_id)s", { "issue_id":issue_id } )

    issue_result = issue_data["result"]

    if issue_data["n_rows"] == 1 :
        note_data = run_select_raw ( "SELECT * FROM i_note where issue_id = %(issue_id)s order by seq", { "issue_id":issue_id } )
        issue_result[0]["note"] = note_data["result"]
        issue_result[0]["n_rows_note"] = note_data["n_rows"]
    else:
        issue_result[0]["note"] = []
        issue_result[0]["n_rows_note"] = 0

    ss = json.dumps(
      issue_result,
      sort_keys=True,
      indent=1,
      default=default
    )

    return "{"+"\"status\":\"success\",\"n_rows\":1,\"data\":{}".format(ss)+"}"
    

# /api/add-note-to-issue
@get('/api/v1/add-note-to-issue')
def add_note_to_issue():
    global db_conn
    response.content_type = "application/json"
    dict = parse_qs(request.query_string)
    if not required_param(dict,["title","body","issue_id"]):
        return
    # print ( "dict={}".format(dict))
    title = dict["title"][0]
    body = dict["body"][0]
    issue_id = dict["issue_id"][0]
    note_id = gen_uuid()
    # note_id --- return this ID
    # print ( "title={} body={}".format( title, body ) )
    s =  run_insert ( "insert into i_note ( id, issue_id, title, body ) values ( %(note_id)s, %(issue_id)s, %(title)s, %(body)s )",
        { "title":title, "body":body, "note_id":note_id, "issue_id":issue_id, "id":note_id } )
    db_conn.commit()
    return s

# /api/upd-note
@get('/api/v1/update-note')
def upd_note():
    global db_conn
    response.content_type = "application/json"
    dict = parse_qs(request.query_string)
    if not required_param(dict,["title","body","note_id"]) :
        return
    title = dict["title"][0]
    body = dict["body"][0]
    note_id = dict["note_id"][0]
    s = run_update ( "update i_note set title = %(title)s, body = %(body)s where id = %(note_id)s", { "title":title, "body":body, "note_id":note_id, "id":note_id } )
    db_conn.commit()
    return s


# /api/upd-severity
@get('/api/v1/update-severity')
def upd_severity():
    global db_conn
    response.content_type = "application/json"
    dict = parse_qs(request.query_string)
    if not required_param(dict,["severity_id","issue_id"]) :
        return
    severity_id = dict["severity_id"][0]
    issue_id = dict["issue_id"][0]
    s = run_update ( "update i_issue set severity_id = %(severity_id)s where id = %(issue_id)s", { "severity_id":severity_id, "issue_id":issue_id } )
    db_conn.commit()
    return s

# /api/upd-state
@get('/api/v1/update-state')
def upd_state():
    global db_conn
    response.content_type = "application/json"
    dict = parse_qs(request.query_string)
    if not required_param(dict,["state_id","issue_id"]):
        return
    state_id = dict["state_id"][0]
    issue_id = dict["issue_id"][0]
    s = run_update ( "update i_issue set state_id = %(state_id)s where id = %(issue_id)s", { "state_id":state_id, "issue_id":issue_id } )
    db_conn.commit()
    return s


@get('/api/v1/get-state')
def get_state():
    response.content_type = "application/json"
    return run_select ( "SELECT * FROM i_state", {})

@get('/api/v1/get-severity')
def get_severity():
    response.content_type = "application/json"
    return run_select ( "SELECT * FROM i_severity", {})







#################################################################################################################################
# RESTful Interface to issue, note
#################################################################################################################################

# on get - if __method__=X then do X instead
@get('/api/v1/issue')
def issue_get():
    dict = parse_qs(request.query_string)
    if "__method__" in dict:
        method = lower(dict["__method__"][0])
        if method == "post":
            return create_issue()
        elif method == "delete":
            return delete_issue()
        elif method == "put":
            return update_issue()
    return issue_list()

@post('/api/v1/issue')
def issue_post():
    return create_issue()

@put('/api/v1/issue')
def issue_post():
    return update_issue()

@delete('/api/v1/issue')
def issue_post():
    return delete_issue()



@put('/api/v1/note')
def note_put():
    return upd_note()


@get('/api/v1/state')
def state_get():
    return get_state()

@get('/api/v1/severity')
def severity_get():
    return get_severity()







#################################################################################################################################
# File Server
#################################################################################################################################

@route('/')
def server_index_html():
    global root_dir
    return static_file("/index.html", root=root_dir)

@route('/<filepath:path>')
def server_static(filepath):
    global root_dir
    return static_file(filepath, root=root_dir)

@error(404)
def error404(error):
    return '404 error - nothing here, sorry'




app_config = None

if __name__ == '__main__':
    try:
        app_config = config(filename='app_config.ini', section='app')
        connect()
        cwd = os.getcwd()
        if root_dir[0] != '/' :
            # root_dir = cwd + "/" + root_dir 
            root_dir = os.path.join(cwd, root_dir)
            # print ( "root_dir={}".format(root_dir) )
        root_dir = os.path.normpath(root_dir)
        # print ( "root_dir={}".format(root_dir) )
        run(host='127.0.0.1', port=12128, debug=True)
        disconnect()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
        disconnect()
    finally:
        disconnect()


