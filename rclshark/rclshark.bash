#!/bin/bash
HOME='/home/ubuntu'
ROS2_WS=$HOME'/ros2_ws'

source $HOME/.bashrc
source /opt/ros/foxy/setup.bash
source $ROS2_WS/install/local_setup.bash

python3 $ROS2_WS/src/rclshark/rclshark/scripts/rclshark.py
wait