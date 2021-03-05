#ifndef FILES_H
#define FILES_H
#endif


#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

typedef struct _node {
	char *line;
	struct _node *next;
} data_t;


int isRegular(char * path);

// get line by line from regular file
int getLine(char * path, data_t ** dt);
