#!/bin/bash

broker_host=$1
port_num=$2
file_name_L=$3
QoS=$4
i=0

while true;
do
    ./client/mosquitto_pub -h $broker_host -p $port_num -t topic_l -f $file_name_L -q $QoS 2>>  z_exp/1129/pubL.out &
    sleep 5
    # sleep 0.$(( $RANDOM % 99 + 1 ))
    i=$((i+1))
    echo "**PublishL: $i"
done
