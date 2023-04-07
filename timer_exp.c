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

//這個function裡寫time out時要怎麼處理
void timeout_handler(int signum)
{
    printf("!!!!!!pthread_create!!!!!!\n\n");
	pthread_t tid; // 宣告 pthread 變數
	pthread_create(&tid, NULL, lat_thread, NULL);
	pthread_join(tid, NULL);
    printf("!!!!!!Timeout!!!!!!\n\n");  
}

timer_t create_the_timer(int sig, int sec){

    timer_t timerid;            //定時器ID      
    struct sigevent sev;        //指定了定時器到期要產生的異步通知
    struct itimerspec its;      //超時結構體
    struct sigaction sa;        //超時要觸發的signal

    sa.sa_handler = timeout_handler;    //time out的處理function
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;
    if(sigaction(SIGUSR1, &sa, NULL) == -1)
        perror("sigaction");

    sev.sigev_notify = SIGEV_SIGNAL;
    sev.sigev_signo = sig;
    sev.sigev_value.sival_ptr = &timerid;
    if(timer_create(CLOCK_REALTIME, &sev, &timerid) == -1)
        perror("timer_create");

    its.it_value.tv_sec = sec;                      //表示定時器的第一次超時時間
    its.it_value.tv_nsec = 0;
    its.it_interval.tv_sec = its.it_value.tv_sec;   //表示定時器第一次超時以後的超時時間間隔
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



