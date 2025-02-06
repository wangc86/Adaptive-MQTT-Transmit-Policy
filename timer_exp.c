#include <stdio.h>

#include <time.h>
#include <signal.h>
#include <unistd.h>
#include <pthread.h>

void* lat_thread(void *arg){
	// system("./timer_exp.o");
	printf("In the thread...\n");
	FILE *fptr;
	fptr = fopen("test.txt","w");
	if(fptr == NULL)
	{
		printf("Error!");   
		// exit(1);
	}
	fprintf(fptr,"%s","help!!!");
   	fclose(fptr);
	
	// int result=0;
	// pthread_exit((void) result);
	pthread_exit(NULL);
}

// handle time out
void timeout_handler(int signum)
{
    printf("!!!!!!pthread_create!!!!!!\n\n");
	pthread_t tid; // declare variable for pthread 
	pthread_create(&tid, NULL, lat_thread, NULL);
	pthread_join(tid, NULL);
    printf("!!!!!!Timeout!!!!!!\n\n");  
}

timer_t create_the_timer(int sig, int sec){

    timer_t timerid;                  
    struct sigevent sev;        
    struct itimerspec its;      
    struct sigaction sa;        

    sa.sa_handler = timeout_handler;    
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;
    if(sigaction(SIGUSR1, &sa, NULL) == -1)
        perror("sigaction");

    sev.sigev_notify = SIGEV_SIGNAL;
    sev.sigev_signo = sig;
    sev.sigev_value.sival_ptr = &timerid;
    if(timer_create(CLOCK_REALTIME, &sev, &timerid) == -1)
        perror("timer_create");

    its.it_value.tv_sec = sec;                      
    its.it_value.tv_nsec = 0;
    its.it_interval.tv_sec = its.it_value.tv_sec;   
    its.it_interval.tv_nsec = its.it_value.tv_nsec;

    if(timer_settime(timerid, 0, &its, NULL) == -1)
        perror("timer_settime");
    return timerid;

}

int main()
{
    create_the_timer(SIGUSR1,3);
    while (1) {
        pause();
    }

    return 0;
}



