#!/bin/bash
N_sub=45
broker_host="34.227.7.99"
port_num="1884"
QoS=1
file="0525"

echo "Starting the Subscriber(s).."
for i in $(seq 1 $N_sub); do
    ./client/mosquitto_sub -h $broker_host -i $i -p $port_num -t "QoS1/#" -q $QoS 2> /dev/null > /dev/null &
    sleep 0.1
done

for i in $(seq 1 $N_sub); do
    ./client/mosquitto_sub -h $broker_host -i "0$i" -p $port_num -t "QoS0/#" -q 0 2> /dev/null > /dev/null &
    sleep 0.1
done

sleep 1

./client/mosquitto_sub -h $broker_host -i SUB1 -p $port_num -t "QoS1/100B" -q $QoS 2>> script/$file/SUB1.csv > /dev/null &
./client/mosquitto_sub -h $broker_host -i SUB2 -p $port_num -t "QoS1/1KB" -q $QoS 2>> script/$file/SUB2.csv > /dev/null &
./client/mosquitto_sub -h $broker_host -i SUB3 -p $port_num -t "QoS1/10KB" -q $QoS 2>> script/$file/SUB3.csv > /dev/null &
./client/mosquitto_sub -h $broker_host -i SUB4 -p $port_num -t "QoS1/100KB" -q $QoS 2>> script/$file/SUB4.csv > /dev/null &
./client/mosquitto_sub -h $broker_host -i SUB5 -p $port_num -t "QoS1/1MB" -q $QoS 2>> script/$file/SUB5.csv > /dev/null &

sleep 1

./client/mosquitto_sub -h $broker_host -i SUB6 -p $port_num -t "QoS0/100B" -q 0 2>> script/$file/SUB6.csv > /dev/null &
./client/mosquitto_sub -h $broker_host -i SUB7 -p $port_num -t "QoS0/1KB" -q 0 2>> script/$file/SUB7.csv > /dev/null &
./client/mosquitto_sub -h $broker_host -i SUB8 -p $port_num -t "QoS0/10KB" -q 0 2>> script/$file/SUB8.csv > /dev/null &
./client/mosquitto_sub -h $broker_host -i SUB9 -p $port_num -t "QoS0/100KB" -q 0 2>> script/$file/SUB9.csv > /dev/null &
./client/mosquitto_sub -h $broker_host -i SUB10 -p $port_num -t "QoS0/1MB" -q 0 2>> script/$file/SUB10.csv > /dev/null &

read -p "Finish start the subscriber(s) and press any key to continue... " -n1 -s

killall mosquitto_sub