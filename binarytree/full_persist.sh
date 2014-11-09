make -C basic clean
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/basic'
rm -f *.o core a.out testfile*
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/basic'
make -C binarytree clean
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/binarytree'
rm -f *.o core a.out testfile*
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/binarytree'
make -C icount clean
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/icount'
rm -f *.o core a.out testfile*
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/icount'
make -C libpmem clean
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/libpmem'
rm -f *.o core a.out
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/libpmem'
make -C libpmemalloc clean
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/libpmemalloc'
Makefile:111: warning: overriding commands for target `test'
Makefile:87: warning: ignoring old commands for target `test'
rm -f *.o core a.out
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/libpmemalloc'
make -C trivial clean
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/trivial'
rm -f *.o core a.out testfile
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/trivial'
make -C util clean
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/util'
rm -f *.o core a.out
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/util'
make -C basic all
make -C binarytree all
make -C icount all
make -C libpmem all
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/basic'
cc -c -Wall -Werror  -I.. basic.c -o basic.o
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/binarytree'
cc -c -Wall -Werror  -I.. tree.c -o tree.o
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/libpmem'
cc -c -o pmem.o  -I.. -fPIC pmem.c
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/icount'
cc -c -Wall -Werror  -I.. icount_test.c -o icount_test.o
cc -c -o pmem_cl.o  -I.. -fPIC pmem_cl.c
cc -c -o icount.o -Wall -Werror  -I.. ../icount/icount.c
cc -c -o util.o -Wall -Werror  -I.. ../util/util.c
cc -c -o pmem_fit.o  -I.. -fPIC pmem_fit.c
cc -c -o icount.o -Wall -Werror  -I.. ../icount/icount.c
cc -c -o icount.o -Wall -Werror  -I.. ../icount/icount.c
cc -c -o pmem_msync.o  -I.. -fPIC pmem_msync.c
cc -c -o util.o -Wall -Werror  -I.. ../util/util.c
cc -c -o util.o  -I.. -fPIC ../util/util.c
cc -o icount_test -Wall -Werror  icount_test.o icount.o util.o  
make -C ../libpmemalloc
make[2]: Entering directory `/home/stewart/codes/libs/linux-examples/libpmemalloc'
Makefile:111: warning: overriding commands for target `test'
Makefile:87: warning: ignoring old commands for target `test'
cc -c -o pmemalloc.o -fPIC -I..  pmemalloc.c
make -C ../libpmem
make[2]: Entering directory `/home/stewart/codes/libs/linux-examples/libpmem'
cc -c -o util.o  -I.. -fPIC ../util/util.c
ar rv libpmem.a pmem.o pmem_cl.o pmem_fit.o pmem_msync.o util.o
r - pmem.o
r - pmem_cl.o
r - pmem_fit.o
r - pmem_msync.o
r - util.o
cc  -shared -Wl,--version-script=pmem.map,-soname,.1 -o libpmem.so pmem.o pmem_cl.o pmem_fit.o pmem_msync.o util.o
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/icount'
cc -c -o util.o -fPIC -I..  -fPIC ../util/util.c
pmemalloc.c: In function ‘pmemalloc_check’:
pmemalloc.c:924:4: warning: format ‘%d’ expects argument of type ‘int’, but argument 3 has type ‘size_t’ [-Wformat=]
    stbuf.st_size, clumptotal);
    ^
pmemalloc.c:932:5: warning: format ‘%d’ expects argument of type ‘int’, but argument 3 has type ‘size_t’ [-Wformat=]
     stats[i].smallest);
     ^
pmemalloc.c:932:5: warning: format ‘%d’ expects argument of type ‘int’, but argument 5 has type ‘size_t’ [-Wformat=]
pmemalloc.c:932:5: warning: format ‘%d’ expects argument of type ‘int’, but argument 6 has type ‘size_t’ [-Wformat=]
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/libpmem'
make -C ../libpmem
make[2]: Entering directory `/home/stewart/codes/libs/linux-examples/libpmem'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/stewart/codes/libs/linux-examples/libpmem'
cc -c -o icount.o -fPIC -I..  -fPIC ../icount/icount.c
ar rv libpmem.a pmem.o pmem_cl.o pmem_fit.o pmem_msync.o util.o
r - pmem.o
r - pmem_cl.o
r - pmem_fit.o
r - pmem_msync.o
r - util.o
cc  -shared -Wl,--version-script=pmem.map,-soname,.1 -o libpmem.so pmem.o pmem_cl.o pmem_fit.o pmem_msync.o util.o
make -C libpmemalloc all
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/libpmemalloc'
Makefile:111: warning: overriding commands for target `test'
Makefile:87: warning: ignoring old commands for target `test'
cc -c -o pmemalloc.o -fPIC -I..  pmemalloc.c
make[2]: Leaving directory `/home/stewart/codes/libs/linux-examples/libpmem'
cc -o basic -Wall -Werror  basic.o util.o icount.o ../libpmem/libpmem.a ../libpmem/libpmem.a 
make -C trivial all
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/trivial'
make[1]: Nothing to be done for `all'.
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/trivial'
make -C util all
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/util'
make[1]: Nothing to be done for `all'.
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/util'
cc -c -o icount.o -fPIC -I..  -fPIC ../icount/icount.c
cc -c -o pmemalloc_test1.o  -I..  pmemalloc_test1.c
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/basic'
cc -c -o pmemalloc_test1.o  -I..  pmemalloc_test1.c
pmemalloc.c: In function ‘pmemalloc_check’:
pmemalloc.c:924:4: warning: format ‘%d’ expects argument of type ‘int’, but argument 3 has type ‘size_t’ [-Wformat=]
    stbuf.st_size, clumptotal);
    ^
pmemalloc.c:932:5: warning: format ‘%d’ expects argument of type ‘int’, but argument 3 has type ‘size_t’ [-Wformat=]
     stats[i].smallest);
     ^
pmemalloc.c:932:5: warning: format ‘%d’ expects argument of type ‘int’, but argument 5 has type ‘size_t’ [-Wformat=]
pmemalloc.c:932:5: warning: format ‘%d’ expects argument of type ‘int’, but argument 6 has type ‘size_t’ [-Wformat=]
make -C ../libpmem
make[3]: Entering directory `/home/stewart/codes/libs/linux-examples/libpmem'
make[3]: Nothing to be done for `all'.
make[3]: Leaving directory `/home/stewart/codes/libs/linux-examples/libpmem'
make -C ../libpmem
make[2]: Entering directory `/home/stewart/codes/libs/linux-examples/libpmem'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/stewart/codes/libs/linux-examples/libpmem'
cc -c -o pmemalloc_test2.o  -I..  pmemalloc_test2.c
cc -c -Wall -Werror  -I.. tree_insert.c -o tree_insert.o
cc -c -Wall -Werror  -I.. tree_walk.c -o tree_walk.o
cc -c -o pmemalloc_test2.o  -I..  pmemalloc_test2.c
cc -c -o pmemalloc_check.o  -I..  pmemalloc_check.c
cc -c -o pmemalloc_check.o  -I..  pmemalloc_check.c
cc -c -Wall -Werror  -I.. tree_free.c -o tree_free.o
cc -c -Wall -Werror  -I.. tree_wordfreq.c -o tree_wordfreq.o
ar rv libpmemalloc.a pmemalloc.o util.o icount.o
r - pmemalloc.o
r - util.o
r - icount.o
cc -fPIC -shared -Wl,--version-script=pmemalloc.map,-soname,.1 -o libpmemalloc.so pmemalloc.o util.o icount.o
ar rv libpmemalloc.a pmemalloc.o util.o icount.o
r - pmemalloc.o
r - util.o
r - icount.o
cc -fPIC -shared -Wl,--version-script=pmemalloc.map,-soname,.1 -o libpmemalloc.so pmemalloc.o util.o icount.o
cc -o pmemalloc_test1  -I..  pmemalloc_test1.c ../libpmem/libpmem.a libpmemalloc.a
cc -o pmemalloc_test1  -I..  pmemalloc_test1.c ../libpmem/libpmem.a libpmemalloc.a
cc -o pmemalloc_test2  -I..  pmemalloc_test2.c ../libpmem/libpmem.a libpmemalloc.a
cc -o pmemalloc_check  -I..  pmemalloc_check.c ../libpmem/libpmem.a libpmemalloc.a
cc -o pmemalloc_test2  -I..  pmemalloc_test2.c ../libpmem/libpmem.a libpmemalloc.a
cc -o pmemalloc_check  -I..  pmemalloc_check.c ../libpmem/libpmem.a libpmemalloc.a
make[2]: Leaving directory `/home/stewart/codes/libs/linux-examples/libpmemalloc'
cc -o tree_insert -Wall -Werror  tree.o util.o icount.o ../libpmemalloc/libpmemalloc.a ../libpmem/libpmem.a tree_insert.o ../libpmemalloc/libpmemalloc.a ../libpmem/libpmem.a 
cc -o tree_walk -Wall -Werror  tree.o util.o icount.o ../libpmemalloc/libpmemalloc.a ../libpmem/libpmem.a tree_walk.o ../libpmemalloc/libpmemalloc.a ../libpmem/libpmem.a 
cc -o tree_free -Wall -Werror  tree.o util.o icount.o ../libpmemalloc/libpmemalloc.a ../libpmem/libpmem.a tree_free.o ../libpmemalloc/libpmemalloc.a ../libpmem/libpmem.a 
cc -o tree_wordfreq -Wall -Werror  tree.o util.o icount.o ../libpmemalloc/libpmemalloc.a ../libpmem/libpmem.a tree_wordfreq.o ../libpmemalloc/libpmemalloc.a ../libpmem/libpmem.a 
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/libpmemalloc'
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/binarytree'
Enter application name and arguments as params for the script
-------------------------------------------------------------
-------------------------------------------------------------
CPU type:	Intel Core Lynnfield processor 
CPU clock:	2.94 GHz 
-------------------------------------------------------------
/home/stewart/codes/libs/linux-examples/binarytree/tree_wordfreq /mnt/pmfs/tesfile /mnt/pmfs/4000.txt /mnt/pmfs/4300.txt /mnt/pmfs/4302.txt /mnt/pmfs/4309.txt /mnt/pmfs/4500.txt
Status: 0x0 
Status: 0x0 
Status: 0x0 
Status: 0x0 
Status: 0x0 
Status: 0x0 
Status: 0x0 
Status: 0x0 
+-------------------------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+
|             Event             |   core 0    |   core 1    |   core 2    |   core 3    |   core 4    |   core 5    |   core 6    |   core 7    |
+-------------------------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+
|       INSTR_RETIRED_ANY       | 1.56604e+11 | 1.01173e+10 | 1.1764e+10  | 7.37795e+09 | 5.63621e+07 | 1.22102e+10 | 7.15259e+09 | 1.08567e+10 |
| MEM_UNCORE_RETIRED_LOCAL_DRAM | 2.36481e+08 | 1.32992e+07 | 1.58395e+07 | 1.05513e+07 |   178370    | 1.08925e+07 | 7.57661e+06 | 1.24358e+07 |
|    MEM_INST_RETIRED_LOADS     | 7.47222e+10 | 2.7829e+09  | 3.26354e+09 | 2.00684e+09 | 1.66838e+07 | 3.48889e+09 | 2.01386e+09 | 3.1114e+09  |
|    MEM_INST_RETIRED_STORES    | 3.23027e+10 | 1.50268e+09 | 1.72449e+09 | 1.08873e+09 | 9.49673e+06 | 1.82501e+09 | 1.05363e+09 | 1.59586e+09 |
|        UNC_L3_MISS_ANY        | 6.8117e+09  |      0      |      0      |      0      |      0      |      0      |      0      |      0      |
|       INSTR_RETIRED_ANY       | 1.56604e+11 | 1.01173e+10 | 1.1764e+10  | 7.37795e+09 | 5.63621e+07 | 1.22102e+10 | 7.15259e+09 | 1.08567e+10 |
|     CPU_CLK_UNHALTED_CORE     | 3.4878e+11  | 1.71101e+10 | 1.82901e+10 | 1.33455e+10 | 3.52785e+08 | 1.75045e+10 | 1.18619e+10 | 1.55121e+10 |
|     CPU_CLK_UNHALTED_REF      | 2.92692e+11 | 1.53443e+10 | 1.63494e+10 | 1.19896e+10 | 3.20039e+08 | 1.56478e+10 | 1.07094e+10 | 1.38027e+10 |
+-------------------------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+
+------------------------------------+-------------+-------------+-------------+-------------+
|               Event                |     Sum     |     Max     |     Min     |     Avg     |
+------------------------------------+-------------+-------------+-------------+-------------+
|       INSTR_RETIRED_ANY STAT       | 2.16139e+11 | 1.56604e+11 | 5.63621e+07 | 2.70173e+10 |
| MEM_UNCORE_RETIRED_LOCAL_DRAM STAT | 3.07254e+08 | 2.36481e+08 |   178370    | 3.84067e+07 |
|    MEM_INST_RETIRED_LOADS STAT     | 9.14063e+10 | 7.47222e+10 | 1.66838e+07 | 1.14258e+10 |
|    MEM_INST_RETIRED_STORES STAT    | 4.11026e+10 | 3.23027e+10 | 9.49673e+06 | 5.13782e+09 |
|        UNC_L3_MISS_ANY STAT        | 6.8117e+09  | 6.8117e+09  |      0      | 8.51463e+08 |
|       INSTR_RETIRED_ANY STAT       | 2.16139e+11 | 1.56604e+11 | 5.63621e+07 | 2.70173e+10 |
|     CPU_CLK_UNHALTED_CORE STAT     | 4.42757e+11 | 3.4878e+11  | 3.52785e+08 | 5.53447e+10 |
|     CPU_CLK_UNHALTED_REF STAT      | 3.76855e+11 | 2.92692e+11 | 3.20039e+08 | 4.71069e+10 |
+------------------------------------+-------------+-------------+-------------+-------------+
+----------------------+---------+---------+---------+---------+----------+---------+---------+---------+
|        Metric        | core 0  | core 1  | core 2  | core 3  |  core 4  | core 5  | core 6  | core 7  |
+----------------------+---------+---------+---------+---------+----------+---------+---------+---------+
| Runtime (RDTSC) [s]  | 100.458 | 100.458 | 100.458 | 100.458 | 100.458  | 100.458 | 100.458 | 100.458 |
| Runtime unhalted [s] | 118.534 | 5.81491 | 6.21591 | 4.53548 | 0.119895 | 5.94895 | 4.03129 | 5.2718  |
|     Clock [MHz]      | 3506.32 | 3281.07 | 3291.72 | 3275.2  | 3243.53  | 3291.61 | 3259.13 | 3306.86 |
|         CPI          | 2.22715 | 1.69118 | 1.55475 | 1.80883 | 6.25926  | 1.4336  | 1.65841 | 1.42879 |
+----------------------+---------+---------+---------+---------+----------+---------+---------+---------+
make -C basic clean
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/basic'
rm -f *.o core a.out testfile*
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/basic'
make -C binarytree clean
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/binarytree'
rm -f *.o core a.out testfile*
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/binarytree'
make -C icount clean
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/icount'
rm -f *.o core a.out testfile*
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/icount'
make -C libpmem clean
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/libpmem'
rm -f *.o core a.out
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/libpmem'
make -C libpmemalloc clean
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/libpmemalloc'
Makefile:111: warning: overriding commands for target `test'
Makefile:87: warning: ignoring old commands for target `test'
rm -f *.o core a.out
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/libpmemalloc'
make -C trivial clean
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/trivial'
rm -f *.o core a.out testfile
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/trivial'
make -C util clean
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/util'
rm -f *.o core a.out
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/util'
make -C basic all
make -C binarytree all
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/basic'
cc -c -Wall -Werror  -I.. basic.c -o basic.o
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/binarytree'
cc -c -Wall -Werror  -I.. tree.c -o tree.o
make -C icount all
make -C libpmem all
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/icount'
cc -c -Wall -Werror  -I.. icount_test.c -o icount_test.o
make[1]: Entering directory `/home/stewart/codes/libs/linux-examples/libpmem'
cc -c -o pmem.o  -I.. -fPIC pmem.c
cc -c -o util.o -Wall -Werror  -I.. ../util/util.c
cc -c -o pmem_cl.o  -I.. -fPIC pmem_cl.c
cc -c -o util.o -Wall -Werror  -I.. ../util/util.c
cc -c -o icount.o -Wall -Werror  -I.. ../icount/icount.c
cc -c -o pmem_fit.o  -I.. -fPIC pmem_fit.c
cc -c -o icount.o -Wall -Werror  -I.. ../icount/icount.c
cc -c -o icount.o -Wall -Werror  -I.. ../icount/icount.c
cc -c -o util.o -Wall -Werror  -I.. ../util/util.c
cc -c -o pmem_msync.o  -I.. -fPIC pmem_msync.c
make -C ../libpmem
make[2]: Entering directory `/home/stewart/codes/libs/linux-examples/libpmem'
cc -c -o pmem_msync.o  -I.. -fPIC pmem_msync.c
make -C ../libpmemalloc
make[2]: Entering directory `/home/stewart/codes/libs/linux-examples/libpmemalloc'
Makefile:111: warning: overriding commands for target `test'
Makefile:87: warning: ignoring old commands for target `test'
cc -c -o pmemalloc.o -fPIC -I..  pmemalloc.c
cc -c -o util.o  -I.. -fPIC ../util/util.c
cc -o icount_test -Wall -Werror  icount_test.o icount.o util.o  
cc -c -o util.o  -I.. -fPIC ../util/util.c
pmemalloc.c: In function ‘pmemalloc_check’:
pmemalloc.c:924:4: warning: format ‘%d’ expects argument of type ‘int’, but argument 3 has type ‘size_t’ [-Wformat=]
    stbuf.st_size, clumptotal);
    ^
pmemalloc.c:932:5: warning: format ‘%d’ expects argument of type ‘int’, but argument 3 has type ‘size_t’ [-Wformat=]
     stats[i].smallest);
     ^
pmemalloc.c:932:5: warning: format ‘%d’ expects argument of type ‘int’, but argument 5 has type ‘size_t’ [-Wformat=]
pmemalloc.c:932:5: warning: format ‘%d’ expects argument of type ‘int’, but argument 6 has type ‘size_t’ [-Wformat=]
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/icount'
cc -c -o util.o -fPIC -I..  -fPIC ../util/util.c
ar rv libpmem.a pmem.o pmem_cl.o pmem_fit.o pmem_msync.o util.o
r - pmem.o
r - pmem_cl.o
r - pmem_fit.o
r - pmem_msync.o
r - util.o
cc  -shared -Wl,--version-script=pmem.map,-soname,.1 -o libpmem.so pmem.o pmem_cl.o pmem_fit.o pmem_msync.o util.o
util.o: file not recognized: File truncated
collect2: error: ld returned 1 exit status
make[1]: *** [libpmem.so] Error 1
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/libpmem'
make: *** [libpmem] Error 2
make: *** Waiting for unfinished jobs....
cc -c -o icount.o -fPIC -I..  -fPIC ../icount/icount.c
ar rv libpmem.a pmem.o pmem_cl.o pmem_fit.o pmem_msync.o util.o
r - pmem.o
r - pmem_cl.o
r - pmem_fit.o
r - pmem_msync.o
r - util.o
cc  -shared -Wl,--version-script=pmem.map,-soname,.1 -o libpmem.so pmem.o pmem_cl.o pmem_fit.o pmem_msync.o util.o
make -C ../libpmem
make[2]: Entering directory `/home/stewart/codes/libs/linux-examples/libpmem'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/stewart/codes/libs/linux-examples/libpmem'
cc -c -o pmemalloc_test1.o  -I..  pmemalloc_test1.c
make[2]: Leaving directory `/home/stewart/codes/libs/linux-examples/libpmem'
cc -o basic -Wall -Werror  basic.o util.o icount.o ../libpmem/libpmem.a ../libpmem/libpmem.a 
make -C ../libpmem
make[3]: Entering directory `/home/stewart/codes/libs/linux-examples/libpmem'
make[3]: Nothing to be done for `all'.
make[3]: Leaving directory `/home/stewart/codes/libs/linux-examples/libpmem'
cc -c -Wall -Werror  -I.. tree_insert.c -o tree_insert.o
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/basic'
cc -c -Wall -Werror  -I.. tree_walk.c -o tree_walk.o
cc -c -Wall -Werror  -I.. tree_free.c -o tree_free.o
cc -c -o pmemalloc_test2.o  -I..  pmemalloc_test2.c
cc -c -Wall -Werror  -I.. tree_wordfreq.c -o tree_wordfreq.o
cc -c -o pmemalloc_check.o  -I..  pmemalloc_check.c
ar rv libpmemalloc.a pmemalloc.o util.o icount.o
cc -fPIC -shared -Wl,--version-script=pmemalloc.map,-soname,.1 -o libpmemalloc.so pmemalloc.o util.o icount.o
r - pmemalloc.o
r - util.o
r - icount.o
cc -o pmemalloc_test1  -I..  pmemalloc_test1.c ../libpmem/libpmem.a libpmemalloc.a
cc -o pmemalloc_test2  -I..  pmemalloc_test2.c ../libpmem/libpmem.a libpmemalloc.a
cc -o pmemalloc_check  -I..  pmemalloc_check.c ../libpmem/libpmem.a libpmemalloc.a
make[2]: Leaving directory `/home/stewart/codes/libs/linux-examples/libpmemalloc'
cc -o tree_insert -Wall -Werror  tree.o util.o icount.o ../libpmemalloc/libpmemalloc.a ../libpmem/libpmem.a tree_insert.o ../libpmemalloc/libpmemalloc.a ../libpmem/libpmem.a 
cc -o tree_walk -Wall -Werror  tree.o util.o icount.o ../libpmemalloc/libpmemalloc.a ../libpmem/libpmem.a tree_walk.o ../libpmemalloc/libpmemalloc.a ../libpmem/libpmem.a 
cc -o tree_free -Wall -Werror  tree.o util.o icount.o ../libpmemalloc/libpmemalloc.a ../libpmem/libpmem.a tree_free.o ../libpmemalloc/libpmemalloc.a ../libpmem/libpmem.a 
cc -o tree_wordfreq -Wall -Werror  tree.o util.o icount.o ../libpmemalloc/libpmemalloc.a ../libpmem/libpmem.a tree_wordfreq.o ../libpmemalloc/libpmemalloc.a ../libpmem/libpmem.a 
make[1]: Leaving directory `/home/stewart/codes/libs/linux-examples/binarytree'
Enter application name and arguments as params for the script
-------------------------------------------------------------
-------------------------------------------------------------
CPU type:	Intel Core Lynnfield processor 
CPU clock:	2.94 GHz 
-------------------------------------------------------------
/home/stewart/codes/libs/linux-examples/binarytree/tree_wordfreq /mnt/pmfs/tesfile /mnt/pmfs/4000.txt /mnt/pmfs/4300.txt /mnt/pmfs/4302.txt /mnt/pmfs/4309.txt /mnt/pmfs/4500.txt
Status: 0x0 
Status: 0x0 
Status: 0x0 
Status: 0x0 
Status: 0x0 
Status: 0x0 
Status: 0x0 
Status: 0x0 
+-------------------------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+
|             Event             |   core 0    |   core 1    |   core 2    |   core 3    |   core 4    |   core 5    |   core 6    |   core 7    |
+-------------------------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+
|       INSTR_RETIRED_ANY       | 1.56604e+11 | 1.1114e+10  | 1.18376e+10 | 1.09902e+10 | 1.19676e+09 | 7.67408e+09 | 1.11354e+10 | 1.11416e+10 |
| MEM_UNCORE_RETIRED_LOCAL_DRAM | 2.15937e+08 | 1.9438e+07  | 1.67685e+07 | 1.61287e+07 | 2.22741e+06 | 1.20887e+07 | 1.67789e+07 | 1.59132e+07 |
|    MEM_INST_RETIRED_LOADS     | 7.47222e+10 | 2.78603e+09 | 2.99447e+09 | 2.71872e+09 | 3.14391e+08 | 1.94837e+09 | 2.94582e+09 | 2.91002e+09 |
|    MEM_INST_RETIRED_STORES    | 3.23027e+10 | 1.41227e+09 | 1.58753e+09 | 1.46654e+09 | 1.52967e+08 |  9.656e+08  | 1.53666e+09 | 1.52407e+09 |
|        UNC_L3_MISS_ANY        | 7.12086e+09 |      0      |      0      |      0      |      0      |      0      |      0      |      0      |
|       INSTR_RETIRED_ANY       | 1.56604e+11 | 1.1114e+10  | 1.18376e+10 | 1.09902e+10 | 1.19676e+09 | 7.67408e+09 | 1.11354e+10 | 1.11416e+10 |
|     CPU_CLK_UNHALTED_CORE     | 3.54314e+11 | 1.74907e+10 | 1.84608e+10 | 1.75584e+10 | 2.73028e+09 | 1.23424e+10 | 1.8361e+10  | 1.78376e+10 |
|     CPU_CLK_UNHALTED_REF      | 2.97954e+11 | 1.57571e+10 | 1.65763e+10 | 1.5847e+10  | 2.43594e+09 | 1.11694e+10 |  1.647e+10  | 1.60158e+10 |
+-------------------------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+-------------+
+------------------------------------+-------------+-------------+-------------+-------------+
|               Event                |     Sum     |     Max     |     Min     |     Avg     |
+------------------------------------+-------------+-------------+-------------+-------------+
|       INSTR_RETIRED_ANY STAT       | 2.21693e+11 | 1.56604e+11 | 1.19676e+09 | 2.77117e+10 |
| MEM_UNCORE_RETIRED_LOCAL_DRAM STAT | 3.1528e+08  | 2.15937e+08 | 2.22741e+06 |  3.941e+07  |
|    MEM_INST_RETIRED_LOADS STAT     |  9.134e+10  | 7.47222e+10 | 3.14391e+08 | 1.14175e+10 |
|    MEM_INST_RETIRED_STORES STAT    | 4.09483e+10 | 3.23027e+10 | 1.52967e+08 | 5.11854e+09 |
|        UNC_L3_MISS_ANY STAT        | 7.12086e+09 | 7.12086e+09 |      0      | 8.90108e+08 |
|       INSTR_RETIRED_ANY STAT       | 2.21693e+11 | 1.56604e+11 | 1.19676e+09 | 2.77117e+10 |
|     CPU_CLK_UNHALTED_CORE STAT     | 4.59095e+11 | 3.54314e+11 | 2.73028e+09 | 5.73869e+10 |
|     CPU_CLK_UNHALTED_REF STAT      | 3.92226e+11 | 2.97954e+11 | 2.43594e+09 | 4.90282e+10 |
+------------------------------------+-------------+-------------+-------------+-------------+
+----------------------+---------+---------+---------+---------+----------+---------+---------+---------+
|        Metric        | core 0  | core 1  | core 2  | core 3  |  core 4  | core 5  | core 6  | core 7  |
+----------------------+---------+---------+---------+---------+----------+---------+---------+---------+
| Runtime (RDTSC) [s]  | 102.272 | 102.272 | 102.272 | 102.272 | 102.272  | 102.272 | 102.272 | 102.272 |
| Runtime unhalted [s] | 120.414 | 5.94422 | 6.27393 | 5.96726 | 0.927891 | 4.19457 | 6.24001 | 6.06214 |
|     Clock [MHz]      | 3499.04 | 3266.18 | 3276.98 | 3260.24 | 3298.02  | 3251.47 | 3280.3  | 3277.16 |
|         CPI          | 2.26249 | 1.57375 | 1.5595  | 1.59764 | 2.28139  | 1.60832 | 1.64888 | 1.60099 |
+----------------------+---------+---------+---------+---------+----------+---------+---------+---------+
