#include "files.h"
#include <sys/time.h>

int main(int argc, char * argv[]){
	if(argc != 2) {
		fprintf(stderr, "Usage : %s <config-path>\n", argv[0]);
		return EXIT_FAILURE;
	}

	struct timeval tv1, tv2;

	if(gettimeofday(&tv1, NULL) == -1) {
		perror("gettimeofday");
		return 1;
	}

	data_t * dt = NULL;
	if(getLine(argv[1], &dt) == -1) return EXIT_FAILURE;
	
	while(dt->next != NULL) {
		printf("%s\n", dt->line);
		dt = dt->next;
	}
	printf("%s\n", dt->line);

	if(gettimeofday(&tv2, NULL) == -1) {
		perror("gettimeofday");
		return 1;
	}

	return EXIT_SUCCESS;
}
