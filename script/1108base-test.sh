#!/bin/bash
port_num=1884
broker_host="localhost"
topic="test"
topic2="test2"
QoS_p=1
QoS_s=1
re=3
# broker_host="35.173.107.238"

echo "< The experience with 1 subscriber and 1 publisher >"
sleep 1

echo "Starting the broker.."
./src/mosquitto -c ./mosquitto.conf -v &
sleep 1

echo "Starting the subscriber.."
./client/mosquitto_sub -h $broker_host -p $port_num -i "<Sub>" -t $topic -q $QoS_s > script/sub_output.txt 2> script/sub_output2.txt&
./client/mosquitto_sub -h $broker_host -p $port_num -i "<Sub2>" -t $topic2 -q $QoS_s > script/sub_output.txt 2> script/sub_output2.txt&
sleep 1

echo "Starting the publisher(s).."

# ./client/mosquitto_pub -h $broker_host -p $port_num -i "<Pub_s(QoS=1)>" -t $topic -m "Hello!!" -q $QoS_p --repeat $re --repeat-delay 0.5 > script/pub_output.txt&
./client/mosquitto_pub -h $broker_host -p $port_num -i "<Pub_l(QoS=1)>" -t $topic -m "Helloooooooooooooooooooooooooooooooooooooooooooooooooo!!" -q $QoS_p --repeat $re --repeat-delay 0.5 > script/pub_output.txt&
sleep 2
# ./client/mosquitto_pub -h $broker_host -p $port_num -i "<Pub1(QoS=0)>" -t $topic -m "Hello QoS2!!" -q 0 --repeat $re --repeat-delay 0.5 > /dev/null &
# ./client/mosquitto_pub -h $broker_host -p $port_num -i "<Pub2>" -t $topic -m "Hello1!!" -q $QoS_p --repeat $re --repeat-delay 0.5 > /dev/null &
# ./client/mosquitto_pub -h $broker_host -p $port_num -i "<Pub3>" -t $topic -m "Hello1!!" -q $QoS_p --repeat $re --repeat-delay 0.5 > /dev/null &
# ./client/mosquitto_pub -h $broker_host -p $port_num -i "<Pub4>" -t $topic -m "Hello1!!" -q $QoS_p --repeat $re --repeat-delay 0.5 > /dev/null &

# ./client/mosquitto_pub -h $broker_host -p $port_num -i "<Pub>" -t $topic -f "1KB.txt" -q 1 &
# ./client/mosquitto_pub -h $broker_host -p $port_num -i "<Pub>" -t $topic -f "1MB.txt" -q 1 &

sleep 1

read -p "Press any key to continue... " -n1 -s

killall mosquitto_sub
killall ./src/mosquitto

echo "Done!"