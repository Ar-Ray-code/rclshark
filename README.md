# rclshark

Monitors the status of computers on a network using the DDS function of ROS2.

## Requirements

- ROS2 Foxy
- Python
  - psutil
  - netifaces

## Installation (Startup Automatically )

```bash
$ source /opt/ros/foxy/setup.bash
$ mkdir -p ~/ros2_ws/src
$ cd ~/ros2_ws/src
$ git clone https://github.com/Ar-Ray-code/rclshark.git
$ cd ~/ros2_ws/
$ colcon build --symlink-install
$ cd ~/ros2_ws/src/rclshark/rclshark/
$ sudo bash install.bash
$ sudo reboot
```

## Installation (Startup manually)

```bash
$ source /opt/ros/foxy/setup.bash
$ mkdir -p ~/ros2_ws/src
$ cd ~/ros2_ws/src
$ git clone https://github.com/Ar-Ray-code/rclshark.git
$ cd ~/ros2_ws/
$ colcon build --symlink-install
$ source ~/ros2_ws/install/local_setup.bash
$ ros2 run rclshark rclshark
```

## uninstall

```bash
$ sudo bash ~/ros2_ws/src/rclshark/rclshark/install.bash uninstall
```

## About writer

- Ar-Ray : Japanese student.
- Blog (Japanese) : https://ar-ray.hatenablog.com/
- Twitter : https://twitter.com/Ray255Ar

