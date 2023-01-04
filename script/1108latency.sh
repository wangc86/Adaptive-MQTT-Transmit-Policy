#!/bin/bash

# $1 is the first command-line argument
if [[ "$#" -ne 1 ]]; then
echo "Error: need to give one parameter!"
echo "Usage: $0 #-of-data-streams"
echo "Example: $0 100"
exit 2
fi

N_pub=$1
N_sub=1
QoS=1
port_num=1884
broker_host="localhost"

echo "Starting the broker.."
./src/mosquitto -c ./mosquitto.conf 2> z_exp/broker.out &

sleep 1

echo "Starting the subscriber.."
for i in $(seq 1 $N_sub); do
    ./client/mosquitto_sub -h $broker_host -p $port_num -t topic -q $QoS 2> z_exp/sub.out > /dev/null &    
    sleep 0.1
done
# echo "Finished starting all subscribers"

sleep 1

echo "Starting the publisher(s).."
for i in $(seq 1 $N_pub); do
    ./client/mosquitto_pub -h $broker_host -p $port_num -t topic -m hi -q $QoS 2>> z_exp/pub.out
    sleep 1
done

# # Starting publishers
# for i in $(seq 1 $N); do
# ./pub.sh &
# sleep 0.1
# done
# echo "Finished starting all publishers"

killall mosquitto_sub
killall ./src/mosquitto

paste z_exp/pub.out z_exp/broker.out z_exp/sub.out > z_exp/overall.out
# awk '{printf "Pub2sub: %ld us;\tpub2broker: %ld us;\
#     \twithin-broker: %ld us;\tbroker2sub: %ld us\n",\
#     $4-$1, $2-$1, $3-$2, $4-$3}' z_exp/overall.out > z_exp/new_overall.out

awk '{printf "Send-PUBLISH to Receive-PUBACK: %ld us\n",$3-$2}' z_exp/overall.out > z_exp/new_overall.out
sleep 1
# take the value only
# awk '{printf "%ld\n",$4}' z_exp/new_overall.out


echo "Backing up the output files.."
mv z_exp/broker.out z_exp/broker.out.prev
mv z_exp/sub.out z_exp/sub.out.prev
mv z_exp/pub.out z_exp/pub.out.prev

echo "Done!"