#!/bin/bash
exp="0605-3"
file_name="script/$exp/bro2.txt"

# > script/0602/storage.csv   #清空
# > script/0602/lat.csv       #清空

echo "time,id,storage" > script/$exp/storage.csv
echo "time,id,lat,threshold_l" > script/$exp/lat.csv

grep storage: $file_name | awk {'print $1","$3","$4 '} >> script/$exp/storage.csv
grep latency_threshold_l: $file_name | awk {'print $3","$2","$4","$5 '} >> script/$exp/lat.csv

# read -p "press any key to continue... " -n1 -s
