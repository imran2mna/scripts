#include "files.h"
#define BUFFER_SIZE 8192
#define FORMAT_SIZE 8192

// below are private methods
data_t * pushNode(data_t **ptr, char * line);

/*
 * fail - 0
 * success - 1
 * */
int isRegularFile(char * path){
	struct stat sb;
	if(stat(path, &sb) == -1) {
		perror("stat");
		return 0;
	}
	if((sb.st_mode & S_IFMT) != S_IFREG) {
		fprintf(stderr, "%s is not a regular file.\n", path);
		return 0;
	}
	if(sb.st_size == 0) {
		fprintf(stderr, "%s is a empty file.\n", path);
		return 0;
	}
	return 1;
}


int getLine(char * path, data_t ** dt){
	if(path == NULL) {
		fprintf(stderr, "getLine(): Invalid arguments\n");
		return -1;
	}
	if(!isRegularFile(path)) return -1;

	int fd = -1;
	char * fstr = (char*) malloc(FORMAT_SIZE * sizeof(char));
       	char * buffer = (char*) malloc(BUFFER_SIZE * sizeof(char)); 
	if((fd = open(path, O_RDONLY, S_IRUSR)) == -1) {
		perror("open");
		return -1;
	}

	int readNum = 0, remain = 0;
	char * delim = "\n";
	char *line, *saveptr;
	data_t * prev = NULL;
	while((readNum = read(fd, buffer, BUFFER_SIZE)) > 0) {
		line = strtok_r(buffer, delim, &saveptr);
		if(line != NULL) {
			memset(fstr, '\0', FORMAT_SIZE);
			if(remain && prev != NULL) {
				if(strlen(prev->line) >= FORMAT_SIZE) {
					fprintf(stderr, "getLine() : not simple regular text file\n");
				       	return -1;
				}
				strcpy(fstr, prev->next->line);
				free(prev->next);
				prev->next = NULL;
			}
			strcat(fstr, line);
			prev = pushNode(dt,fstr);
		}
		while((line = strtok_r(NULL, delim, &saveptr)) != NULL) {
			memset(fstr, '\0', FORMAT_SIZE);
			strcpy(fstr, line);
			prev = pushNode(dt, line);
		}
		remain = (buffer[(readNum - 1)] != '\n') && (readNum == BUFFER_SIZE); 
		memset(buffer, '\0', BUFFER_SIZE);
	} 

	if(close(fd) == -1) {
		perror("close");
		return -1;
	}

	free(fstr);
	free(buffer);
	
	if(*dt == NULL) { 
		fprintf(stderr, "getLine(): data structures");
		return -1;
	}	

	return 0;
}


data_t * pushNode(data_t **ptr, char * line){
	if(ptr == NULL || line == NULL) return NULL; 
	
	data_t * newNode = (data_t *) malloc(sizeof(data_t));
	newNode->line = (char *) malloc((strlen(line) + 1) * sizeof(char));
	memset(newNode->line, '\0', strlen(line) + 1);
	strcpy(newNode->line, line);
	if(*ptr == NULL) {
		*ptr = newNode; 
		return newNode;	
	}  
	
	data_t * temp = *ptr;
	while(temp->next != NULL) temp = temp->next;
	temp->next = newNode;
	return temp;
}
