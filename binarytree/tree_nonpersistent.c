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
 * tree.c -- implement a binary tree on Persistent Memory
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <stdarg.h>

#include "util/util.h"
#include "libpmem/pmem.h"
#include "libpmemalloc/pmemalloc.h"
#include "tree.h"
#include <libpmemlog.h>

/*
 * the Persistent Memory pool, as returned by pmemalloc_init()
 */
static void *Pmp;
static void *g_root;
/*
 * the nodes of this tree contain a count and a string
 */
struct tnode {
	struct tnode *left_;
	struct tnode *right_;
	unsigned count;
	char s[];
};

/*
 * we use the static area to persistently store to root of the tree
 */
struct static_info {
	struct tnode *root_;
};

/*
 * tree_init -- initialize the binary tree
 *
 * Inputs:
 * 	path -- Persistent Memory file where we will store the tree
 *
 * 	size -- size of the PM file if it doesn't exist already
 */
void
tree_init(const char *path, size_t size)
{
	//DEBUG("path \"%s\" size %lu", path, size);

	//if ((Pmp = pmemalloc_init(path, size)) == NULL)
	//	FATALSYS("pmemalloc_init on %s", path);
	if ((Pmp = malloc(size)) == NULL)
		FATALSYS("pmemalloc_init on %s", path);
}	

/*
 * tree_insert_subtree -- insert a string or bump count if found
 *
 * This is the internal, recursive function that does all the work.
 */
static void
tree_insert_subtree(struct tnode **rootp_, const char *s)
{
	int diff;

	//DEBUG("*rootp_ = %lx", (uintptr_t)*rootp_);
	if (*rootp_ == NULL) {
		/* insert a new node here */
		struct tnode *tnp_;
		size_t slen = strlen(s) + 1;	/* include '\0' */

		if ((tnp_ = malloc(sizeof(*tnp_) +slen)) == NULL)
			FATALSYS("pmem_alloc");

		if(g_root == NULL)
		   g_root = tnp_;

		tnp_->left_ =
		tnp_->right_ = NULL;
		tnp_->count = 1;
		strcpy(tnp_->s, s);
		//DEBUG("new node inserted, count=1");
	} else if ((diff = strcmp(s, (*rootp_)->s)) == 0) {
		/* already in tree, increase count */
		(*rootp_)->count++;
		//DEBUG("new count=%u", PMEM(Pmp, *rootp_)->count);
	} else if (diff < 0) {
		/* recurse left */
		tree_insert_subtree(&(*rootp_)->left_, s);
	} else {
		/* recurse right */
		tree_insert_subtree(&(*rootp_)->right_, s);
	}
}


/*
 * tree_insert -- insert a string or bump count if found
 */
void
tree_insert(const char *s)
{
	struct static_info *sp = (struct static_info *)Pmp;
	tree_insert_subtree(&sp->root_, s);
}

/*
 * tree_walk_subtree -- walk the tree, printing the contents
 *
 * This is the internal, recursive function that does all the work.
 */
static void
tree_walk_subtree(struct tnode *root_)
{
	if (root_) {
		/* recurse left */
		tree_walk_subtree((root_)->left_);

		/* recurse right */
		tree_walk_subtree((root_)->right_);
	}
}

/*
 * tree_walk -- walk the tree, printing the contents
 */
void
tree_walk(void)
{
	struct static_info *sp = (struct static_info *)Pmp;

	tree_walk_subtree(sp->root_);
}

/*
 * tree_free_subtree -- free the tree
 *
 * This is the internal, recursive function that does all the work.
 */
static void
tree_free_subtree(struct tnode **rootp_)
{
	//DEBUG("*rootp_ = %lx", (uintptr_t)*rootp_);

	if (*rootp_ != NULL) {
		/* recurse left */
		tree_free_subtree(&(*rootp_)->left_);

		/* recurse right */
		tree_free_subtree(&(*rootp_)->right_);

		free((void *)*rootp_);
		printf("freeing \n");
	}
}

/*
 * tree_free -- free the tree
 */
void
tree_free(void)
{
	struct static_info *sp = (struct static_info *)Pmp;
	tree_free_subtree(&sp->root_);
}
