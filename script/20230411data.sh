#!/bin/bash
# 這個script是用來做資料處理的，input的資料格式為所有subscriber的latency，目的得到特定subscriber的latency

tar_sub="Sub_AWS_90"
input_file="script/test.txt"
#尋找有$tar_sub的那行，並以": "作為分隔符號($1: $2)，印出$2
grep $tar_sub $input_file | awk -F ": " '{print $2}' > script/lat_$tar_sub.txt

# input的資料格式範例，如以下
# Sub_AWS_1 latency: 2824010
# Sub_AWS_3 latency: 2873658
# Sub_AWS_4 latency: 2899249
# Sub_AWS_2 latency: 2910600
# Sub_AWS_1 latency: 2921971
# Sub_AWS_2 latency: 2922631
# Sub_AWS_4 latency: 2936522
# Sub_AWS_3 latency: 2951651
# 輸出的資料格式為某一個subscirber的所有latency，如下若tar_sub為Sub_AWS_2
# 2910600
# 2922631

