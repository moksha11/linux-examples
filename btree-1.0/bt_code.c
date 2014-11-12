/*-
 * Copyright 1997-1999, 2001 John-Mark Gurney.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
 * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
 * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
 * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 *
 *	$Id: bt_code.c,v 1.10.2.2 2001/03/28 06:18:30 jmg Exp $
 *
 * Pseudo code used to implement this data structure was obtained from:
 * Introduction to Algorithms / Thomas H. Cormen, Charles E. Leiserson,
 *     Ronald L. Rivest.
 *
 * The delete key routine was not provided in pseudo code and is my own
 * creation following their cases to maintain balance.
 *
 */

#include <btree.h>
#include <btreepriv.h>

#include <stdlib.h>
#include <string.h>
#include <assert.h>

#include "util/util.h"
#include "libpmem/pmem.h"
#include "libpmemalloc/pmemalloc.h"
#include <libpmemlog.h>


//#define _USE_NVMALLOC
#define INTEL_PMEM

#ifdef INTEL_PMEM

static void *Pmp;
void **root;
void
pmem_init(const char *path, size_t size)
{
	//DEBUG("path \"%s\" size %lu", path, size);
#ifdef INTEL_PMEM
	if ((Pmp = pmemalloc_init(path, size)) == NULL)
		printf("pmemalloc_init on %s\n", path);

	root = pmemalloc_static_area(Pmp);
#endif
}

inline void *get_PMEM(void *ptr) {
	printf("PMEM[ptr] %u \n",PMEM(Pmp, ptr));
}

inline void *pmemalloc_reserv_virtual(size_t size, void **tmp){
#ifdef INTEL_PMEM
	void *ptr = pmemalloc_reserve(Pmp, size);
	*tmp = ptr;
	return PMEM(Pmp, ptr);
#else
	return malloc(size);
#endif
}

inline void *pmemalloc_activate_local(void *ptr){
#ifdef INTEL_PMEM
	pmemalloc_onactive(Pmp, ptr,root, ptr);
	pmemalloc_activate(Pmp, ptr);
#else

#endif
}

void pmemalloc_free_local(void *ptr){
	//printf("freeing \n");
	pmemalloc_free(Pmp, ptr);
}
#endif

inline void pmem_persist_local(void *src, size_t len, int flags){
	pmem_persist(src, len,_DATAPERSIST);
}


inline void * persist_memmove ( void * destination, const void * source, size_t num )
{

  void *ptr = memmove (destination, source, num );

#ifdef INTEL_PMEM

#ifdef _NODATAPERSIST
		pmem_persist_local(destination, num,_DATAPERSIST);
#else
		pmem_persist_local(destination, num,_DATAPERSIST);
#endif
#endif
  return ptr;
}

inline FREE(void *ptr){

#ifdef INTEL_PMEM
	//printf("deleting \n");
	pmemalloc_free_local(ptr);
#else
	//printf("deleting \n");
	free(ptr);
#endif

}


#ifdef NO_INLINE
#define inline
#endif

static inline int findkindex(struct btree *btr, struct btreenode *x,
			     bt_data_t k, int *r);
static struct btree *allocbtree(void);
#ifdef INTEL_PMEM
static struct btreenode *allocbtreenode(int n, void **ptr);
#else
static struct btreenode *allocbtreenode(int n);
#endif
static void btreesplitchild(struct btree *btr, struct btreenode *x, int i,
			    struct btreenode *y);
static void btreeinsertnonfull(struct btree *btr, struct btreenode *x,
			       bt_data_t k);
static bt_data_t nodedeletekey(struct btree *btr, struct btreenode *x,
			       bt_data_t k, int s);
static struct btreenode *freebtreenode(struct btreenode *);
static bt_data_t findmaxnode(struct btree *btr, struct btreenode *x);
static bt_data_t findminnode(struct btree *btr, struct btreenode *x);
static bt_data_t findnodekey(struct btree *, struct btreenode *x, bt_data_t k);

static int log2(unsigned int, int) __attribute__ ((const));

#if 0
/* we would use this, but even unoptimized C code is faster than bsr! */
static inline int
log2(unsigned int a, int nbits)
{
	int r;
	asm volatile ("bsrl %1,%0" : "=r" (r) : "rm" (a) : "cc");

	return r;
}
#else
/*
 * This is the real log2 function.  It is only called when we don't have
 * a value in the table.
 */
static inline int
real_log2(unsigned int a, int nbits)
{
	int i;
	int b;

	/* divide in half rounding up */
	b = (nbits + 1) / 2;
	i = 0;
	while (b) {
		i = (i << 1);
		if (a >= (1 << b)) {
			/* select the top half and mark this bit */
			a /= (1 << b);
			i = i | 1;
		} else
			/* select the bottom half and don't set the bit */
			a &= (1 << b) - 1;
		b /= 2;
	}
	return i;
}
#endif

/*
 * Implement a lookup table for the log values.  This will only allocate
 * memory that we need.  This is much faster than calling the log2 routine
 * every time.  Doing 1 million insert, searches, and deletes will generate
 * ~58 million calls to log2.  Using a lookup table IS NECESSARY!
 */
static inline int
log2(unsigned int a, int nbits)
{
	static signed char *table;
	static int alloced;
	int i;

	if (a > alloced) {
		table = realloc(table, (a + 1) * sizeof *table);
		for (i = alloced; i < a + 1; i++)
			table[i] = -1;
		alloced = a + 1;
	}

	if (table[a] == -1)
		table[a] = real_log2(a, nbits);

	return table[a];
}

#ifndef SAFE_BTREE
/*
 * Finally get this code working properly.  It now works great.  I don't
 * have any problems with this.  Leave the old code in incase I need it
 * again.
 */
static inline int
findkindex(struct btree *btr, struct btreenode *x, bt_data_t k, int *r)
{
	int a, b, i;
	int tr;
	int *rr;

	if (r == NULL)
		rr = &tr;
	else
		rr = r;

	if (x->n == 0)
		return -1;

	a = x->n - 1;
	i = 0;
	while (a > 0) {
		b = log2(a, btr->nbits);
		if ((*rr = btr->cmp(k, KEYS(btr, x)[(1 << b) + i])) < 0)
			a = (1 << b) - 1;
		else {
			a -= (1 << b);
			i |= (1 << b);
		}
	}
	if ((*rr = btr->cmp(k, KEYS(btr, x)[i])) < 0)
		i--;
	return i;
}
#else
static inline int
findkindex(struct btree *btr, struct btreenode *x, bt_data_t k, int *r)
{
	int tr;
	int *rr;
	int n;

	if (r != NULL)
		rr = r;
	else
		rr = &tr;

	/* hmmm, doesn't really matter which way we go through the node */
	n = x->n - 1;

	while (n >= 0 && (*rr = btr->cmp(k, KEYS(btr, x)[n])) < 0)
		n--;

	return n;
}
#endif




#ifdef INTEL_PMEM
static struct btree *
allocbtree_intel(void **tmp)
{
	struct btree *btr;
	if ((btr = pmemalloc_reserv_virtual((sizeof *btr), tmp)) != NULL) {
		btr->root = NULL;
		btr->cmp = NULL;
		btr->keyoff = 0;
		btr->nodeptroff = 0;
		btr->nkeys = 0;
		btr->t = 0;
		btr->nbits = 0;
		btr->textra = 0;
#ifdef STATS
		btr->numkeys = 0;
		btr->numnodes = 0;
#endif
	}else{
		assert(0);
	}
	return btr;
}


#else

static struct btree *
allocbtree(void)
{
	struct btree *btr;

#ifdef _USE_NVMALLOC
	fprintf(stdout,"using p_c_nvalloc_ \n");
        if ((btr = p_c_nvalloc_(sizeof *btr, (char *)"btree_root", 0)) != NULL) {
#else
//	fprintf(stdout,"using malloc_ \n");
	if ((btr = malloc(sizeof *btr)) != NULL) {
#endif
		btr->root = NULL;
		btr->cmp = NULL;
		btr->keyoff = 0;
		btr->nodeptroff = 0;
		btr->nkeys = 0;
		btr->t = 0;
		btr->nbits = 0;
		btr->textra = 0;
#ifdef STATS
		//fprintf(stdout,"success \n");
		btr->numkeys = 0;
		btr->numnodes = 0;
#endif
	}else{
		assert(0);
	}


	return btr;
}
#endif



#ifdef INTEL_PMEM
static struct btreenode *
allocbtreenode(int n, void **tmp)
{
	struct btreenode *btn;

	if ((btn = pmemalloc_reserv_virtual(sizeof *btn + n, tmp)) != NULL) {
		bzero(btn, sizeof *btn + n);
		btn->leaf = 1;
	}

	return btn;
}
#else
static struct btreenode *
allocbtreenode(int n)
{
	struct btreenode *btn;

	char varnam[64];
	bzero(varnam, 64);
	sprintf(varnam,"%d",n);
	varnam[64]=0;

#ifdef _USE_NVMALLOC
        if ((btn = p_c_nvalloc_(sizeof *btn + n, (char *)varnam, 0)) != NULL) {
#else
	if ((btn = malloc(sizeof *btn + n)) != NULL) {
#endif
		bzero(btn, sizeof *btn + n);
		btn->leaf = 1;
	}

	return btn;
}
#endif


struct btree *
bt_create(bt_cmp_t cmp, int size)
{
	struct btree *btr;
	int n, t;
	int textra;

#ifdef INTEL_PMEM
	void *tmp, *tmp1;
	pmem_init("/mnt/pmfs/testfile", 1024*1024*512);
#endif

	textra = 0;
	btr = NULL;
	size -= sizeof *btr->root;
	size -= sizeof btr->root;

	/*
	 * calculate maximum t that will fix in size, and that t >= 2
	 */
	if ((n = size / (sizeof btr->root + sizeof(bt_data_t))) > 0 &&
	    ( t = (n + 1) / 2) >= 2) {
		n = 2 * t - 1;
		textra += sizeof btr->root + n * (sizeof btr->root +
		    sizeof(bt_data_t));

#ifdef INTEL_PMEM
		if ((btr = allocbtree_intel(&tmp)) != NULL)
			btr->p_ptr = tmp;
#else
		if ((btr = allocbtree()) != NULL)
#endif
		{
			btr->cmp = cmp;
			btr->keyoff = sizeof *btr->root;
			btr->nodeptroff = btr->keyoff + n * sizeof(bt_data_t);
			btr->nkeys = n;
			btr->t = t;
			btr->nbits = log2(btr->nkeys, sizeof(int) * 8) + 1;
			/* make nbits a power of 2 */
			btr->nbits = 1 <<
			    (log2(btr->nbits, sizeof(int) * 8) + 1);
			btr->textra = textra;
#ifdef STATS
			btr->numnodes++;
#endif

#ifdef INTEL_PMEM
		if ((btr->root = allocbtreenode(textra, &tmp1)) == NULL) {
				btr = FREE(btr->p_ptr);
		}
		else {
			btr->root->p_ptr = tmp1;
		}
#else
		if ((btr->root = allocbtreenode(textra)) == NULL)
				btr = FREE(btr);
#endif
		}
	}
#ifdef INTEL_PMEM
	pmemalloc_activate_local(tmp1);
	pmemalloc_activate_local(tmp);
#endif

	return btr;
}

static void
btreesplitchild(struct btree *btr, struct btreenode *x, int i,
    struct btreenode *y)
{
	struct btreenode *z;
	int j;

#ifdef STATS
	btr->numnodes++;
#endif

#ifdef INTEL_PMEM
	void *tmp;
	if ((z = allocbtreenode(btr->textra,&tmp)) == NULL){
		exit(1);
	}
	else {
		z->p_ptr= tmp;
	}
#else
	if ((z = allocbtreenode(btr->textra)) == NULL)
		exit(1);
#endif

	/* duplicate leaf setting, and store number of nodes */
	z->leaf = y->leaf;
	z->n = btr->t - 1;

	/* copy the last half of y into z */
	for (j = 0; j < btr->t - 1; j++)
		KEYS(btr, z)[j] = KEYS(btr, y)[j + btr->t];

	/* if it's an internal node, copy the ptr's too */
	if (!y->leaf)
		for (j = 0; j < btr->t; j++)
			NODES(btr, z)[j] = NODES(btr, y)[j + btr->t];

	/* store resulting number of nodes in old part */
	y->n = btr->t - 1;

	/* move node ptrs in parent node down one, and store new node */
	for (j = x->n; j > i; j--)
		NODES(btr, x)[j + 1] = NODES(btr, x)[j];
	NODES(btr, x)[i + 1] = z;

	/* adjust the keys from previous move, and store new key */
	for (j = x->n - 1; j >= i; j--)
		KEYS(btr, x)[j + 1] = KEYS(btr, x)[j];
	KEYS(btr, x)[i] = KEYS(btr, y)[btr->t - 1];
	x->n++;
#ifdef INTEL_PMEM
	pmem_persist_local(x, sizeof(struct btreenode),_DATAPERSIST);
	pmemalloc_activate_local(tmp);
#endif

}

void
bt_insert(struct btree *btr, bt_data_t k)
{
	struct btreenode *r, *s;

#ifdef STATS
       assert(btr);
	btr->numkeys++;
#endif

	r = btr->root;
	if (r->n == 2 * btr->t - 1) {
		/*
		 * this is the ONLY place that the tree can grown in
		 * height
		 */
#ifdef STATS
		btr->numnodes++;
#endif

#ifdef INTEL_PMEM
		void *tmp;
		if ((s = allocbtreenode(btr->textra, &tmp)) == NULL)
			exit(1);
		s->p_ptr = tmp;
#else
		if ((s = allocbtreenode(btr->textra)) == NULL)
			exit(1);
#endif

		btr->root = s;
		s->leaf = 0;
		s->n = 0;
		NODES(btr, s)[0] = r;
		btreesplitchild(btr, s, 0, r);
		r = s;
#ifdef INTEL_PMEM
	pmemalloc_activate_local(tmp);
#endif

	}
	/* finally insert the new node */
	btreeinsertnonfull(btr, r, k);
}

static void
btreeinsertnonfull(struct btree *btr, struct btreenode *x, bt_data_t k)
{
	int i;

	i = x->n - 1;
	if (x->leaf) {
		/* we are a leaf, just add it in */
		i = findkindex(btr, x, k, NULL);
		if (i != x->n - 1)
			persist_memmove(KEYS(btr, x) + i + 2, KEYS(btr, x) + i + 1,
			    (x->n - i - 1) * sizeof k);
		KEYS(btr, x)[i + 1] = k;
		x->n++;
		pmem_persist_local(x, sizeof(struct btreenode),_DATAPERSIST);

	} else {
		i = findkindex(btr, x, k, NULL) + 1;

		/* make sure that the next node isn't full */
		if (NODES(btr, x)[i]->n == 2 * btr->t - 1) {
			btreesplitchild(btr, x, i, NODES(btr, x)[i]);
			if (btr->cmp(k, KEYS(btr, x)[i]) > 0)
				i++;
		}
		btreeinsertnonfull(btr, NODES(btr, x)[i], k);
	}
}

bt_data_t
bt_delete(struct btree *btr, bt_data_t k)
{
	struct btreenode *x;
	bt_data_t r;

	r = nodedeletekey(btr, btr->root, k, 0);

	/*
	 * remove an empty, non-leaf node from root, this is the ONLY
	 * place that a tree can decrease in height
	 */
	if (btr->root->n == 0 && btr->root->leaf == 0) {
#ifdef STATS
		btr->numnodes--;
#endif
		x = btr->root;
		btr->root = NODES(btr, x)[0];
#ifdef INTEL_PMEM
		//if(x->p_ptr)
		FREE(x->p_ptr);
#else
		FREE(x);
#endif
	}
	return r;
}

/*
 * remove an existing key from the tree, if the key doesn't exist in it,
 * unexpected results may happen.
 *
 * the s parameter is kinda special, for normal operation you need to pass
 * it as 0, if you want to delete the max node, pass it as 1, or if you
 * want to delete the min node, pass it as 2.
 */
static bt_data_t
nodedeletekey(struct btree *btr, struct btreenode *x, bt_data_t k, int s)
{
	int i;
	int r;
	struct btreenode *xp, *y, *z;
	bt_data_t kp;
	int yn, zn;

	if (x == NULL)
		return 0;

	if (s) {
		if (!x->leaf)
			switch (s) {
			case 1:
				r = 1;
				break;
			case 2:
				r = -1;
				break;
			}
		else
			r = 0;
		switch (s) {
		case 1:
			i = x->n - 1;
			break;
		case 2:
			i = -1;
			break;
		default:
			i = 42;
			break;
		}
	} else
		i = findkindex(btr, x, k, &r);

	/*
	 * Case 1
	 * If the key k is in node x and x is a leaf, delete the key k from x.
	 */
	if (x->leaf) {
		if (s == 2)
			i++;
		kp = KEYS(btr, x)[i];
		persist_memmove(KEYS(btr, x) + i, KEYS(btr, x) + i + 1,
		    (x->n - i - 1) * sizeof k);
		x->n--;
#ifdef INTEL_PMEM
		pmem_persist_local(x, sizeof(struct btreenode),_DATAPERSIST);
#endif
		return kp;
	}

	if (r == 0) {
		/*
		 * Case 2
		 * if the key k is in the node x, and x is an internal node
		 */
		if ((yn = NODES(btr, x)[i]->n) >= btr->t) {
			/*
			 * Case 2a
			 * if the child y that precedes k in node x has at
			 * least t keys, then find the predecessor k' of
			 * k in the subtree rooted at y.  Recursively delete
			 * k', and replace k by k' in x.
			 *
			 * Currently the deletion isn't done in a signle
			 * downward pass was that would require special
			 * unwrapping of the delete function.
			 */
			xp = NODES(btr, x)[i];
			kp = KEYS(btr, x)[i];
			KEYS(btr, x)[i] = nodedeletekey(btr, xp, NULL, 1);
#ifdef INTEL_PMEM
		pmem_persist_local(x, sizeof(struct btreenode),_DATAPERSIST);
#endif
			return kp;
		}
		if ((zn = NODES(btr, x)[i + 1]->n) >= btr->t) {
			/*
			 * Case 2b
			 * if the child z that follows k in node x has at
			 * least t keys, then find the successor k' of
			 * k in the subtree rooted at z.  Recursively delete
			 * k', and replace k by k' in x.
			 *
			 * See above for comment on single downward pass.
			 */
			xp = NODES(btr, x)[i + 1];
			kp = KEYS(btr, x)[i];
			KEYS(btr, x)[i] = nodedeletekey(btr, xp, NULL, 2);
#ifdef INTEL_PMEM
		pmem_persist_local(x, sizeof(struct btreenode),_DATAPERSIST);
#endif
			return kp;
		}
		if (yn == btr->t - 1 && zn == btr->t - 1) {
			/*
			 * Case 2c
			 * if both y and z have only t - 1 keys, merge k
			 * and all of z into y, so that x loses both k and
			 * the pointer to z, and y now contains 2t - 1
			 * keys.  Recersively delete k from y.
			 */
			y = NODES(btr, x)[i];
			z = NODES(btr, x)[i + 1];
			KEYS(btr, y)[y->n++] = k;
			persist_memmove(KEYS(btr, y) + y->n, KEYS(btr, z),
			    z->n * sizeof k);
			persist_memmove(NODES(btr, y) + y->n, NODES(btr, z),
			    (z->n + 1) * sizeof y);
			y->n += z->n;

#ifdef INTEL_PMEM
		pmem_persist_local(y, sizeof(struct btreenode),_DATAPERSIST);
#endif

			persist_memmove(KEYS(btr, x) + i, KEYS(btr, x) + i + 1,
			    (x->n - i - 1) * sizeof k);
			persist_memmove(NODES(btr, x) + i + 1, NODES(btr, x) + i + 2,
			    (x->n - i - 1) * sizeof k);
			x->n--;
#ifdef INTEL_PMEM
		pmem_persist_local(x, sizeof(struct btreenode),_DATAPERSIST);
#endif
			z = freebtreenode(z);
			return nodedeletekey(btr, y, k, s);
		}
	}
	/*
	 * Case 3
	 * if k is not present in internal node x, determine the root x' of
	 * the appropriate subtree that must contain k, if k is in the tree
	 * at all.  If x' has only t - 1 keys, execute step 3a or 3b as
	 * necessary to guarantee that we descend to a node containing at
	 * least t keys.  Finish by recursing on the appropriate child of x.
	 */
	i++;
	/* !x->leaf */
	if ((xp = NODES(btr, x)[i])->n == btr->t - 1) {
		/*
		 * Case 3a
		 * If x' has only t - 1 keys but has a sibling with at
		 * least t keys, give x' an extra key by moving a key
		 * from x down into x', moving a key from x''s immediate
		 * left or right sibling up into x, and moving the
		 * appropriate child from the sibling into x'.
		 */
		if (i > 0 && (y = NODES(btr, x)[i - 1])->n >= btr->t) {
			/* left sibling has t keys */
			persist_memmove(KEYS(btr, xp) + 1, KEYS(btr, xp),
			    xp->n * sizeof k);
			persist_memmove(NODES(btr, xp) + 1, NODES(btr, xp),
			    (xp->n + 1) * sizeof x);
			KEYS(btr, xp)[0] = KEYS(btr, x)[i - 1];
			KEYS(btr, x)[i - 1] = KEYS(btr, y)[y->n - 1];
			NODES(btr, xp)[0] = NODES(btr, y)[y->n];
			y->n--;
			xp->n++;
#ifdef INTEL_PMEM
		pmem_persist_local(y, sizeof(struct btreenode),_DATAPERSIST);
		pmem_persist_local(x, sizeof(struct btreenode),_DATAPERSIST);
#endif


		} else if (i < x->n &&
		    (y = NODES(btr, x)[i + 1])->n >= btr->t) {
			/* right sibling has t keys */
			KEYS(btr, xp)[xp->n++] = KEYS(btr, x)[i];
			KEYS(btr, x)[i] = KEYS(btr, y)[0];
			NODES(btr, xp)[xp->n] = NODES(btr, y)[0];
			y->n--;
			persist_memmove(KEYS(btr, y), KEYS(btr, y) + 1,
			    y->n * sizeof k);
			persist_memmove(NODES(btr, y), NODES(btr, y) + 1,
			    (y->n + 1) * sizeof x);
#ifdef INTEL_PMEM
		pmem_persist_local(y, sizeof(struct btreenode),_DATAPERSIST);
		pmem_persist_local(x, sizeof(struct btreenode),_DATAPERSIST);
#endif
		}
		/*
		 * Case 3b
		 * If x' and all of x''s siblings have t - 1 keys, merge
		 * x' with one sibling, which involves moving a key from x
		 * down into the new merged node to become the median key
		 * for that node.
		 */
		  else if (i > 0 &&
		    (y = NODES(btr, x)[i - 1])->n == btr->t - 1) {
			/* merge i with left sibling */
			KEYS(btr, y)[y->n++] = KEYS(btr, x)[i - 1];
			persist_memmove(KEYS(btr, y) + y->n, KEYS(btr, xp),
			    xp->n * sizeof k);
			persist_memmove(NODES(btr, y) + y->n, NODES(btr, xp),
			    (xp->n + 1) * sizeof x);
			y->n += xp->n;
			persist_memmove(KEYS(btr, x) + i - 1, KEYS(btr, x) + i,
			    (x->n - i) * sizeof k);
			persist_memmove(NODES(btr, x) + i, NODES(btr, x) + i + 1,
			    (x->n - i) * sizeof x);
			x->n--;

#ifdef INTEL_PMEM
			pmem_persist_local(y, sizeof(struct btreenode),_DATAPERSIST);
			pmem_persist_local(x, sizeof(struct btreenode),_DATAPERSIST);
			//if(xp->p_ptr)
				FREE(xp->p_ptr);
#else
				FREE(xp);
#endif
			xp = y;
		} else if (i < x->n && (y = NODES(btr, x)[i + 1])->n ==
		    btr->t - 1) {
			/* merge i with right sibling */
			KEYS(btr, xp)[xp->n++] = KEYS(btr, x)[i];
			persist_memmove(KEYS(btr, xp) + xp->n, KEYS(btr, y),
			    y->n * sizeof k);
			persist_memmove(NODES(btr, xp) + xp->n, NODES(btr, y),
			    (y->n + 1) * sizeof x);
			xp->n += y->n;
			persist_memmove(KEYS(btr, x) + i, KEYS(btr, x) + i + 1,
			    (x->n - i - 1) * sizeof k);
			persist_memmove(NODES(btr, x) + i + 1, NODES(btr, x) + i + 2,
			    (x->n - i - 1) * sizeof x);
			x->n--;

#ifdef INTEL_PMEM
			pmem_persist_local(y, sizeof(struct btreenode),_DATAPERSIST);
			pmem_persist_local(x, sizeof(struct btreenode),_DATAPERSIST);

			//if(y->p_ptr)
				FREE(y->p_ptr);
#else
				FREE(y);
#endif

		}
	}
	return nodedeletekey(btr, xp, k, s);
}

static struct btreenode *
freebtreenode(struct btreenode *x)
{
#ifdef INTEL_PMEM
	//if(x->p_ptr)
		return FREE(x->p_ptr);
#else
		return FREE(x);
#endif
}

bt_data_t
bt_max(struct btree *btr)
{
	return findmaxnode(btr, btr->root);
}

bt_data_t
bt_min(struct btree *btr)
{
	return findminnode(btr, btr->root);
}

static bt_data_t
findmaxnode(struct btree *btr, struct btreenode *x)
{
	if (x->leaf)
		return KEYS(btr, x)[x->n - 1];
	else
		return findmaxnode(btr, NODES(btr, x)[x->n]);
}

static bt_data_t
findminnode(struct btree *btr, struct btreenode *x)
{
	if (x->leaf)
		return KEYS(btr, x)[0];
	else
		return findminnode(btr, NODES(btr, x)[0]);
}

bt_data_t
bt_find(struct btree *btr, bt_data_t k)
{
	return findnodekey(btr, btr->root, k);
}

static bt_data_t
findnodekey(struct btree *btr, struct btreenode *x, bt_data_t k)
{
	int i;
	int r;

	while (x != NULL) {
		/*(for (i = 0; i < x->n && (r = btr->cmp(k, KEYS(btr, x)[i])) > 0;
		    i++);*/

		i = findkindex(btr, x, k, &r);

		if (i >= 0 && r == 0)
			return KEYS(btr, x)[i];
		if (x->leaf)
			return NULL;
		x = NODES(btr, x)[i + 1];
	}
	return NULL;
}
