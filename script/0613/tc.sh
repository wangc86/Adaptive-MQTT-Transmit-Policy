#!/bin/bash
freqency=5
total_c=20

for i in $(seq 1 $total_c); do

echo "Network in a <normal> state...."
sudo tc qdisc del dev enp0s31f6 root

sleep 20

echo "Network in a <unstable> state...."
sudo tc qdisc add dev enp0s31f6 root tbf rate 100Kbit burst 200Kbit latency 200ms

sleep 25

done

sudo tc qdisc del dev enp0s31f6 root
read -p "Finish <Network control> and press any key to quit... " -n1 -s