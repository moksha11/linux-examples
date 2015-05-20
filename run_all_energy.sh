#!/bin/sh

HOMEDIR=/home/sudarsun/libs/intelmachine/libs/linux-examples


cd $HOMEDIR

echo "start energy measurement"


cd $HOMEDIR/binarytree
rm -rf *fullpers*.out
rm -rf *nodata*dis*.out
rm -rf *nodata*ena*.out
scripts/likwid_hashtab_runall_energy.sh
exit


cd $HOMEDIR/btree-1.0
rm -rf *fullpers*.out
rm -rf *nodata*dis*.out
rm -rf *nodata*ena*.out
make clean
make
scripts/likwid_hashtab_runall_energy.sh
exit





cd $HOMEDIR/leveldb-1.14.0
rm -rf *fullpers*.out
rm -rf *nodata*dis*.out
rm -rf *nodata*ena*.out
./level_db_bench_compile.sh compile
scripts/likwid_hashtab_runall_energy.sh


cd $HOMEDIR/c-hashtable
rm -rf *fullpers*.out
rm -rf *nodata*dis*.out
rm -rf *nodata*ena*.out
scripts/likwid_hashtab_runall_energy.sh





