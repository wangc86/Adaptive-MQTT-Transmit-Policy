#!/bin/bash

port_num=1884
broker_host="localhost"
repeat=200
lat_per=5

while getopts r:h:p:t: flag
do
    case "${flag}" in
        r) repeat=${OPTARG};;
        t) lat_per=${OPTARG};;
        h) broker_host=${OPTARG};;
        p) port_num=${OPTARG};;
    esac
done

echo "Starting the Latency Packet Sender(s).."
echo "Repeat $repeat, Repeat-delay $lat_per ..."

./client/mosquitto_pub -h $broker_host -p $port_num -i "<lat_sender>" -t "latency" -m "This is the latnecy packet!!" -q 1 --repeat $repeat --repeat-delay $lat_per

