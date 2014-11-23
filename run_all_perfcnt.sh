#!/bin/sh

HOMEDIR=/home/sudarsun/libs/linux-examples

echo "start harware counter measurement"

cd $HOMEDIR
cd $HOMEDIR/c-hashtable
rm -rf SCALINGEXP
mkdir SCALINGEXP
scripts/likwid_hashtab_runall.sh

cd $HOMEDIR
cd $HOMEDIR/btree-1.0
rm -rf SCALINGEXP
mkdir SCALINGEXP
scripts/likwid_hashtab_runall.sh

cd $HOMEDIR
cd $HOMEDIR/binarytree
rm -rf SCALINGEXP
mkdir SCALINGEXP
scripts/likwid_hashtab_runall.sh

#cd $HOMEDIR/leveldb-1.14.0
#./level_db_bench_compile.sh compile
#scripts/likwid_hashtab_runall.sh


