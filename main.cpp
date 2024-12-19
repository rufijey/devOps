#include <iostream>
#include <sys/wait.h>
#include "ClassA.h"

int CreateHTTPserver();

void sigchldHandler(int s)
{
	printf("Caught signal SIGCHLD\n");

	pid_t pid;
	int status;
	
	while((pid = waitpid(-1,&status,WNOHANG)) > 0)
	{
		if(WIFEXITED(status)) printf("\nChild process termainated");
	}

}

void sigintHandler(int s)
{
        printf("Caught signal %d. Starting graceful exit procedure\n",s);

        pid_t pid;
        int status;

        while((pid = waitpid(-1,&status,WNOHANG)) > 0)
        {
                if(WIFEXITED(status)) printf("\nChild process termainated");
        }

	if (pid == -1) printf("\nAll child processes termainated");
	
	exit(EXIT_SUCCESS);

}

int main(int argc, char* argv[]) {
	signal(SIGCHLD, sigchldHandler);
	signal(SIGINT, sigintHandler);
	CreateHTTPserver();
	return 0;
}
