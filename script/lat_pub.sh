#!/bin/bash
broker_host="localhost"
port_num="1884"
file="0602-1"
repeat=500
delay=5

echo "Starting the Latency Publisher(s).."
echo "Current time : $now"
./client/mosquitto_pub -h $broker_host -i LAT_PUB -p $port_num -t "latency" -q 1 -f trans_file/100B.txt --repeat $repeat --repeat-delay $delay &
sleep 1

read -p "Press any key to kill Latency Publisher... " -n1 -s

killall mosquitto_pub