#include <stdio.h>
#include <stdlib.h>

#include "config.h"

int main(int argc, char *argv[])
{
	printf("Hello World, I'm version " VERSION_STR " of @name@!\n");
	printf("My license is " LICENSE_STR ".\n");

	exit(EXIT_SUCCESS);
}
