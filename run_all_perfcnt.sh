#!/bin/sh

HOMEDIR=/home/sudarsun/libs/intelmachine/libs/linux-examples

echo "start harware counter measurement"

<<<<<<< HEAD
#cd $HOMEDIR/c-hashtable
#scripts/likwid_hashtab_runall.sh
=======
>>>>>>> 020d176e51e0c09895794d71e79013ad23fd2911

cd $HOMEDIR
cd $HOMEDIR/btree-1.0
mkdir $HOMEDIR/btree-1.0/SCALINGEXP
scripts/likwid_hashtab_runall.sh

cd $HOMEDIR
cd $HOMEDIR/c-hashtable
mkdir $HOMEDIR/c-hashtable/SCALINGEXP
scripts/likwid_hashtab_runall.sh


<<<<<<< HEAD
#cd $HOMEDIR/binarytree
#scripts/likwid_hashtab_runall.sh
=======
cd $HOMEDIR
cd $HOMEDIR/binarytree
mkdir $HOMEDIR/binarytree/SCALINGEXP
scripts/likwid_hashtab_runall.sh
>>>>>>> 020d176e51e0c09895794d71e79013ad23fd2911

#cd $HOMEDIR/leveldb-1.14.0
#./level_db_bench_compile.sh compile
#scripts/likwid_hashtab_runall.sh


