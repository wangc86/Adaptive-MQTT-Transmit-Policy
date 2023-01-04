#!/bin/bash

num=$10



for i in $(seq 1 30)
do

    ./client/mosquitto_sub -t aa -h localhost -p 1884 -q 2 -i C$i -v &
    sleep 0.2
    echo $i
done

#./client/mosquitto_sub -t aa -h localhost -p 1884 -q 1 &

read -p "Press any key to continue... " -n1 -s

./client/mosquitto_pub -t aa -h localhost -p 1884 -m 'test1' -q 1

read -p "Press any key to continue... " -n1 -s

pkill mosquitto_sub
