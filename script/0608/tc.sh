#!/bin/bash
freqency=5
total_c=5

for i in $(seq 1 $total_c); do

echo "Network in a <normal> state....\n"
sudo tc qdisc del dev enp0s31f6 root

sleep 15

echo "Network in a unstable state....\n"
sudo tc qdisc add dev enp0s31f6 root tbf rate 100Kbit burst 200Kbit latency 100ms

sleep 15

done

sudo tc qdisc del dev enp0s31f6 root
read -p "Finish <Network control> and press any key to quit... " -n1 -s