#!/bin/bash

HOMEDIR=/home/stewart/codes/libs/linux-examples
DATADIR=/mnt/pmfs

sudo rm -rf /mnt/pmfs/*

cp $HOMEDIR/binarytree/*.txt $DATADIR


cd $DATADIR

$HOMEDIR/binarytree/tree_wordfreq $DATADIR/tesfile $DATADIR/4000.txt $DATADIR/4300.txt  $DATADIR/4302.txt  $DATADIR/4309.txt  $DATADIR/4500.txt

