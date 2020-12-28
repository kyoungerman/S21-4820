/*
You need libuuid and libuuid-dev on linux

	$ sudo apt-get install uuid-dev
	$ gcc test1.c /usr/lib/x86_64-linux-gnu/libuuid.a
	$ ./a.out

On Mac

On Windows
	You will need to intall a C compiler or C++ comiler.  Do that first.
	Then 

*/


#include <stdlib.h>
#include <stdio.h>
#include <uuid/uuid.h> 

int main(void) {
    uuid_t binuuid;
    /* Generate a UUID. */
    uuid_generate_random(binuuid);

    /* Allocate space for string and convert to string */
    char *uuid = malloc(37);
    uuid_unparse(binuuid, uuid); 

    printf("%s\n",uuid);

    return 0;
}
