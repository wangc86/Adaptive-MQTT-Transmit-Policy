#!/bin/bash
N_sub=5
broker_host="54.146.219.50"
port_num="1884"
QoS=1
file="0606-1"
lat="latency"
t_L_value="300000"

echo "Starting the Subscriber(s).."

sleep 1

./client/mosquitto_sub -h $broker_host -i SUB1 -p $port_num -t "msg/small" -t $lat -q 1 --threshold_l $t_L_value 2>> script/$file/SUB1.csv > /dev/null &
./client/mosquitto_sub -h $broker_host -i SUB2 -p $port_num -t "msg/mid" -t $lat -q 1 --threshold_l $t_L_value  2>> script/$file/SUB2.csv > /dev/null &
# ./client/mosquitto_sub -h $broker_host -i SUB3 -p $port_num -t "msg/large" -t $lat -q 1 --threshold_l 250000  2>> script/$file/SUB3.csv > /dev/null &
./client/mosquitto_sub -h $broker_host -i SUB3 -p $port_num -t "msg/#" -t $lat -q 1 --threshold_l $t_L_value 2>> script/$file/SUB3.csv > /dev/null &
sleep 1

./client/mosquitto_sub -h $broker_host -i SUB4 -p $port_num -t "msg/small" -q 1 2>> script/$file/SUB4.csv > /dev/null &
./client/mosquitto_sub -h $broker_host -i SUB5 -p $port_num -t "msg/mid" -q 1  2>> script/$file/SUB5.csv > /dev/null &
# ./client/mosquitto_sub -h $broker_host -i SUB7 -p $port_num -t "msg/large" -q 1 2>> script/$file/SUB7.csv > /dev/null &
./client/mosquitto_sub -h $broker_host -i SUB6 -p $port_num -t "msg/#" -q 1 2>> script/$file/SUB6.csv > /dev/null &

read -p "Finish start the subscriber(s) and press any key to continue... " -n1 -s

killall mosquitto_sub