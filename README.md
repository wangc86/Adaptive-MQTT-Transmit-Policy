Adaptive-MQTT-Transmit-Policy
=================
This project is a new transmit policy which design for MQTT communication protocol.
The new design is implement on mosuqitto, an open source MQTT implementation.
Excepct the broker, you can use implementation of MQTT to run your client.

## Installing on Linux
Download the whole file and run it by make
```
make
```

## Quick start
Run the Broker
```ruby
./src/mosquitto -c mosquitto.conf -v
```
Run the Subscriber
```ruby
./client/mosquitto_sub -t latency -t topic -p port_number -h host_ip -q 1 -i ==Sub==
```
Run the Publisher
```ruby
./client/mosquitto_pub -t topic -m "Message here~~~~~~~~~~~~~~~~~~~~~~~~" -p port_number -h host_ip -q 1 -i ==Pub==

```
You also need to run the Latency Packet Sender to triggle this transmit policy
```ruby
./client/mosquitto_pub -t latency -m "this is a latency packet" -p port_number -h host_ip --repeat 200 --repeat-delay 10 -q 1 -i ==Lat_sender==

```
##About Timestamp
Open timestmp by add the code in [include/lib/mqtt_protocol.h](https://github.com/maggie62755/Adaptive-MQTT-Transmit-Policy/blob/main/include/mqtt_protocol.h)
```ruby
#define WITH_TIMESTAMP
```

## Eclipse Mosquitto
Mosquitto is an open source implementation of a server for version 5.0, 3.1.1,
and 3.1 of the MQTT protocol. It also includes a C and C++ client library, and
the `mosquitto_pub` and `mosquitto_sub` utilities for publishing and
subscribing.

## Links 
-Mosquitto Github: <https://github.com/eclipse/mosquitto>
- MQTT v3.1.1 standard: <https://docs.oasis-open.org/mqtt/mqtt/v3.1.1/mqtt-v3.1.1.html>
- MQTT v5.0 standard: <https://docs.oasis-open.org/mqtt/mqtt/v5.0/mqtt-v5.0.html>


