#!/bin/bash

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
broker_host="35.173.107.238"
file_dest="z_exp/1129/1206-3/"
# broker_host="localhost"

file_name_S="1KB.txt"
file_name_L="1MB.txt"
run_time="15m"

echo "< The experience with $1 publisher and $2 subscriber >"
sleep 1

# echo "Starting the broker.."
# ./src/mosquitto -c ./mosquitto.conf > z_exp/1117/broker.out &
# sleep 1

echo "Starting the subscriber.."
for i in $(seq 1 $N_sub); do
    ./client/mosquitto_sub -h $broker_host -p $port_num -t topic -q $QoS -i SUB$i 2>> ${file_dest}bro_to_sub$i.out >/dev/null &  
    sleep 0.1
done

for i in $(seq $((N_sub)) $((N_sub*2)) ); do
    ./client/mosquitto_sub -h $broker_host -p $port_num -t topic_l -q $QoS -i SUB$((i+1)) 2>> ${file_dest}bro_to_sub$((i+1)).out >/dev/null &  
    sleep 0.1
done
echo "Finished starting all subscribers"
read -p "Press any key to continue... " -n1 -s

sleep 1

echo "Starting the publisher(s).."
# for i in $(seq 1 $N_pub); do
#     ./client/mosquitto_pub -h $broker_host -p $port_num -t topic -m hi -q $QoS -i PUB$i
#     sleep 1
# done

# Starting publishers
for i in $(seq 1 $N_pub); do
    ./1108pub.sh $broker_host $port_num $file_name_S $QoS &
    sleep 0.1
    ./1108pub2.sh $broker_host $port_num $file_name_L $QoS &
    sleep 0.3
done
echo "Finished starting all publishers"

# run time
sleep $run_time

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
    awk '{sum+=($4-$1)} END {printf "<Average end2end = %d us>\n", sum/NR}' ${file_dest}bro_to_sub$i.out
    awk '{sum+=($3-$2)} END {printf "<Average in bro = %d us>\n", sum/NR}' ${file_dest}bro_to_sub$i.out
    awk '{sum+=($4-$1)} END {printf "%d\n", sum/NR }' ${file_dest}bro_to_sub$i.out >> ${file_dest}result_end2end.txt
    awk '{sum+=($3-$2)} END {printf "%d\n", sum/NR }' ${file_dest}bro_to_sub$i.out >> ${file_dest}result_inBro.txt
    mv ${file_dest}bro_to_sub$i.out ${file_dest}bro_to_sub$i.out.prev
    
done
sleep 1

mv ${file_dest}result_end2end.txt ${file_dest}result_end2end.txt.prev
mv ${file_dest}result_inBro.txt ${file_dest}result_inBro.txt.prev
mv ${file_dest}pub.out ${file_dest}pub.out.prev
mv ${file_dest}pubL.out ${file_dest}pubL.out.prev

printf "N_pub=${N_pub}
N_sub=${N_sub}
QoS=${QoS}
port_num=${port_num}
broker_host=${broker_host}
file_name_S=${file_name_S}
file_name_L=${file_name_L}
data transfer interval (small): 0.5 s/packet
data transfer interval (large): 5 s/packet\n
Run time: ${run_time}" > ${file_dest}exp.txt

echo "Done!"