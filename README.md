Adaptive-MQTT-Transmit-Policy
=================
This project is a new transmission policy designed for the MQTT communication protocol.
The new design has been implemented on Eclipse Mosuqitto, an open source MQTT implementation.
Besides the broker, you can use this implementation of MQTT to run your client.

## Installing on Linux
Download the whole file and run it by make
```
make
```

## Quick start
Run the Broker
```
./src/mosquitto -c mosquitto.conf -v
```

Run the Subscriber (Subscriber should subscribe topic "latency" by QoS 1)

```
./client/mosquitto_sub -t latency -t topic -p port_number -h host_ip -q 1 -i [Sub]
```
Run the Publisher
```
./client/mosquitto_pub -t topic -m "Message here~~~~~~~~~~~~~~~~~~~~~~~~" -p port_number -h host_ip -q 1 -i [Pub]
```
You also need to run the Latency Packet Sender to triggle this transmit policy
```
./client/mosquitto_pub -t latency -m "this is a latency packet" -p port_number -h host_ip --repeat 200 --repeat-delay 10 -q 1 -i [Lat_sender]
```
## About config file
For the config file of the broker, there are something you can change for this project.
###

## About Timestamp
Open timestamp by add the code in [include/lib/mqtt_protocol.h](https://github.com/maggie62755/Adaptive-MQTT-Transmit-Policy/blob/main/include/mqtt_protocol.h)
```ruby
#define WITH_TIMESTAMP
```

## About Threshold
### threshold_s (unit: byte)
Setting by config file of the broker, for example:
```
threshold_s 300
```
The default value is 100, you can change the default at [src/conf.c #L207](https://github.com/maggie62755/Adaptive-MQTT-Transmit-Policy/blob/af2e91b6cd42c9d945e541132e5ceaa2f14cda5e/src/conf.c#L207).
### threshold_l (unit: us)
Fixed threshold_l is set by the subscriber with
```
--threshold_l [value]
```
Dynamic threshold_l is automatically adjust by the broker, by inserting the code in [include/lib/mqtt_protocol.h](https://github.com/maggie62755/Adaptive-MQTT-Transmit-Policy/blob/main/include/mqtt_protocol.h)
```ruby
#define WITH_A_THRESHOLD

```
## About msg_store_timeout
msg_store_timeout is the time that the message can stay in the storage, when it timeout, whatever the subscriber transfer mode, the broker will push the message to inflight.
Setting by config file of the broker, for example:
```
msg_store_timeout 30
```

## Special setting in CONNECT packet
If the subscriber want to use the design of this project, a special setting of the CONNECT packet is indeed. In CONNECT control flag bit 0, which is set to zero and reserve, is design to set to one if the subscriber want to use the design of this project, and it need to add the threshold_l value at the end of the payload of the CONNECT packet.

## Eclipse Mosquitto
Mosquitto is an open source implementation of a server for version 5.0, 3.1.1,
and 3.1 of the MQTT protocol. It also includes a C and C++ client library, and
the `mosquitto_pub` and `mosquitto_sub` utilities for publishing and
subscribing.

## Links 
-Mosquitto Github: <https://github.com/eclipse/mosquitto>
- MQTT v3.1.1 standard: <https://docs.oasis-open.org/mqtt/mqtt/v3.1.1/mqtt-v3.1.1.html>
- MQTT v5.0 standard: <https://docs.oasis-open.org/mqtt/mqtt/v5.0/mqtt-v5.0.html>

## Raw data from some experiments conducted at National Taiwan Normal University
See the folder __script__ for our experimental raw data

## Analytical simulations
Some additional latency simulation scripts can be found in folder __simulation__. They serve the purpose of testing with various message withholding policy.
