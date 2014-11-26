#!/bin/sh
HOMEDIR=/home/sudarsun/libs/intelmachine/libs/linux-examples
DATADIR=/mnt/pmfs
#NVMDIR=/home/sudarsun/libs/intelmachine/nvmalloc/scripts
NVMDIR=$NVMALLOC_HOME/scripts

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
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./btree-1.0/Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./basic/Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./Makefile.inc



sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' trivial/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' icount/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' libpmemalloc/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' libpmem/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' util/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' btree-1.0/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' basic/Makefile
sed -i 's/_ENABLE_LOG/_DISABLE_LOG/' Makefile.inc


sed -i 's/#define _NOPERSIST/#define _PERSIST/' libpmemalloc/pmemalloc.c
sed -i 's/#define _NOPERSIST/#define _PERSIST/' libpmemalloc/pmemalloc.h
sed -i 's/#define _NOPERSIST/#define _PERSIST/' libpmem/pmem.h
sed -i 's/#define _NOPERSIST/#define _PERSIST/' libpmem/pmem.c
sed -i 's/#define _NOPERSIST/#define _PERSIST/' libpmem/pmem_cl.c
sed -i 's/#define _NOPERSIST/#define _PERSIST/' libpmem/pmem_fit.c
sed -i 's/#define _NOPERSIST/#define _PERSIST/' btree-1.0/bt_code.c


#sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' libpmem/pmem_cl.c
sed -i 's/#define _STARTEPOCH/#define _STOPEPOCH/' libpmem/epoch.c

make clean
cd libpmem
make clean
make
cd ..

cd libpmemalloc
make clean
make
cd ..
make -j4 > dump.txt


cd btree-1.0
sudo rm -rf /mnt/pmfs/*
sudo fallocate -l 2048M /mnt/pmfs/logfile
sudo $NVMDIR/likwid_instrcnt.sh "$HOMEDIR/btree-1.0/test $1"


