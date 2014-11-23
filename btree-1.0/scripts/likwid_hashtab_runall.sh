#!/bin/sh
HOMEDIR=/home/sudarsun/libs/linux-examples
DATADIR=/mnt/pmfs
NVMDIR=/home/sudarsun/nvmalloc/scripts

sudo rm -rf /mnt/pmfs/*

rm *.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync


for i in 100000 500000 1000000 2000000 # 500000 2000000 3000000

do


scripts/likwid_hashtab_fullpersist_disablog.sh $i >> SCALINGEXP/btree_FLUSH_$i.out
scripts/likwid_hashtab_fullpersist_disablog.sh $i >> SCALINGEXP/btree_FLUSH_$i.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync



scripts/likwid_hashtab_fullpersist_enablelog.sh $i >> SCALINGEXP/btree_ACID_$i.out 
scripts/likwid_hashtab_fullpersist_enablelog.sh $i >> SCALINGEXP/btree_ACID_$i.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync



scripts/likwid_hashtab_nodatapersist_disablog.sh $i >> SCALINGEXP/btree_METADATALOG_$i.out
scripts/likwid_hashtab_nodatapersist_disablog.sh $i >> SCALINGEXP/btree_METADATALOG_$i.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync


scripts/likwid_hashtab_nodatapersist_enablelog.sh $i >> SCALINGEXP/btree_EnergyOracle_$i.out
scripts/likwid_hashtab_nodatapersist_enablelog.sh $i >> SCALINGEXP/btree_EnergyOracle_$i.out


sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync

scripts/likwid_hashtab_epoch_nodatapersist_enablelog.sh  $i >> SCALINGEXP/btree_ACI-RD_$i.out
scripts/likwid_hashtab_epoch_nodatapersist_enablelog.sh  $i >> SCALINGEXP/btree_ACI-RD_$i.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync

scripts/likwid_hashtab_baseline.sh $i >> SCALINGEXP/btree_BASELINE_$i.out
scripts/likwid_hashtab_baseline.sh $i >> SCALINGEXP/btree_BASELINE_$i.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync


done 


