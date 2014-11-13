#!/bin/sh
HOMEDIR=/home/sudarsun/libs/linux-examples
DATADIR=/mnt/pmfs
NVMDIR=/home/sudarsun/nvmalloc/scripts

sudo rm -rf /mnt/pmfs/*

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync

scripts/likwid_hashtab_fullpersist_disablog.sh >> binarytree_fullpersist_disablog_HWCNTS_all.out
scripts/likwid_hashtab_fullpersist_disablog.sh >> binarytree_fullpersist_disablog_HWCNTS_all.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync



scripts/likwid_hashtab_fullpersist_enablelog.sh >> binarytree_fullpersist_enablelog_HWCNTS_all.out 
scripts/likwid_hashtab_fullpersist_enablelog.sh >> binarytree_fullpersist_enablelog_HWCNTS_all.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync



scripts/likwid_hashtab_nodatapersist_disablog.sh >> binarytree_nodatapersist_disablog_HWCNTS_all.out
scripts/likwid_hashtab_nodatapersist_disablog.sh >> binarytree_nodatapersist_disablog_HWCNTS_all.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync


scripts/likwid_hashtab_nodatapersist_enablelog.sh >> binarytree_nodatapersist_enablelog_HWCNTS_all.out
scripts/likwid_hashtab_nodatapersist_enablelog.sh >> binarytree_nodatapersist_enablelog_HWCNTS_all.out


