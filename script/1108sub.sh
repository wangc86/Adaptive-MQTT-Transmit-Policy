#!/bin/bash
N_sub=$1
broker_host="54.87.196.147"
port_num="1884"
QoS=1

echo "Starting the Subscriber(s).."
for i in $(seq 1 $N_sub); do
    ./client/mosquitto_sub -h $broker_host -i $i -p $port_num -t topic -q $QoS &
    sleep 0.1
done

read -p "Finish start the subscriber(s) and press any key to continue... " -n1 -s

killall mosquitto_sub