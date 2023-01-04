#!/bin/bash

port_num=1883
# broker_host="localhost"
broker_host="test.mosquitto.org"
# broker_host="35.173.107.238"
# broker_host="54.86.155.237"
echo "< The experience with 1 subscriber and 1 publisher >"
sleep 1

echo "Starting the broker.."
# ./src/mosquitto -c ./mosquitto.conf -v &

sleep 1

echo "Starting the subscriber.."
./client/mosquitto_sub -h $broker_host -p $port_num -i "<Sub>" -t topic -q 0 &

sleep 1

echo "Starting the publisher(s).."
./client/mosquitto_pub -h $broker_host -p $port_num -i "<Pub>" -t topic -m "Hello!!" -q 0 &
# ./client/mosquitto_pub -h $broker_host -p $port_num -i "<Pub>" -t topic -f "1KB.txt" -q 1 &
# ./client/mosquitto_pub -h $broker_host -p $port_num -i "<Pub>" -t topic -f "1MB.txt" -q 1 &

sleep 1

read -p "Press any key to continue... " -n1 -s


killall mosquitto_sub
killall ./src/mosquitto

echo "Done!"