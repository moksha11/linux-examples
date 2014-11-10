#!/bin/bash

HOMEDIR=/home/stewart/codes/libs/linux-examples
DATADIR=/mnt/pmfs
NVMDIR=/home/stewart/codes/nvmalloc/scripts

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync

cd ../
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./trivial/Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./icount/Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./libpmemalloc/Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./libpmem/Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./util/Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./binarytree/Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./basic/Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./Makefile.inc

make clean
make -j4
cd binarytree

sudo rm -rf /mnt/pmfs/*
sudo cp $HOMEDIR/binarytree/*.txt $DATADIR


cd $DATADIR

sudo $NVMDIR/likwid_instrcnt.sh "taskset -c 4 $HOMEDIR/binarytree/tree_wordfreq $DATADIR/tesfile $DATADIR/4000.txt $DATADIR/4300.txt  $DATADIR/4302.txt  $DATADIR/4309.txt  $DATADIR/4500.txt"

