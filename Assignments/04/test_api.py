#!/home/pschlump/anaconda3/bin/python
#!/use/bin//python3

# TODO - implement it.

"""
Better: https://www.geeksforgeeks.org/get-post-requests-using-python/

From: https://stackoverflow.com/questions/21078888/how-do-i-make-http-post-requests-with-grequests

import grequests

urls = ['http://localhost/test', 'http://localhost/test']

params = {'a':'b', 'c':'d'}
rs = (grequests.post(u, data=params) for u in urls)
grequests.map(rs)

"""


# importing the requests library 
import requests 

def get1():

    # api-endpoint 
    URL = "http://localhost:12128/api/v1/status"

    # location given here 
    location = "Wyoming, Lramie"

    # defining a params dict for the parameters to be sent to the API 
    PARAMS = {'address':location} 

    # sending get request and saving the response as response object 
    r = requests.get(url = URL, params = PARAMS) 

    # extracting data in json format 
    data = r.json() 

    stat = data['status']

    print("Status:%s\n" % (stat)) 






def post():

    # defining the api-endpoint 
    API_ENDPOINT = "http://pastebin.com/api/api_post.php"

    # your API key here 
    API_KEY = "XXXXXXXXXXXXXXXXX"

    # your source code here 
    source_code = ''' 
    print("Hello, world!") 
    a = 1 
    b = 2 
    print(a + b) 
    '''

    # data to be sent to api 
    data = {'api_dev_key':API_KEY, 
                    'api_option':'paste', 
                    'api_paste_code':source_code, 
                    'api_paste_format':'python'} 

    # sending post request and saving response as response object 
    r = requests.post(url = API_ENDPOINT, data = data) 

    # extracting response text 
    pastebin_url = r.text 
    print("The pastebin URL is:%s"%pastebin_url) 


get1()

