#define _GNU_SOURCE
 #include <errno.h>

#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <assert.h>
//#include <numa.h>
#include <time.h>
#include <inttypes.h>
#include <pthread.h>

//#define _STOPMIGRATION //also in make file

#define BUGFIX

<<<<<<< HEAD
#define MAX_ENTRIES 100*1024*1024
#define OBJECT_TRACK_SZ 1024*64
#define MAXPAGELISTSZ 1024*1024*100
#define NODE_TO_MIGRATE 1
#define MIGRATEFREQ 2
//#define HINT_MIGRATION

#define __NR_move_inactpages 317
#define __NR_NValloc 316

static int init_alloc;
static unsigned int alloc_cnt;
static unsigned int g_allocidx, g_uselast_off;
unsigned long *chunk_addr = NULL;
size_t *chunk_sz = NULL;
int *chunk_mig_status=NULL;
static unsigned int offset;
struct timespec spec;
void **migpagelist = NULL;
static size_t stat_allocsz;

//int init = 0;
struct bitmask *old_nodes;
struct bitmask *new_nodes;
static int init_numa;

#ifdef HINT_MIGRATION
//flag to indicate if migration should start
static int migratenow_flag;
#endif


//pthread code
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t largemutex= PTHREAD_MUTEX_INITIALIZER;
pthread_t thr;
=======
#define MIGRATEFREQ 2

struct timespec spec;


pthread_t thr1;
>>>>>>> 020d176e51e0c09895794d71e79013ad23fd2911


void init_epoch();
void epoch_fn();
int enable_persist();

int  persist_set=0;

void call_migrate_func()
{
	while(1) {
		epoch_fn();    
	}
	return;
}

#define handle_error_en(en, msg) \
		do { errno = en; perror(msg); exit(EXIT_FAILURE); } while (0)

   int  setaff(int aff)
   {
	   int s, j;
	   cpu_set_t cpuset;
	   pthread_t thread;

		j=aff;

	   thread = pthread_self();

	   /* Set affinity mask to include CPUs 0 to 7 */
	   CPU_ZERO(&cpuset);
	   CPU_SET(j, &cpuset);

	   s = pthread_setaffinity_np(thread, sizeof(cpu_set_t), &cpuset);
	   if (s != 0)
		   handle_error_en(s, "pthread_setaffinity_np");

	   /* Check the actual affinity mask assigned to the thread */
	   s = pthread_getaffinity_np(thread, sizeof(cpu_set_t), &cpuset);
	   if (s != 0)
		   handle_error_en(s, "pthread_getaffinity_np");

	   printf("Set returned by pthread_getaffinity_np() contained:\n");
	   if (CPU_ISSET(j, &cpuset))
		   printf("    CPU %d\n", j);

	   //exit(EXIT_SUCCESS);
	   return 0;
   }



<<<<<<< HEAD
void * entry_point(void *arg)
{
    printf("starting thread\n");
	setaff(3);
    call_migrate_func();
=======
void * mypoint(void *arg)
{
    printf("starting thread\n");
	//setaff(9);
    //call_migrate_func();
>>>>>>> 020d176e51e0c09895794d71e79013ad23fd2911
    printf("exiting thread\n");
    return NULL;
}

void init_epoch() {

<<<<<<< HEAD
	clock_gettime(CLOCK_REALTIME, &spec);

	if(pthread_create(&thr, NULL, &entry_point, NULL))
    {
        printf("Could not create thread\n");
		//pthread_mutex_unlock(&mutex);
        assert(0);
    }
	
	init_alloc = 1;
=======
	//clock_gettime(CLOCK_REALTIME, &spec);

	if(pthread_create(&thr1, NULL, &mypoint, NULL))
    {
        //printf("Could not create thread\n");
		//pthread_mutex_unlock(&mutex);
        //assert(0);
    }
	
	//init_alloc = 1;
>>>>>>> 020d176e51e0c09895794d71e79013ad23fd2911
}


int enable_persist(){

	return persist_set;

}

void epoch_fn() {

	if(persist_set) {
		persist_set=0;
	}
	else {
		persist_set=1; 	
	}

	sleep(MIGRATEFREQ);
	return;
}






