#!/bin/bash
#dynamic_threshold_l experiment
broker_host="54.173.72.224"
port_num="1884"
QoS=1
file="0620"
lat="latency"
t_L_value="500000"
N_sub=75

echo "Starting the Subscriber(s).."

sleep 1

./client/mosquitto_sub -h $broker_host -i SUB4 -p $port_num -t "msg/large" -q 1 2>> script/$file/SUB4.csv > /dev/null &
./client/mosquitto_sub -h $broker_host -i SUB3 -p $port_num -t "msg/small" -q 1 2>> script/$file/SUB3.csv > /dev/null &
./client/mosquitto_sub -h $broker_host -i SUB2 -p $port_num -t "msg/#" -q 1 2>> script/$file/SUB2.csv > /dev/null &
./client/mosquitto_sub -h $broker_host -i SUB1 -p $port_num -t "msg/#" -t $lat -q 1 --threshold_l $t_L_value 2>> script/$file/SUB1.csv > /dev/null &
# ./client/mosquitto_sub -h $broker_host -i SUB3 -p $port_num -t "msg/large" -t $lat -q 1 --threshold_l 250000  2>> script/$file/SUB3.csv > /dev/null &

sleep 1

for i in $(seq 1 $N_sub); do
    ./client/mosquitto_sub -h $broker_host -i "other_from_nul$i" -p $port_num -t "msg/#" -q 0 2> script/$file/sub_others.csv > /dev/null &
    sleep 0.1
done

read -p "Finish start the subscriber(s) and press any key to continue... " -n1 -s

killall mosquitto_sub
