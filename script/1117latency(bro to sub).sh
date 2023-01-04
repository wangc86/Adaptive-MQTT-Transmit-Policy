#!/bin/bash

# $1 is the first command-line argument
if [[ "$#" -ne 2 ]]; then
echo "Error: need to give one parameter!"
echo "Usage: $0 #-of-data-streams"
echo "Example: $0 100"
exit 2
fi

N_pub=$1
N_sub=$2
QoS=1
port_num=1884
broker_host="50.19.178.160"

# broker_host="localhost"

message="ABCDEFGHIJ"
# message_L=`cat 1108_500KB.txt`
file_name_L="1108_100KB.txt"


echo "< The experience with $1 publisher and $2 subscriber >"
sleep 1

# echo "Starting the broker.."
# ./src/mosquitto -c ./mosquitto.conf > z_exp/1117/broker.out &
# sleep 1

echo "Starting the subscriber.."
for i in $(seq 1 $N_sub); do
    ./client/mosquitto_sub -h $broker_host -p $port_num -t topic -q $QoS -i SUB$i 2>> z_exp/1117/bro_to_sub$i.out >  z_exp/1117/sub.out &  
    sleep 0.1
done

for i in $(seq $((N_sub)) $((N_sub*2)) ); do
    ./client/mosquitto_sub -h $broker_host -p $port_num -t topic_l -q $QoS -i SUB$((i+1)) 2>> z_exp/1117/bro_to_sub$((i+1)).out >  z_exp/1117/sub.out &  
    sleep 0.1
done
echo "Finished starting all subscribers"

sleep 1

echo "Starting the publisher(s).."
# for i in $(seq 1 $N_pub); do
#     ./client/mosquitto_pub -h $broker_host -p $port_num -t topic -m hi -q $QoS -i PUB$i
#     sleep 1
# done

# Starting publishers
for i in $(seq 1 $N_pub); do
    ./1108pub.sh $broker_host $port_num $message $QoS &
    sleep 0.1
    ./1108pub2.sh $broker_host $port_num $file_name_L $QoS &
    sleep 0.1
done
echo "Finished starting all publishers"

sleep 200

killall mosquitto_pub
pkill 1108pub.sh
pkill 1108pub2.sh

sleep 30

killall mosquitto_sub
killall ./src/mosquitto

# awk '{printf "Broker to Subscriber: %ld us\n",$1}' z_exp/1117/bro_to_sub.out
# awk '{sum+=$1} END {print "<Average = ", sum/NR , "us>"}' z_exp/1117/bro_to_sub.out
# sleep 1
# echo "Backing up the output files.."
# mv z_exp/1117/bro_to_sub$i.out z_exp/1117/bro_to_sub$i.out.prev


echo "Starting the subscriber.."
for i in $(seq 1 $((N_sub*2))); do
    echo "Result of SUB$i"
    # awk '{printf "Broker to Subscriber: %ld us\n",$1}' z_exp/1117/bro_to_sub$i.out
    awk '{sum+=$1} END {print "<Average = ", sum/NR , "us>"}' z_exp/1117/bro_to_sub$i.out
    awk '{sum+=$1} END {print sum/NR }' z_exp/1117/bro_to_sub$i.out >> z_exp/1117/result.txt
    mv z_exp/1117/bro_to_sub$i.out z_exp/1117/bro_to_sub$i.out.prev
    
done
sleep 1

mv z_exp/1117/result.txt z_exp/1117/result.txt.prev
mv z_exp/1117/pub.out z_exp/1117/pub.out.prev
mv z_exp/1117/pubL.out z_exp/1117/pubL.out.prev

echo "Done!"