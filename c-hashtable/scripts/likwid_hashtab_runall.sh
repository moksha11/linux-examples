#!/bin/sh
HOMEDIR=/home/sudarsun/apps/intel_pmem_libs/linux-examples
DATADIR=/mnt/pmfs
NVMDIR=/home/sudarsun/nvmalloc/scripts

rm -rf /mnt/pmfs/*

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync

scripts/likwid_hashtab_fullpersist_disablog.sh >> hashtab_fullpersist_disablog_all.out
scripts/likwid_hashtab_fullpersist_disablog.sh >> hashtab_fullpersist_disablog_all.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync



scripts/likwid_hashtab_fullpersist_enablelog.sh >> hashtab_fullpersist_enablelog_all.out 
scripts/likwid_hashtab_fullpersist_enablelog.sh >> hashtab_fullpersist_enablelog_all.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync



scripts/likwid_hashtab_nodatapersist_disablog.sh >> hashtab_nodatapersist_disablog_all.out
scripts/likwid_hashtab_nodatapersist_disablog.sh >> hashtab_nodatapersist_disablog_all.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync


scripts/likwid_hashtab_nodatapersist_enablelog.sh >> hashtab_nodatapersist_enablelog_all.out
scripts/likwid_hashtab_nodatapersist_enablelog.sh >> hashtab_nodatapersist_enablelog_all.out


