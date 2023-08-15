#!/bin/bash
freqency=5
total_c=50

for i in $(seq 1 $total_c); do

echo "Network in a <normal> state...."
sudo tc qdisc del dev eth0 root

sleep 20

echo "Network in a <unstable> state...."
# sudo tc qdisc add dev eht0 root tbf rate 100Kbit burst 200Kbit latency 200ms
sudo tc qdisc add dev eth0 root netem delay 100ms loss 20%

sleep 40

done

sudo tc qdisc del dev eht0 root
read -p "Finish <Network control> and press any key to quit... " -n1 -s