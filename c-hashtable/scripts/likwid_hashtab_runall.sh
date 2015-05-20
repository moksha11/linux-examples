#!/bin/sh
HOMEDIR=/home/sudarsun/libs/intelmachine/libs/linux-examples
DATADIR=/mnt/pmfs
NVMDIR=/home/sudarsun/libs/intelmachine/nvmalloc/scripts



for i in 100000 500000 #1000000 2000000 

do

sudo rm -rf /mnt/pmfs/*

rm -rf *.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync

scripts/likwid_hashtab_fullpersist_disablog.sh $i >> SCALINGEXP/hashtabl_FLUSH_$i.out
scripts/likwid_hashtab_fullpersist_disablog.sh $i >> SCALINGEXP/hashtabl_FLUSH_$i.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync



scripts/likwid_hashtab_fullpersist_enablelog.sh $i >> SCALINGEXP/hashtabl_ACID_$i.out 
scripts/likwid_hashtab_fullpersist_enablelog.sh $i >> SCALINGEXP/hashtabl_ACID_$i.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync



scripts/likwid_hashtab_nodatapersist_disablog.sh $i >> SCALINGEXP/hashtabl_hashtab_nodatapersist_disablog_$i.out
scripts/likwid_hashtab_nodatapersist_disablog.sh $i >> SCALINGEXP/hashtabl_hashtab_nodatapersist_disablog_$i.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync


scripts/likwid_hashtab_nodatapersist_enablelog.sh $i >> SCALINGEXP/EnergyOracle_$i.out
scripts/likwid_hashtab_nodatapersist_enablelog.sh $i >> SCALINGEXP/EnergyOracle_$i.out


sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync


scripts/likwid_hashtab_epoch_nodatapersist_enablelog.sh $i >> SCALINGEXP/hashtabl_ACI-RD_$i.out
scripts/likwid_hashtab_epoch_nodatapersist_enablelog.sh $i >> SCALINGEXP/hashtabl_ACI-RD_$i.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync

scripts/likwid_hashtab_baseline.sh $i >> SCALINGEXP/hashtabl_BASELINE_all_$i.out
scripts/likwid_hashtab_baseline.sh $i >> SCALINGEXP/hashtabl_BASELINE_all_$i.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync

done



