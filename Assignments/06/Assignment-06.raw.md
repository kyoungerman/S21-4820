
m4_include(../../Lect/lect-setup.m4)

# Use Redis to make a list of capitals

Pts: 50
Due 18th.


from: [https://realpython.com/python-redis/](https://realpython.com/python-redis/)
About 2/3 the way down has Redis in python examples - the first part is all
about how to install Redis.  On your virtual Linux system:

Install Redis on your system.

```
$ sudo apt-get install redis
```

If you are working on Windows - then you will need to Follow
these instructions [https://redislabs.com/ebook/appendix-a/a-3-installing-on-windows/a-3-2-installing-redis-on-window/](https://redislabs.com/ebook/appendix-a/a-3-installing-on-windows/a-3-2-installing-redis-on-window/)

On a MacOS system if you want Redis I suggest using "brew" to do the install.

First install brew (if you do not already have it)  See the instructions at [https://brew.sh/](https://brew.sh/)

Then in a terminal:

```
$ brew update
$ brew install redis
$ brew services start redis
```



Install the Redis package in python.

```
$ python -m pip install redis
```

Depending on your install of python you may need "python3 -m pip install redis" or "pip install redis".



Write a simple program that takes a dictionary of capitals
and saves that into Redis and queries it.


```
#!/bin/python

import redis
r = redis.Redis()		# Connect to redis

r.mset({
	"Bahamas": "Nasau",
	"Germany": "Berlin",
})

lookup = r.get("Bahamas")
print ( "Capital of Bahamas {}".format(lookup) )

```

Lookup the capital of at least 2 other countries
and add that to your data.   I kind of like
The Uruguay and Finland.


Turn in a .png/jpg screen capture of running the program and go into redis-cli
and use the get command to get one of the countries capitals.


