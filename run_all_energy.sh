#!/bin/sh

HOMEDIR=/home/sudarsun/libs/linux-examples


cd $HOMEDIR

echo "start energy measurement"

cd $HOMEDIR/c-hashtable
scripts/likwid_hashtab_runall_energy.sh

cd $HOMEDIR/btree-1.0
scripts/likwid_hashtab_runall_energy.sh


cd $HOMEDIR/binarytree
scripts/likwid_hashtab_runall_energy.sh

cd $HOMEDIR/leveldb-1.14.0
./level_db_bench_compile.sh compile
scripts/likwid_hashtab_runall_energy.sh



