#!/bin/bash
amount=200
broker_host="34.227.7.99"
port_num="1884"
QoS=1
file="0525"

echo "Starting the Publisher(s).."
for i in $(seq 1 $amount); do
now=$(date +"%T")
echo "Current time : $now , [$i]"

./client/mosquitto_pub -h $broker_host -i PUB5_$i -p $port_num -t "QoS1/1MB" -q $QoS -f trans_file/1MB.txt 2>> script/$file/PUB5.txt &
sleep 5
done

read -p "Finish start the publisher(s) and press any key to continue... " -n1 -s

killall mosquitto_pub