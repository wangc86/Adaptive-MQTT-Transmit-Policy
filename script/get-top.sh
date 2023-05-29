#!/bin/bash
amount=500

>script/top.txt
for i in $(seq 1 $amount); do
now=$(date +%s%N)
echo $now $i

echo ${now:0:16} >> script/top.txt
top -b -n 1| grep mosquitto| awk {'print "CPU: "$9" MEMORY: "$10'} >> script/top.txt
sleep 5

done

read -p "press any key to continue... " -n1 -s
