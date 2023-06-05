#!/bin/bash
file_name="script/0602/bro2.txt"

# > script/0602/storage.csv   #清空
# > script/0602/lat.csv       #清空

echo "time,id,storage" > script/0602/storage.csv
echo "time,id,lat,threshold_l" > script/0602/lat.csv

grep storage: $file_name | awk {'print $1","$3","$4 '} >> script/0602/storage.csv
grep latency_threshold_l: $file_name | awk {'print $3","$2","$4","$5 '} >> script/0602/lat.csv

# read -p "press any key to continue... " -n1 -s
