CXX=g++
CC=gcc 
GNUFLAG :=  -std=gnu99

include ../Makefile.inc

INCLUDE= ../ $(NVMALLOC_HOME)
DEFINES := -DMALLOC_PRODUCTION -lstdc++
CFLAGS := -g -Wall -pipe -fvisibility=hidden \
      -funroll-loops  -Wno-implicit -Wno-uninitialized \
      -Wno-unused-but-set-variable \
      -Wno-unused-function -Wno-unused-variable -lm -lssl  -fPIC
LIBFILES = ../libpmemalloc/libpmemalloc.a ../libpmem/libpmem.a -lpmemlog -lpthread
LIBS= -L$(NVMALLOC_HOME) -lpthread $(LIBFILES) #-lnvmchkpt



tester: hashtable.o tester.o hashtable_itr.o
	$(CC) -g -Wall -O -lm -o tester hashtable.o hashtable_itr.o tester.o -I$(INCLUDE) $(CFLAGS) -L$(LIBS)

all: tester #old_tester

tester.o:	tester.c
	$(CC) -g -Wall -O -c tester.c -o tester.o -I$(INCLUDE) $(CFLAGS) $(LIBS)


old_tester: hashtable.o hashtable_powers.o tester.o hashtable_itr.o
	$(CC) -g -Wall -O -o old_tester hashtable.o hashtable_powers.o hashtable_itr.o tester.o -I$(INCLUDE) $(CFLAGS) $(LIBS)

hashtable_powers.o:	hashtable_powers.c
	$(CC) -g -Wall -O -c hashtable_powers.c -o hashtable_powers.o  -I$(INCLUDE) $(CFLAGS) $(LIBS)

hashtable.o:	hashtable.c
	$(CC) -g -Wall -O -c hashtable.c -o hashtable.o -I$(INCLUDE) $(CFLAGS) $(LIBS)

hashtable_itr.o: hashtable_itr.c
	$(CC) -g -Wall -O -c hashtable_itr.c -o hashtable_itr.o -I$(INCLUDE) $(CFLAGS) $(LIBS)

tidy:
	rm -f *.o

clean: tidy
	rm -f tester old_tester
