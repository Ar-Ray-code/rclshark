#!/bin/bash
ROS2_WS='/.service_ws'

source /opt/ros/foxy/setup.bash
source $ROS2_WS/install/local_setup.bash

IP_NAME=`ip -4 a | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127 | tr -d .`
while [ -z ${IP_NAME} ]; do
	IP_NAME=`ip -4 a | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v 127 | tr -d .`
	sleep 2
done

python3 $ROS2_WS/src/rclshark/rclshark/scripts/rclshark.py
wait
