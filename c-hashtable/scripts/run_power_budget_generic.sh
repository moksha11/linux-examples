#!/bin/sh
#second arg is how long to budget power

POWERBUGET=/home/sudarsun/PowerTools
OUT=outputs

mkdir $OUT
sudo $POWERBUGET/power_gadget -d $1 > $OUT/$OUT'result'.txt &
numactl --physcpubind=2 $1
cat $OUT/$OUT'result'.txt


