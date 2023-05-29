#!/bin/bash
N_sub=49
broker_host="34.227.7.99"
port_num="1884"
QoS=1
file="0525"

echo "Starting the Subscriber(s).."
for i in $(seq 1 $N_sub); do
    ./client/mosquitto_sub -h $broker_host -i $i -p $port_num -t "QoS1/#" -q $QoS 2> /dev/null > /dev/null &
    sleep 0.1
done

sleep 1
./client/mosquitto_sub -h $broker_host -i SUB5 -p $port_num -t "QoS1/1MB" -q $QoS 2>> script/$file/SUB5.csv > /dev/null &

read -p "Finish start the subscriber(s) and press any key to continue... " -n1 -s

killall mosquitto_sub