#!/bin/sh
HOMEDIR=/home/sudarsun/libs/intelmachine/libs/linux-examples
DATADIR=/mnt/pmfs
NVMDIR=/home/sudarsun/libs/intelmachine/nvmalloc/scripts



for i in 100000

do


sudo rm -rf /mnt/pmfs/*

rm *.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync

scripts/likwid_hashtab_fullpersist_disablog.sh $i >> SCALINGEXP/binarytree_FLUSH.out
scripts/likwid_hashtab_fullpersist_disablog.sh $i >> SCALINGEXP/binarytree_FLUSH.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync



scripts/likwid_hashtab_fullpersist_enablelog.sh $i >> SCALINGEXP/binarytree_ACID.out 
scripts/likwid_hashtab_fullpersist_enablelog.sh $i >> SCALINGEXP/binarytree_ACID.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync



scripts/likwid_hashtab_nodatapersist_disablog.sh $i >> SCALINGEXP/binarytree_nodatapersist_disablog_HWCNTS_all.out
scripts/likwid_hashtab_nodatapersist_disablog.sh $i >> SCALINGEXP/binarytree_nodatapersist_disablog_HWCNTS_all.out


sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync



scripts/likwid_hashtab_epoch_nodatapersist_enablelog.sh $i >> SCALINGEXP/binarytree_ACI-RD.out
scripts/likwid_hashtab_epoch_nodatapersist_enablelog.sh $i >> SCALINGEXP/binarytree_ACI-RD.out

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync


scripts/likwid_hashtab_nodatapersist_enablelog.sh $i >> SCALINGEXP/binarytree_EnergyOracle.out
scripts/likwid_hashtab_nodatapersist_enablelog.sh $i >> SCALINGEXP/binarytree_EnergyOracle.out

done

