# rclshark:turtle::shark:

Monitor the status of computers on a network using the DDS function of ROS2.

<img src="images_for_readme/rclshark_swim.png" alt="rclshark_swim" style="zoom: 33%;" />

## Requirements

- ROS2 foxy
- Python 3.8 or later

## RUN rclshark


### Usage 1 : Run as ROS2 RUN

```bash
$ source /opt/ros/foxy/setup.bash
$ mkdir -p ~/ros2_ws/src
$ cd ~/ros2_ws/src
$ git clone --recursive https://github.com/Ar-Ray-code/rclshark.git
$ cd ~/ros2_ws/
$ colcon build --symlink-install
$ source ~/ros2_ws/install/local_setup.bash
$ ros2 run rclshark rclshark
```

### Usage 2 : Back-end installation (systemd)

#### Installation (Startup Automatically)

In case of`$ROS_DISTRO=foxy`,

```bash
$ git clone https://github.com/Ar-Ray-code/rclshark.git
$ sudo bash rclshark/rclshark/install.bash foxy
```

If you want to enable rclshark immediately, run at CUI (= multi-user-target) `$ sudo systemctl start rclshark.service`.

#### uninstall

```bash
$ sudo bash ~/ros2_ws/src/rclshark/rclshark/install.bash uninstall
```

### Usage 3 : Docker

```text
$ docker build https://github.com/Ar-Ray-code/rclshark.git#main --tag rclshark:local
```

RUN docker container
```bash
$ docker run -it rclshark /bin/bash
```



## rclshark-smi:shark:

You can use rclshark to check the hardware status of multiple computers. You don't even need to bother opening htop. Good for you! :blush:




## About writer :turtle:

- Ar-Ray : Japanese student.
- Blog (Japanese) : https://ar-ray.hatenablog.com/
- Twitter : https://twitter.com/Ray255Ar

