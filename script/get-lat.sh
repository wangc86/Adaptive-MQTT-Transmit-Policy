#!/bin/bash
amount=500
file_name="script/bro2.txt"

grep latency_threshold_l: $file_name | awk {'print "time: "$2" ID: "$3" Lat: "$4" threshold_l: "$5'}


read -p "press any key to continue... " -n1 -s
