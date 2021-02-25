#!/home/pschlump/anaconda3/bin/python
#!/use/bin//python3

# TODO 
# 1. Read in a config file - for http://localhost:12128
# 2. Do tests - hard coded
# 3. Do Get tests
# 4. Compare JSON data for criteria
# 5. Hard code compare results
# 6. Add command line - for what tests to run.

"""
See: https://www.geeksforgeeks.org/get-post-requests-using-python/
"""


# importing the requests library 
import requests 

def get1( URL, PARAMS ):

    # sending get request and saving the response as response object 
    r = requests.get(url = URL, params = PARAMS) 

    # extracting data in json format 
    data = r.json() 

    stat = data['status']

    print("Status:%s\n" % (stat)) 






def post1( URL, PARAMS ):

    # sending post request and saving response as response object 
    r = requests.post(url = URL, data = PARAMS) 

    # extracting response text 
    pastebin_url = r.text 
    print("The pastebin URL is:%s" % pastebin_url) 






# @app.route('/status', method=['OPTIONS', 'GET'])
get1( "http://localhost:12128/api/v1/status", {} )


#@app.route('/api/v1/hello', method=['OPTIONS', 'GET'])
#@app.route('/api/v1/global-data.js', method=['OPTIONS', 'GET'])
#@app.route('/api/v1/db-version', method=['OPTIONS', 'GET'])
#@app.route('/api/v1/search-keyword', method=['OPTIONS', 'GET'])
#@app.route('/api/v1/get-config', method=['OPTIONS', 'GET'])
#@app.route('/api/v1/issue-list', method=['OPTIONS', 'GET'])
#@app.route('/api/v1/create-issue', method=['OPTIONS', 'GET']) # POST
#@app.route('/api/v1/delete-issue', method=['OPTIONS', 'GET']) # POST
#@app.route('/api/v1/update-issue', method=['OPTIONS', 'GET']) # POST
#@app.route('/api/v1/get-issue-detail', method=['OPTIONS', 'GET'])
#@app.route('/api/v1/add-note-to-issue', method=['OPTIONS', 'GET']) # POST
#@app.route('/api/v1/delete-note', method=['OPTIONS', 'GET']) # POST
#@app.route('/api/v1/update-severity', method=['OPTIONS', 'GET']) # POST
#@app.route('/api/v1/update-state', method=['OPTIONS', 'GET']) # POST
#@app.route('/api/v1/get-state', method=['OPTIONS', 'GET'])
#@app.route('/api/v1/get-severity', method=['OPTIONS', 'GET'])



#@app.route('/api/v1/note', method=['OPTIONS', 'DELETE'])
#@app.route('/api/v1/note', method=['OPTIONS', 'PUT'])
#@app.route('/api/v1/get-note', method=['OPTIONS', 'GET'])
#@app.route('/api/v1/issue', method=['OPTIONS', 'GET', 'POST', 'PUT', 'DELETE'])
#@app.route('/api/v1/issue', method=['OPTIONS', 'POST'])
#@app.route('/api/v1/issue', method=['OPTIONS', 'PUT'])
#@app.route('/api/v1/issue', method=['OPTIONS', 'DELETE'])
#@app.route('/api/v1/note', method=['OPTIONS', 'GET'])
#@app.route('/api/v1/note', method=['OPTIONS', 'PUT'])
#@app.route('/api/v1/note', method=['OPTIONS', 'POST'])
#@app.route('/api/v1/state', method=['OPTIONS', 'GET'])
#@app.route('/api/v1/severity', method=['OPTIONS', 'GET'])
