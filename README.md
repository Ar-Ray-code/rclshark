# rclshark​ :turtle::shark:

latest : [v1.0.2](https://github.com/Ar-Ray-code/rclshark/releases/tag/v1.0.2)

[解説（Zenn）](https://zenn.dev/array/articles/9fd8cb5941bb94)
[紹介ページ（github.io）](https://ar-ray-code.github.io/05_rclshark/index.html)

Monitor the status of computers on a network using the DDS function of ROS2.

開発者向けのツールで、リモートマシンへのSSHログインの際に必要なローカルIPアドレスを簡単に発見します。リモートマシンに対して拡張機能を追加し、CPU温度などのマシン内部の情報をログイン無しでモニタリングすることもできます。

rclsharkはセットアップされたデバイスに対してIPアドレス固定などのデバイスごとの面倒なセットアップ無しにIPアドレスの取得を行い、デバイスの状態を取得することができます。インストールも簡単で、組み込みコンピュータの新規開発のお供として役に立ちます。

<img src="images_for_readme/rclshark_swim.png" alt="rclshark_swim"  />

## Documents

- Zenn : https://zenn.dev/array/articles/9fd8cb5941bb94
- DockerHub : https://hub.docker.com/r/ray255ar/rclshark
- Computer_msgs : https://github.com/Ar-Ray-code/computer_msgs
- rclshark-smi : https://github.com/Ar-Ray-code/rclshark-smi

## Requirements

- ROS2 foxy-core [Installation](https://docs.ros.org/en/foxy/Installation.html)
- python3-colcon-common-extensions
- build-essential

## rclshark​ :turtle: :shark:

rclshark is an IP address display system that takes advantage of the DDS publishing nature of the ros2 node to the local network, and can recognize any device with ROS2 installed.
rclshark is also a service server, and has a function to report computer status using psutil.

See [rclshark-smi](https://github.com/Ar-Ray-code/rclshark#rclshark-smi-turtle-shark) for details.


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
$ git clone --recursive https://github.com/Ar-Ray-code/rclshark.git
$ sudo bash rclshark/rclshark/install.bash foxy
```

If you want to enable rclshark immediately, run at CUI (= multi-user-target) `$ sudo systemctl start rclshark.service`.

#### uninstall

```bash
$ sudo bash ~/ros2_ws/src/rclshark/rclshark/install.bash uninstall
```

### Usage 3 : Docker

```bash
$ docker pull ray255ar/rclshark
```

RUN docker container
```bash
$ docker run -it --rm rclshark:local
```

### Confirmation rclshark

Since rclshark is an application that uses the basic functions of ROS2, you can find it with the ros2 command.

```bash
## Confirmation rclshark 1
$ ros2 node list | grep ip_
> /ip_192.168.11.10_end
> /ip_192.168.11.22_end
## Confirmation rclshark 2
$ ros2 service list | grep endcb
> /ip_192.168.11.10_endcb
> /ip_192.168.11.22_endcb
```

Now you can safely forget your IP address.:wink:

## rclshark-smi​ :turtle: :shark:

You can use rclshark to check the hardware status of multiple computers. You don't even need to bother opening htop. Good for you! :blush:

IP addresses are sorted in ascending order and are dynamically added and removed. See Usage 2 for installing rclshark-smi. If you want to use only rclshark-smi, type `sudo systemctl disable rclshark.service`. to use only rclshark-smi.

![rclshark-smi-docker](images_for_readme/rclshark-smi-docker.png)

There are two ways to run.

### Usage 1 : Run as ROS2 RUN

```bash
$ source /opt/ros/foxy/setup.bash
$ mkdir -p ~/ros2_ws/src
$ cd ~/ros2_ws/src
$ git clone --recursive https://github.com/Ar-Ray-code/rclshark.git
$ cd ~/ros2_ws/
$ colcon build --symlink-install
$ source ~/ros2_ws/install/local_setup.bash
$ ros2 run rclshark-smi rclshark_smi.py
```

### Usage 2 : Run from `/usr/local/bin/rclshark-smi`

```bash
## Install
$ git clone https://github.com/Ar-Ray-code/rclshark.git
$ sudo bash rclshark/rclshark/install.bash foxy
$ sudo systemctl disable rclshark.service
## Run rclshark-smi
$ rclshark-smi
```

## Demo

[YouTube](https://youtu.be/SC5XEYPq4D0)

![](images_for_readme/rclshark-demo.gif)


### Operation method

- 'q'-> Enter : exit rclshark-smi

### Known Problems​ ​(rclshark-smi) :disappointed:

- If the rclshark process started using Docker is interrupted, rclshark-smi will freeze. In that case, rclshark-smi will exit as the Timeout after 5 seconds. Keep in mind that the same event can also happen with non-Docker rclshark.
- We are considering releasing a lightweight version of rclshark-smi that does not involve sending or receiving messages.


## About writer :turtle::shark:

- Ar-Ray : Japanese student.
- Blog (Japanese) : https://ar-ray.hatenablog.com/
- Twitter : https://twitter.com/Ray255Ar

