#include <stdio.h>
#include <stdlib.h>

#include "config.h"

int main(int argc, char *argv[])
{
	printf("Hello World, I'm @name@!\n");
	printf("My license is " LICENSE_STR ".\n");

	exit(EXIT_SUCCESS);
}
