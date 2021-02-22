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






get1( "http://localhost:12128/api/v1/status", {} )

