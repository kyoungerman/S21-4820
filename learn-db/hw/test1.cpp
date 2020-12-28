/*
You need libuuid and libuuid-dev on linux

	$ sudo apt-get install uuid-dev
	$ g++ test1.cpp /usr/lib/x86_64-linux-gnu/libuuid.a 
	$ ./a.out

On Mac

On Windows
	You will need to intall a C compiler or C++ comiler.  Do that first.
	Then 

*/


#include <stdlib.h>
#include <stdio.h>
#include <uuid/uuid.h> 
#include <iostream> 

using namespace std;

int main(void) {
    uuid_t binuuid;
    /* Generate a UUID. */
    uuid_generate_random(binuuid);

    /* Allocate space for string and convert to string */
    char *uuid = (char *)malloc(37);
    uuid_unparse(binuuid, uuid); 

	cout << uuid << endl;

    return 0;
}
