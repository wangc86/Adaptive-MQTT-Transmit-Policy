#!/bin/bash

broker_host=$1
port_num=$2
message=$3
QoS=$4
i=0

while true;
do
    ./client/mosquitto_pub -h $broker_host -p $port_num -t topic -m $message -q $QoS 2>>  z_exp/1129/pub.out &
    sleep 0.5
    # sleep 0.$(( $RANDOM % 99 + 1 ))
    i=$((i+1))
    echo "**Publish: $i"
done