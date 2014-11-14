#!/bin/sh
HOMEDIR=/home/sudarsun/libs/linux-examples
DATADIR=/mnt/pmfs
#NVMDIR=/home/sudarsun/nvmalloc/scripts
NVMDIR=$NVMALLOC_HOME/scripts

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync

cd ../
sed -i 's/\-D_NODATAPERSIST/\-D_ENABL_DATAPERSIST/' trivial/Makefile
sed -i 's/\-D_NODATAPERSIST/\-D_ENABL_DATAPERSIST/' icount/Makefile
sed -i 's/\-D_NODATAPERSIST/\-D_ENABL_DATAPERSIST/' libpmemalloc/Makefile
sed -i 's/\-D_NODATAPERSIST/\-D_ENABL_DATAPERSIST/' libpmem/Makefile
sed -i 's/\-D_NODATAPERSIST/\-D_ENABL_DATAPERSIST/' Makefile
sed -i 's/\-D_NODATAPERSIST/\-D_ENABL_DATAPERSIST/' util/Makefile
sed -i 's/\-D_NODATAPERSIST/\-D_ENABL_DATAPERSIST/' binarytree/Makefile
sed -i 's/\-D_NODATAPERSIST/\-D_ENABL_DATAPERSIST/' basic/Makefile
sed -i 's/\-D_NODATAPERSIST/\-D_ENABL_DATAPERSIST/' Makefile.inc

#this will enable logging
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' trivial/Makefile
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' icount/Makefile
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' libpmemalloc/Makefile
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' libpmem/Makefile
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' Makefile
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' util/Makefile
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' binarytree/Makefile
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' basic/Makefile
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' Makefile.inc

make clean
make -j4
cd binarytree

sudo rm -rf /mnt/pmfs/*
sudo cp $HOMEDIR/binarytree/*.txt $DATADIR
sudo fallocate -l 2048M /mnt/pmfs/logfile

cd $DATADIR

sudo $NVMDIR/likwid_instrcnt.sh "$HOMEDIR/binarytree/tree_wordfreq $DATADIR/tesfile $DATADIR/4000.txt $DATADIR/4300.txt  $DATADIR/4302.txt  $DATADIR/4309.txt  $DATADIR/4500.txt"



