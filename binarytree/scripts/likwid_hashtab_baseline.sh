#!/bin/sh

HOMEDIR=/home/sudarsun/libs/intelmachine/libs/linux-examples
DATADIR=/mnt/pmfs
#NVMDIR=/home/sudarsun/libs/intelmachine/nvmalloc/scripts
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


sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' trivial/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' icount/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' libpmemalloc/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' libpmem/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' util/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' binarytree/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' basic/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' Makefile.inc



sed -i 's/#define _PERSIST/#define _NOPERSIST/' libpmemalloc/pmemalloc.c
sed -i 's/#define _PERSIST/#define _NOPERSIST/' libpmemalloc/pmemalloc.h
sed -i 's/#define _PERSIST/#define _NOPERSIST/' libpmem/pmem.h
sed -i 's/#define _PERSIST/#define _NOPERSIST/' libpmem/pmem.c
sed -i 's/#define _PERSIST/#define _NOPERSIST/' libpmem/pmem_cl.c
sed -i 's/#define _PERSIST/#define _NOPERSIST/' libpmem/pmem_fit.c
#sed -i 's/#define _PERSIST/#define _NOPERSIST/' btree-1.0/bt_code.c

make clean
make -j4
cd binarytree
sudo rm -rf /mnt/pmfs/*
sudo cp $HOMEDIR/binarytree/*.txt $DATADIR
#sudo fallocate -l 2048M /mnt/pmfs/logfil

make clean
make -j4


cd $DATADIR
sudo $NVMDIR/likwid_instrcnt.sh "$HOMEDIR/binarytree/tree_wordfreq $DATADIR/tesfile $DATADIR/4000.txt $DATADIR/4300.txt $DATADIR/4302.txt $DATADIR/4309.txt $DATADIR/4500.txt"




