/*
 * Copyright (c) 2013, Intel Corporation
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 * 
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in
 *       the documentation and/or other materials provided with the
 *       distribution.
 * 
 *     * Neither the name of Intel Corporation nor the names of its
 *       contributors may be used to endorse or promote products derived
 *       from this software without specific prior written permission.
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 * pmem_cl.c -- cache-line-based implementation of libpmem
 *
 * WARNING: This is for use with Persistent Memory -- if you use this
 * with a traditional page-cache-based memory mapped file, your changes
 * will not be durable.
 */

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdint.h>
#include "util/util.h"
#include <sys/types.h>
#include <sys/mman.h>
#include <stdio.h>
#include <stdint.h>
#include <libpmemlog.h>
#include <assert.h>

#define _DATAPERSIST 10
#define _PERSIST

#define	ALIGN 64	/* assumes 64B cache line size */

//#define _ENABLE_LOG
PMEMlogpool *g_plp;

#ifdef _ENABLE_LOG
PMEMlogpool *create_log(){

	const char path[] = "/mnt/pmfs/logfile";
	int fd;
	size_t nbyte;
	char *str;

	fprintf(stderr, "creating log file \n");

#ifdef _PREMAPPED_FILE
#else
	/* create file on PMEM-aware file system */
	if ((fd = open(path, O_CREAT|O_RDWR, 0666)) < 0) {
		perror("open");
		exit(1);
	}

	/* pre-allocate 2GB of persistent memory */
	if ((errno = posix_fallocate(fd, (off_t)0,
					(size_t)1024 * 1024 * 2048)) != 0) {
		perror("posix_fallocate");
		exit(1);
	}
	close(fd);
#endif
	/* create a persistent memory resident log */
	if ((g_plp = pmemlog_pool_open(path)) == NULL) {
		perror("pmemlog_pool_open");
		exit(1);
	}
	return g_plp;
}

int write_log(PMEMlogpool *plp, void *addr, size_t len){

	if(!plp){
		perror("invalid log ptr");
		exit(1);
	}

	if (pmemlog_append(plp, addr, len) < 0) {
		perror("pmemlog_append");
		exit(1);
	}
}
#endif


/*
 * pmem_map -- map the Persistent Memory
 *
 * This is just a convenience function that calls mmap() with the
 * appropriate arguments.
 *
 * This is the cache-line-based version.
 */
void *
pmem_map_cl(int fd, size_t len)
{
	void *base;

	if ((base = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_SHARED,
					fd, 0)) == MAP_FAILED)
		return NULL;

#ifdef _ENABLE_LOG
	create_log();
#endif

	return base;
}

/*
 * pmem_drain_pm_stores -- wait for any PM stores to drain from HW buffers
 *
 * This is the cache-line-based version.
 */
void
pmem_drain_pm_stores_cl(void)
{
	/*
	 * Nothing to do here -- this implementation assumes the platform
	 * has something like Intel's ADR feature, which flushes HW buffers
	 * automatically on power loss.  This implementation further assumes
	 * the Persistent Memory hardware itself doesn't need to be alerted
	 * when something needs to be persistent.  Of course these assumptions
	 * may be wrong for different combinations of Persistent Memory
	 * products and platforms, but this is just example code.
	 *
	 * TODO: update this to work on other types of platforms.
	 */
}

/*
 * pmem_flush_cache -- flush processor cache for the given range
 *
 * This is the cache-line-based version.
 */
void
pmem_flush_cache_cl(void *addr, size_t len, int flags)
{

#ifdef _NOPERSIST
    return;
#elif _NODATAPERSIST
if(flags == _DATAPERSIST){
    if(!enable_persist()) {
       return;
     }else {
     }
   }
#endif
	uintptr_t uptr;
	
	/* loop through 64B-aligned chunks covering the given range */
	for (uptr = (uintptr_t)addr & ~(ALIGN - 1);
			uptr < (uintptr_t)addr + len; uptr += 64)
		__builtin_ia32_clflush((void *)uptr); 
}

/*
 * pmem_persist -- make any cached changes to a range of PM persistent
 *
 * This is the cache-line-based version.
 */
void
pmem_persist_cl(void *addr, size_t len, int flags)
{

#ifdef _NOPERSIST
    return;
#elif _NODATAPERSIST
 if(flags == _DATAPERSIST){
     if(!enable_persist()) {
        return;
      }else {
      }
    }
#endif

#ifdef _ENABLE_LOG
	 write_log(g_plp, addr, len);
#endif
	pmem_flush_cache_cl(addr, len, flags);
	__builtin_ia32_sfence();
	pmem_drain_pm_stores_cl();
}
