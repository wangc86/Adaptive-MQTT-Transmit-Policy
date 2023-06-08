#!/bin/bash
broker_host="54.146.219.50"
port_num="1884"
file="0606"
repeat=500
delay=6

echo "Starting the Latency Publisher(s).."
echo "Current time : $now"
./client/mosquitto_pub -h $broker_host -i LAT_PUB -p $port_num -t "latency" -q 1 -f trans_file/1KB.txt --repeat $repeat --repeat-delay $delay &
sleep 1

read -p "Press any key to kill Latency Publisher... " -n1 -s

killall mosquitto_pub