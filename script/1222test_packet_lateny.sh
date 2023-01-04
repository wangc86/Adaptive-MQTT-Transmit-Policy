#!/bin/bash

# echo "< The experience test latency with different packet size >"
# sleep 1

# # echo "Starting the broker.."
# # ./src/mosquitto -c ./mosquitto.conf > z_exp/1117/broker.out &
# # sleep 1

# broker_h="140.122.184.235"
# broker_p="1884"

# ./client/mosquitto_sub -p $broker_p -h $broker_h -t 10B 2>> z_exp/1222/10B_result.txt &
# ./client/mosquitto_sub -p $broker_p -h $broker_h -t 100B 2>> z_exp/1222/100B_result.txt &
# ./client/mosquitto_sub -p $broker_p -h $broker_h -t 1KB 2>> z_exp/1222/1KB_result.txt &
# ./client/mosquitto_sub -p $broker_p -h $broker_h -t 10KB 2>> z_exp/1222/10KB_result.txt &
# ./client/mosquitto_sub -p $broker_p -h $broker_h -t 100KB 2>> z_exp/1222/100KB_result.txt &
# ./client/mosquitto_sub -p $broker_p -h $broker_h -t 1MB 2>> z_exp/1222/1MB_result.txt &

# sleep 5
# # ./client/mosquitto_pub -p $broker_p -h $broker_h -t 10B -m "ABCDEFGJIJ" --repeat 30 --repeat-delay 3
# # ./client/mosquitto_pub -p $broker_p -h $broker_h -t 100B -f 100B.txt --repeat 30 --repeat-delay 3
# # ./client/mosquitto_pub -p $broker_p -h $broker_h -t 1KB -f 1KB.txt --repeat 30 --repeat-delay 3
# # ./client/mosquitto_pub -p $broker_p -h $broker_h -t 10KB -f 10KB.txt --repeat 30 --repeat-delay 3
# ./client/mosquitto_pub -p $broker_p -h $broker_h -t 100KB -f 100KB.txt --repeat 30 --repeat-delay 10
# ./client/mosquitto_pub -p $broker_p -h $broker_h -t 1MB -f 1MB.txt --repeat 30 --repeat-delay 10

# sleep 20

# killall mosquitto_sub
# killall mosquitto_pub

awk '{ sum = sum+$4-$1 } END { if(NR>0) printf"%d\n", sum/NR }' z_exp/1222/10B_result.txt >> z_exp/1222/total_result.txt &
awk '{ sum = sum+$4-$1 } END { if(NR>0) printf"%d\n", sum/NR }' z_exp/1222/100B_result.txt >> z_exp/1222/total_result.txt &
awk '{ sum = sum+$4-$1 } END { if(NR>0) printf"%d\n", sum/NR }' z_exp/1222/1KB_result.txt >> z_exp/1222/total_result.txt &
awk '{ sum = sum+$4-$1 } END { if(NR>0) printf"%d\n", sum/NR }' z_exp/1222/10KB_result.txt >> z_exp/1222/total_result.txt &
awk '{ sum = sum+$4-$1 } END { if(NR>0) printf"%d\n", sum/NR }' z_exp/1222/100KB_result.txt >> z_exp/1222/total_result.txt &
awk '{ sum = sum+$4-$1 } END { if(NR>0) printf"%d\n", sum/NR }' z_exp/1222/1MB_result.txt >> z_exp/1222/total_result.txt &

sleep 1

echo "Done!"