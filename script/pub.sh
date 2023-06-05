#!/bin/bash
amount=200
broker_host="localhost"
port_num="1884"
QoS=1
file="0602"

echo "Starting the Publisher(s).."
for i in $(seq 1 $amount); do
now=$(date +"%T")
echo "Current time : $now , [$i]"
./client/mosquitto_pub -h $broker_host -i PUB1_$i -p $port_num -t "QoS1/100B" -q $QoS -f trans_file/100B.txt 2>> script/$file/PUB1.txt  &
sleep 1
./client/mosquitto_pub -h $broker_host -i PUB2_$i -p $port_num -t "QoS1/1KB" -q $QoS -f trans_file/1KB.txt 2>> script/$file/PUB2.txt &
sleep 1
./client/mosquitto_pub -h $broker_host -i PUB3_$i -p $port_num -t "QoS1/10KB" -q $QoS -f trans_file/10KB.txt 2>> script/$file/PUB3.txt &
sleep 1
./client/mosquitto_pub -h $broker_host -i PUB4_$i -p $port_num -t "QoS1/100KB" -q $QoS -f trans_file/100KB.txt 2>> script/$file/PUB4.txt &
sleep 1
./client/mosquitto_pub -h $broker_host -i PUB5_$i -p $port_num -t "QoS1/1MB" -q $QoS -f trans_file/1MB.txt 2>> script/$file/PUB5.txt &
sleep 1
# ./client/mosquitto_pub -h $broker_host -i PUB01_$i -p $port_num -t "QoS0/100B" -q 0 -f trans_file/100B.txt 2>> script/$file/PUB01.txt  &
# sleep 1
# ./client/mosquitto_pub -h $broker_host -i PUB02_$i -p $port_num -t "QoS0/1KB" -q 0 -f trans_file/1KB.txt 2>> script/$file/PUB02.txt &
# sleep 1
# ./client/mosquitto_pub -h $broker_host -i PUB03_$i -p $port_num -t "QoS0/10KB" -q 0 -f trans_file/10KB.txt 2>> script/$file/PUB03.txt &
# sleep 1
# ./client/mosquitto_pub -h $broker_host -i PUB04_$i -p $port_num -t "QoS0/100KB" -q 0 -f trans_file/100KB.txt 2>> script/$file/PUB04.txt &
# sleep 1
# ./client/mosquitto_pub -h $broker_host -i PUB05_$i -p $port_num -t "QoS0/1MB" -q 0 -f trans_file/1MB.txt 2>> script/$file/PUB05.txt &
sleep 1
done

read -p "Finish start the publisher(s) and press any key to continue... " -n1 -s

killall mosquitto_pub