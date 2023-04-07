#!/bin/bash
port_num=1884
broker_host="localhost"
topic="test"
topic2="test2"
QoS_p=1
QoS_s=1
re=3
lat_per=8
# broker_host="35.173.107.238"

echo "< The experience with 1 subscriber and 1 publisher >"
sleep 1

echo "Starting the broker.."
./src/mosquitto -c ./mosquitto.conf -v &
sleep 1

echo "Starting the subscriber.."
./client/mosquitto_sub -h $broker_host -p $port_num -i "<Sub>" -t $topic -q $QoS_s > script/sub_output.txt 2> script/sub_output2.txt&
./client/mosquitto_sub -h $broker_host -p $port_num -i "<Sub2>" -t $topic2 -t "latency" -q $QoS_s > script/sub_output.txt 2> script/sub_output2.txt&
./client/mosquitto_sub -h $broker_host -p $port_num -i "<Sub_lat>" -t "latency" -q $QoS_s > script/sub_output.txt &
sleep 3

echo "Starting the Latency Packet Sender(s).."
./client/mosquitto_pub -h $broker_host -p $port_num -i "<Pub_Lat(QoS=1)>" -t "latency" -m "This is the latnecy packet!!" -q $QoS_p --repeat 20 --repeat-delay $lat_per &
sleep 5

echo "Starting the publisher(s).."

# ./client/mosquitto_pub -h $broker_host -p $port_num -i "<Pub_s(QoS=1)>" -t $topic -m "Hello!!" -q $QoS_p --repeat $re --repeat-delay 0.5 > script/pub_output.txt&
./client/mosquitto_pub -h $broker_host -p $port_num -i "<Pub_l(QoS=1)>" -t $topic -m "Helloooooooooooooooooooooooooooooooooooooooo!!" -q $QoS_p --repeat $re --repeat-delay 2 > script/pub_output.txt&
sleep 2
# ./client/mosquitto_pub -h $broker_host -p $port_num -i "<Pub1(QoS=0)>" -t $topic -m "Hello QoS2!!" -q 0 --repeat $re --repeat-delay 0.5 > /dev/null &

# ./client/mosquitto_pub -h $broker_host -p $port_num -i "<Pub>" -t $topic -f "1KB.txt" -q 1 &
# ./client/mosquitto_pub -h $broker_host -p $port_num -i "<Pub>" -t $topic -f "1MB.txt" -q 1 &

sleep 1

read -p "Press any key to continue... " -n1 -s

killall mosquitto_pub
killall mosquitto_sub
killall ./src/mosquitto

echo "Done!"