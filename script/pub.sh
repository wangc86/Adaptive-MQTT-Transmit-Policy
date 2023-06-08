#!/bin/bash
amount=50
broker_host="54.146.219.50"
port_num="1884"
QoS=1
file="0606-1"

echo "Starting the Publisher(s).."
for i in $(seq 1 $amount); do
now=$(date +"%T")
echo "Current time : $now , [$i]"
./client/mosquitto_pub -h $broker_host -i PUB1_$i -p $port_num -t "msg/small" -q $QoS -f trans_file/100B.txt 2>> script/$file/PUB1.txt  &
sleep 2
./client/mosquitto_pub -h $broker_host -i PUB2_$i -p $port_num -t "msg/mid" -q $QoS -f trans_file/100KB.txt 2>> script/$file/PUB2.txt &
sleep 2
# ./client/mosquitto_pub -h $broker_host -i PUB3_$i -p $port_num -t "msg/large" -q $QoS -f trans_file/1MB.txt 2>> script/$file/PUB3.txt &
# sleep 2
done

read -p "Finish start the publisher(s) and press any key to continue... " -n1 -s

killall mosquitto_pub