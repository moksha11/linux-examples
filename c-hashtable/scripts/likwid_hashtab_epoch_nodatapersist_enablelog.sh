#!/bin/sh
HOMEDIR=/home/sudarsun/libs/intelmachine/libs/linux-examples
DATADIR=/mnt/pmfs
#NVMDIR=/home/sudarsun/libs/intelmachine/nvmalloc/scripts
NVMDIR=$NVMALLOC_HOME/scripts

sudo sync
sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
sudo sync

cd ../


#This will disable all data persistence
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./trivial/Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./icount/Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./libpmemalloc/Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./libpmem/Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./util/Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./c-hashtable/Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./basic/Makefile
sed -i 's/\-D_ENABL_DATAPERSIST/\-D_NODATAPERSIST/' ./Makefile.inc

#this will enable logging
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' trivial/Makefile
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' icount/Makefile
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' libpmemalloc/Makefile
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' libpmem/Makefile
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' Makefile
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' util/Makefile
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' c-hashtable/Makefile
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' basic/Makefile
sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' Makefile.inc


sed -i 's/#define _NOPERSIST/#define _PERSIST/' libpmemalloc/pmemalloc.c
sed -i 's/#define _NOPERSIST/#define _PERSIST/' libpmemalloc/pmemalloc.h
sed -i 's/#define _NOPERSIST/#define _PERSIST/' libpmem/pmem.h
sed -i 's/#define _NOPERSIST/#define _PERSIST/' libpmem/pmem.c
sed -i 's/#define _NOPERSIST/#define _PERSIST/' libpmem/pmem_cl.c
sed -i 's/#define _NOPERSIST/#define _PERSIST/' libpmem/pmem_fit.c
sed -i 's/#define _NOPERSIST/#define _PERSIST/' c-hashtable/hashtable.c


sed -i 's/#define _STOPEPOCH/#define _STARTEPOCH/' libpmem/epoch.c

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



#sed -i 's/_DISABLE_LOG/_ENABLE_LOG/' libpmem/pmem_cl.c

make clean
make -j4
cd c-hashtable
sudo rm -rf /mnt/pmfs/*
sudo fallocate -l 2048M /mnt/pmfs/logfile
sudo $NVMDIR/likwid_instrcnt.sh "$HOMEDIR/c-hashtable/tester 0 $1 0 0 0 0"


