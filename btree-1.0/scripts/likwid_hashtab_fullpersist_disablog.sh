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
sed -i 's/\-D_NODATAPERSIST/\-D_ENABL_DATAPERSIST/' btree-1.0/Makefile
sed -i 's/\-D_NODATAPERSIST/\-D_ENABL_DATAPERSIST/' basic/Makefile
sed -i 's/\-D_NODATAPERSIST/\-D_ENABL_DATAPERSIST/' Makefile.inc
sed -i 's/\-D_NODATAPERSIST/\-D_ENABL_DATAPERSIST/' c-hashtable/Makefile
sed -i 's/\-D_NODATAPERSIST/\-D_ENABL_DATAPERSIST/' binarytree/Makefile

sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' trivial/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' icount/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' libpmemalloc/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' libpmem/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' util/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' btree-1.0/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' basic/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' Makefile.inc
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' c-hashtable/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' binarytree/Makefile




#sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' libpmem/pmem_cl.c

make clean
make -j4
cd btree-1.0
sudo rm -rf /mnt/pmfs/*
sudo $NVMDIR/likwid_instrcnt.sh "$HOMEDIR/btree-1.0/test 25000"
