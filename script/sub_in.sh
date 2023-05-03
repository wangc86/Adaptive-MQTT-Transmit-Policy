#!/bin/bash

port_num=1884
broker_host="localhost"
threshold_l="300"

while getopts t:h:p: flag
do
    case "${flag}" in
        t) threshold_l=${OPTARG};;
        h) broker_host=${OPTARG};;
        p) port_num=${OPTARG};;
    esac
done


./client/mosquitto_sub -h $broker_host -p $port_num -i "<Sub_in>" -t "test" -t "latency" -q 1 --threshold_l $threshold_l 
