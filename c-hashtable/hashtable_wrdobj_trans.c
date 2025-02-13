/* Copyright (C) 2004 Christopher Clark <firstname.lastname@cl.cam.ac.uk> */

#include "hashtable.h"
#include "hashtable_private.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "nv_map.h"
#include "c_io.h"

#define _USE_TRANSACT
#define WORD_OBJ_TRANS
/*
Credit for primes table: Aaron Krowne
 http://br.endernet.org/~akrowne/
 http://planetmath.org/encyclopedia/GoodHashTablePrimes.html
*/
static const unsigned int primes[] = {
53, 97, 193, 389,
769, 1543, 3079, 6151,
12289, 24593, 49157, 98317,
196613, 393241, 786433, 1572869,
3145739, 6291469, 12582917, 25165843,
50331653, 100663319, 201326611, 402653189,
805306457, 1610612741
};
const unsigned int prime_table_length = sizeof(primes)/sizeof(primes[0]);
const float max_load_factor = 0.65;

void *p_c_nvalloc_( size_t size, char *var, int rqstid){
	return malloc(size);
}

void p_c_free_(void *ptr){
	free(ptr);
}

/*****************************************************************************/
struct hashtable *
create_hashtable(unsigned int minsize,
                 unsigned int (*hashf) (void*),
                 int (*eqf) (void*,void*))
{
    struct hashtable *h;
    unsigned int pindex, size = primes[0];
    /* Check requested hashtable isn't too large */
    if (minsize > (1u << 30)) return NULL;
    /* Enforce size as prime */
    for (pindex=0; pindex < prime_table_length; pindex++) {
        if (primes[pindex] > minsize) { size = primes[pindex]; break; }
    }

   rqst_s rqst;
   h =   (struct hashtable *)p_c_nvalloc_(sizeof(struct hashtable), 
					 (char *)"h", 0);
    if (NULL == h) return NULL; /*oom*/

    
     
    h->table = (struct entry **)p_c_nvalloc_(sizeof(struct entry*) * size, 
					 (char *)"table", 0);
    if (NULL == h->table) { p_c_free_(h); return NULL; } /*oom*/


    memset(h->table, 0, size * sizeof(struct entry *));

#ifndef WORD_OBJ_TRANS
    C_BEGIN_WRDTRANS((void *)&h->tablelength,0, sizeof(unsigned int));
    h->tablelength  = size;
    p_c_nvcommitword((void *)&h->tablelength);
    C_BEGIN_WRDTRANS((void *)&h->primeindex,0, sizeof(unsigned int));
    h->primeindex   = pindex;
    p_c_nvcommitword((void *)&h->primeindex);
    C_BEGIN_WRDTRANS((void *)&h->entrycount,0, sizeof(unsigned int));
    h->entrycount   = 0;
    p_c_nvcommitword((void *)&h->entrycount);
    C_BEGIN_WRDTRANS((void *)&h->hashfn,0, sizeof(unsigned long));
    h->hashfn       = hashf;
    p_c_nvcommitword((void *)&h->hashfn);	
    C_BEGIN_WRDTRANS((void *)&h->eqfn,0, sizeof(unsigned long));
    h->eqfn         = eqf;
    p_c_nvcommitword((void *)&h->eqfn);	
    C_BEGIN_WRDTRANS((void *)&h->loadlimit,0, sizeof(unsigned int));
    h->loadlimit    = (unsigned int) ceil(size * max_load_factor);
    p_c_nvcommitword((void *)&h->loadlimit);
#else
    C_BEGIN_OBJTRANS((void *)h,0);
    h->tablelength  = size;
    h->primeindex   = pindex;
    h->entrycount   = 0;
    h->hashfn       = hashf;
    h->eqfn         = eqf;
    h->loadlimit    = (unsigned int) ceil(size * max_load_factor);
    p_c_nvcommitobj((void *)h,0);
#endif

    return h;
}


/*****************************************************************************/
#ifdef 0
struct hashtable *
restart_hashtable(unsigned int minsize,
                 unsigned int (*hashf) (void*),
                 int (*eqf) (void*,void*))
{
    struct hashtable *h;
    unsigned int pindex, size = primes[0];
    /* Check requested hashtable isn't too large */
    if (minsize > (1u << 30)) return NULL;
    /* Enforce size as prime */
    for (pindex=0; pindex < prime_table_length; pindex++) {
        if (primes[pindex] > minsize) { size = primes[pindex]; break; }
    }
   rqst_s rqst;
   h =   (struct hashtable *)p_c_nvalloc_(sizeof(struct hashtable),
					 (char *)"h", 0);
    if (NULL == h) return NULL; /*oom*/

    h->table = (struct entry **)p_c_nvalloc_(sizeof(struct entry*) * size,
					 (char *)"table", 0);
    if (NULL == h->table) { p_c_free_(h); return NULL; } /*oom*/

    fprintf(stdout, " h->tablelength %u\n", h->tablelength);
    fprintf(stdout, " h->primeindex %u\n", h->primeindex);
    fprintf(stdout, " h->entrycount %u\n", h->entrycount);
    fprintf(stdout, " h->hashfn %u\n", h->hashfn);
    fprintf(stdout, " h->eqfn %u\n",h->eqfn);
    fprintf(stdout, " h->loadlimit %u\n", h->loadlimit);

    int count =0;
    struct entry *e = NULL;
    for(count =0; count < h->tablelength; count++){

    	if(count == 22)
    		printf(stdout,"alert\n");

    	C_LOADNVPTR(&h->table[count]);
    	e = h->table[count];
    	if(e != NULL) {
    		C_LOADNVPTR(&e->k);
    		C_LOADNVPTR(&e->v);
    		C_LOADNVPTR(&e->next);
    		struct entry *nxt = e->next;
    		while(nxt) {
    			C_LOADNVPTR(&nxt);
    			if(nxt) {
    				nxt = nxt->next;
    			}
    		}

    	}
    }
    return h;
}
#endif-


/*****************************************************************************/
unsigned int
hash(struct hashtable *h, void *k)
{
    /* Aim to protect against poor hash functions by adding logic here
     * - logic taken from java 1.4 hashtable source */
    unsigned int i = h->hashfn(k);
    i += ~(i << 9);
    i ^=  ((i >> 14) | (i << 18)); /* >>> */
    i +=  (i << 4);
    i ^=  ((i >> 10) | (i << 22)); /* >>> */
    return i;
}

/*****************************************************************************/
static int
hashtable_expand(struct hashtable *h)
{
    /* Double the size of the table to accomodate more entries */
    struct entry **newtable;
    struct entry *e;
    struct entry **pE;
    unsigned int newsize, i, index;
    /* Check we're not hitting max capacity */
    if (h->primeindex == (prime_table_length - 1)) return 0;
    newsize = primes[++(h->primeindex)];

   newtable =  (struct entry **)p_c_nvalloc_(sizeof(struct entry*) * newsize, 
					 (char *)"table", 0);
    if (NULL != newtable)
    {
        memset(newtable, 0, newsize * sizeof(struct entry *));
        /* This algorithm is not 'stable'. ie. it reverses the list
         * when it transfers entries between the tables */
        for (i = 0; i < h->tablelength; i++) {
            while (NULL != (e = h->table[i])) {
                h->table[i] = e->next;
                index = indexFor(newsize,e->h);
                e->next = newtable[index];
                newtable[index] = e;
            }
        }
        //free(h->table);
        p_c_free_(h->table); 

        h->table = newtable;
    }
    /* Plan B: realloc instead */
    else 
    {
	assert(0);
	fprintf(stdout,"realloc \n");
        newtable = (struct entry **)
                   realloc(h->table, newsize * sizeof(struct entry *));
        if (NULL == newtable) { (h->primeindex)--; return 0; }
        h->table = newtable;
        memset(newtable[h->tablelength], 0, newsize - h->tablelength);
        for (i = 0; i < h->tablelength; i++) {
            for (pE = &(newtable[i]), e = *pE; e != NULL; e = *pE) {
                index = indexFor(newsize,e->h);
                if (index == i)
                {
                    pE = &(e->next);
                }
                else
                {
                    *pE = e->next;
                    e->next = newtable[index];
                    newtable[index] = e;
                }
            }
        }
    }
    h->tablelength = newsize;
    h->loadlimit   = (unsigned int) ceil(newsize * max_load_factor);
    return -1;
}

/*****************************************************************************/
unsigned int
hashtable_count(struct hashtable *h)
{
    return h->entrycount;
}


/*****************************************************************************/
int
hashtable_insert(struct hashtable *h, void *k, void *v)
{
    /* This method allows duplicate keys - but they shouldn't be used */
    unsigned int index;
    struct entry *e;

    #ifdef _USE_TRANSACT
    C_BEGIN_WRDTRANS((void *)&h->entrycount,0, sizeof(unsigned int));	
    #endif

    ++(h->entrycount);

    #ifdef _USE_TRANSACT
    p_c_nvcommitword((void *)&h->entrycount);
    #endif

    if ((h->entrycount) > h->loadlimit)
    {
        /* Ignore the return value. If expand fails, we should
         * still try cramming just this value into the existing table
         * -- we may not have memory for a larger table, but one more
         * element may be ok. Next time we insert, we'll try expanding again.*/
    	//C_BEGIN_OBJTRANS((void *)h,0);
        hashtable_expand(h);
       // p_c_nvcommitobj((void *)h,0);
    }
   char varnam[64];
   bzero(varnam, 64);
   sprintf(varnam,"%d",h->entrycount);
   varnam[64]=0;

   e = (struct entry *)p_c_nvalloc_(sizeof(struct entry), (char *)varnam, 0);
    if (NULL == e) {

   	   #ifdef _USE_TRANSACT
    	   C_BEGIN_WRDTRANS((void *)&h->entrycount,0, sizeof(unsigned int));
	   #endif
    	   --(h->entrycount);
           #ifdef _USE_TRANSACT
    	   p_c_nvcommitword((void *)&h->entrycount);
    	   #endif
 	   return 0;

    } /*oom*/

#ifndef WORD_OBJ_TRANS
    if(e->h)
    C_BEGIN_WRDTRANS((void *)&e->h,0, sizeof(struct hashtable *));
    e->h = hash(h,k);
    if(e->h)	
    p_c_nvcommitword((void *)&e->h);

    	 
    index = indexFor(h->tablelength,e->h);

    if(e->k)
    C_BEGIN_WRDTRANS((void *)&e->k,0, sizeof(void *));	
    e->k = k;
    if(e->k)	
    p_c_nvcommitword((void *)&e->k);

    if(e->v)
    C_BEGIN_WRDTRANS((void *)&e->v,0, sizeof(void *)); 	
    e->v = v;
    if(e->v)	
    p_c_nvcommitword((void *)&e->v);

    if(e->next)
    C_BEGIN_WRDTRANS((void *)&e->next,0, sizeof(void *));
    e->next = h->table[index];
    if(e->next)	
    p_c_nvcommitword((void *)&e->next);

    if(h->table[index])  
    C_BEGIN_WRDTRANS((void *)&h->table[index],0, sizeof(struct entry *));
    h->table[index] = e;
    p_c_nvcommitword((void *)&h->table[index]);

#else // WORD_OBJ_TRANS

#ifdef _USE_TRANSACT
    C_BEGIN_OBJTRANS((void *)e,0);
#endif

    e->h = hash(h,k);
    index = indexFor(h->tablelength,e->h);
    e->k = k;
    e->v = v;
    e->next = h->table[index];

#ifdef _USE_TRANSACT
   C_BEGIN_WRDTRANS((void *)&h->table[index],0, sizeof(struct entry));
#endif
    h->table[index] = e;

#ifdef _USE_TRANSACT
    p_c_nvcommitword((void *)&h->table[index]);
    p_c_nvcommitobj((void *)e,0);
#endif

#endif //WORD_OBJ_TRANS

    return -1;
}



/*****************************************************************************/
int
hashtable_insert_1(struct hashtable *h, void *k, void *v)
{
    /* This method allows duplicate keys - but they shouldn't be used */
    unsigned int index;
    struct entry *e;

    #ifdef _USE_TRANSACT
    C_BEGIN_WRDTRANS((void *)&h->entrycount,0, sizeof(unsigned int));	
    #endif

    ++(h->entrycount);

    #ifdef _USE_TRANSACT
    p_c_nvcommitword((void *)&h->entrycount);
    #endif

    if ((h->entrycount) > h->loadlimit)
    {
        /* Ignore the return value. If expand fails, we should
         * still try cramming just this value into the existing table
         * -- we may not have memory for a larger table, but one more
         * element may be ok. Next time we insert, we'll try expanding again.*/
    	//C_BEGIN_OBJTRANS((void *)h,0);
        hashtable_expand(h);
       // p_c_nvcommitobj((void *)h,0);
    }
   char varnam[64];
   bzero(varnam, 64);
   sprintf(varnam,"%d",h->entrycount);
   varnam[64]=0;

   e = (struct entry *)p_c_nvalloc_(sizeof(struct entry), (char *)varnam, 0);
    if (NULL == e) {

   	   #ifdef _USE_TRANSACT
    	   C_BEGIN_WRDTRANS((void *)&h->entrycount,0, sizeof(unsigned int));
	   #endif
    	   --(h->entrycount);
           #ifdef _USE_TRANSACT
    	   p_c_nvcommitword((void *)&h->entrycount);
    	   #endif
 	   return 0;

    } /*oom*/

#ifdef _USE_TRANSACT
    C_BEGIN_OBJTRANS((void *)e,0);
#endif

    e->h = hash(h,k);
    index = indexFor(h->tablelength,e->h);
    e->k = k;
    e->v = v;
    e->next = h->table[index];

#ifdef _USE_TRANSACT
   C_BEGIN_WRDTRANS((void *)&h->table[index],0, sizeof(struct entry));
#endif
    h->table[index] = e;

#ifdef _USE_TRANSACT
    p_c_nvcommitword((void *)&h->table[index]);
    p_c_nvcommitobj((void *)e,0);
#endif

    return -1;
}

/*****************************************************************************/
void * /* returns value associated with key */
hashtable_search(struct hashtable *h, void *k)
{
    struct entry *e;
    unsigned int hashvalue, index;
    hashvalue = hash(h,k);
    index = indexFor(h->tablelength,hashvalue);
    e = h->table[index];
    while (NULL != e)
    {
        /* Check hash value to short circuit heavier comparison */
        if ((hashvalue == e->h) && (h->eqfn(k, e->k))) return e->v;
        e = e->next;
    }
    return NULL;
}


#ifndef WORD_OBJ_TRANS
/*****************************************************************************/
void * /* returns value associated with key */
hashtable_remove(struct hashtable *h, void *k)
{
    /* TODO: consider compacting the table when the load factor drops enough,
     *       or provide a 'compact' method. */

    struct entry *e;
    struct entry **pE;
    void *v;
    unsigned int hashvalue, index;

    hashvalue = hash(h,k);
    index = indexFor(h->tablelength,hash(h,k));
    pE = &(h->table[index]);
    e = *pE;

    while (NULL != e)
    {
        /* Check hash value to short circuit heavier comparison */
        if ((hashvalue == e->h) && (h->eqfn(k, e->k)))
        {
            *pE = e->next;
	    C_BEGIN_WRDTRANS((void *)&h->entrycount,0, sizeof(unsigned int));
            h->entrycount--;
	    p_c_nvcommitword((void *)&(h->entrycount));

            v = e->v;
           
            C_BEGIN_WRDTRANS((void *)&e->k,0, sizeof(void *));
	    p_c_free_(e->k);	
	    p_c_nvcommitword((void *)&(e->k));	

	    C_BEGIN_WRDTRANS((void *)&e,0, sizeof(void *));
	    p_c_free_(e);
	    p_c_nvcommitword((void *)&e);	

	    return v;
        }
        pE = &(e->next);
        e = e->next;
    }

    return NULL;
}

#else

/*****************************************************************************/
void * /* returns value associated with key */
hashtable_remove(struct hashtable *h, void *k)
{
    /* TODO: consider compacting the table when the load factor drops enough,
     *       or provide a 'compact' method. */

    struct entry *e;
    struct entry **pE;
    void *v;
    unsigned int hashvalue, index;

    hashvalue = hash(h,k);
    index = indexFor(h->tablelength,hash(h,k));
    pE = &(h->table[index]);
    e = *pE;


    while (NULL != e)
    {
        /* Check hash value to short circuit heavier comparison */
        if ((hashvalue == e->h) && (h->eqfn(k, e->k)))
        {
	    C_BEGIN_OBJTRANS((void *)e,0);
   	    C_BEGIN_WRDTRANS((void *)&h->entrycount,0, sizeof(unsigned int));
        *pE = e->next;
        h->entrycount--;
	    p_c_nvcommitword((void *)&(h->entrycount));
        v = e->v;
	    p_c_free_(e->k);	
	    p_c_nvcommitobj((void *)e,0);
	    p_c_free_(e);

	    return v;
        }
        pE = &(e->next);
        e = e->next;
    }

    return NULL;
}
#endif

/*****************************************************************************/
/* destroy */
void
hashtable_destroy(struct hashtable *h, int free_values)
{
    unsigned int i;
    struct entry *e, *f;
    struct entry **table = h->table;
    if (free_values)
    {
        for (i = 0; i < h->tablelength; i++)
        {
            e = table[i];
            while (NULL != e)
            { 
		f = e; e = e->next; 
	  	/*freekey(f->k); 
		free(f->v); 
		free(f); */

	  	p_c_free_(f->k); 
		p_c_free_(f->v); 
		p_c_free_(f); 

	   }
        }
    }
    else
    {
        for (i = 0; i < h->tablelength; i++)
        {
            e = table[i];
            while (NULL != e)
            { 
	      f = e; e = e->next; 
	      //freekey(f->k); 
	      //free(f);
	      p_c_free_(f->k);
	      p_c_free_(f);		
	   }
        }
    }
    //free(h->table);
    //free(h);
    p_c_free_(h->table); 
    p_c_free_(h); 
}

/*
 * Copyright (c) 2002, Christopher Clark
 * All rights reserved.
 * 
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 
 * * Redistributions of source code must retain the above copyright
 * notice, this list of conditions and the following disclaimer.
 * 
 * * Redistributions in binary form must reproduce the above copyright
 * notice, this list of conditions and the following disclaimer in the
 * documentation and/or other materials provided with the distribution.
 * 
 * * Neither the name of the original author; nor the names of any contributors
 * may be used to endorse or promote products derived from this software
 * without specific prior written permission.
 * 
 * 
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 * A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER
 * OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 * LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
