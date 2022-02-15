# rclshark​ :turtle::shark:

latest : [v2.0.0](https://github.com/Ar-Ray-code/rclshark2/releases/tag/v2.0.0)

[解説（Zenn）](https://zenn.dev/array/articles/9fd8cb5941bb94)

[紹介ページ（github.io）](https://ar-ray-code.github.io/05_rclshark/index.html)

Monitor the status of computers on a network using the DDS function of ROS2.

![rclshark-title](images_for_readme/rclshark-title.png)

## Documents

- Zenn : https://zenn.dev/array/articles/9fd8cb5941bb94
- DockerHub : https://hub.docker.com/r/ray255ar/rclshark
- Computer_msgs : https://github.com/Ar-Ray-code/computer_msgs
- rclshark-smi : https://github.com/Ar-Ray-code/rclshark-smi
- Website : https://ar-ray-code.github.io/05_rclshark

## Requirements

- ROS2 foxy-base [Installation](https://docs.ros.org/en/foxy/Installation.html)
- python3-colcon-common-extensions
- python3-psutil

## Support

- Ubuntu 20.04 (x86_64, Armv8) (Full support)
- <del>Raspberry Pi OS (aarch64) (Full support)
- <del>Windows 11 (x86_64) (rclshark-smi only)



## 1. rclshark​ :turtle: :shark:

Repository : https://github.com/Ar-Ray-code/rclshark

rclshark is an IP address display system that takes advantage of the DDS publishing nature of the ros2 node to the local network, and can recognize any device with ROS2 installed.
rclshark is also a service server, and has a function to Repositoryrt computer status using psutil.

<!-- See [rclshark-smi](https://github.com/Ar-Ray-code/rclshark#rclshark-smi-turtle-shark) for details. -->

---

### Installation

#### ROS-Foxy Installation

If you want to know how to install ROS-Foxy , please check [ROS2-Foxy-Installation](https://docs.ros.org/en/foxy/Installation/Ubuntu-Install-Debians.html).

```bash
# ROS-Foxy & depends Installation
sudo apt update && sudo apt install curl gnupg2 lsb-release python3-psutil python3-colcon-common-extensions build-essential git

sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt install ros-foxy-base python3-colcon-common-extensions python3-psutil g++ cmake
```

#### Using colcon build

```bash
mkdir ~/rclshark2_dir
cd ~/rclshark2_dir
git clone https://github.com/Ar-Ray-code/rclshark2
colcon build
source install/setup.bash
```

<!-- #### rclshark backend installtion -->

<!-- After installation, rclshark will start automatically.

```bash
#rclshark installation
git clone https://github.com/Ar-Ray-code/rclshark.git
sudo bash rclshark/rclshark/install.bash /opt/ros/foxy
```

If you want to enable rclshark immediately, run  `$ sudo systemctl start rclshark.service`. -->

<!-- #### Stop rclshark

```bash
sudo systemctl stop rclshark.service
```

#### Disable rclshark

```bash
sudo systemctl disable rclshark.service
``` -->

<!-- #### uninstall

```bash
sudo bash ~/ros2_ws/src/rclshark/rclshark/install.bash uninstall
``` -->

<!-- ### Docker

Docker container is used for viewer testing and communication load testing, but can also be used as a Raspberry Pi replacement for trial purposes.

```bash
docker pull ray255ar/rclshark
```

RUN docker container
```bash
docker run -it --rm rclshark
``` -->

---

### Quick check of rclshark

Since rclshark is an application that uses the basic functions of ROS2, you can find it with the ros2 command.

```bash
source ~/rclshark2_dir/install/setup.bash
ros2 topic list | grep rsk
> /rskc0a80b0f_ubuntu_i9rtx_pub
```

![](images_for_readme/rclshark_rostopic.png)


Now you can safely forget your IP address.:wink:

<!-- rosidl generate -o gen -t py -I$(ros2 pkg prefix --share std_msgs)/.. -->

## 2. rclshark-smi (v1.0.0)​ :turtle: :shark:

Repository : https://github.com/Ar-Ray-code/rclshark-smi

rclshark2 is not supported.

<!-- 
You can use rclshark to check the hardware status of multiple computers. You don't even need to bother opening htop. Good for you! :blush:

IP addresses are sorted in ascending order and are dynamically added and removed.

![rclshark-smi-docker](images_for_readme/rclshark-smi-docker.png)

###  Installation 

rclshark-smi is installed with rclshark. It can also be built and used as a regular ROS2 package. `ros2 run rclshark_smi rclshark_smi`

```bash
## Install
git clone --recursive https://github.com/Ar-Ray-code/rclshark.git
sudo bash rclshark/rclshark/install.bash /opt/ros/foxy
## Run rclshark-smi
rclshark-smi
``` -->

<!-- ## Demo (v1.0.0)

[YouTube](https://youtu.be/SC5XEYPq4D0)

![](images_for_readme/rclshark-demo.gif)

- rclshark-smi v1.0.2 limits the display to only one time. -->



<!-- # Extended packages :shark::snake:

## 3. rclshark-bridge

Repository : https://github.com/Ar-Ray-code/rclshark-bridge

rclshark-bridge performs CSV conversion of data in order to use rclshark on other platforms.

## 4. rclshark-Web

Repository : https://github.com/Ar-Ray-code/rclshark-web

rclshark-web is data viewer

#### Installation

Before creating the web server, please set up the Python dependency module and ROS2 environment.

```bash
git clone https://github.com/Ar-Ray-code/rclshark-web.git
git clone https://github.com/Ar-Ray-code/rclshark-bridge.git
pip3 install -r rclshark-web/requirements.txt

source /opt/ros/foxy/setup.bash
python3 rclshark-bridge/rclshark_bridge/rclshark_bridge.py &
python3 rclshark-web/flask_main.py
```

Access `http://localhost:5000`

[Web-GUI Demo Page](https://ar-ray-code.github.io/05_rclshark/rclshark-web/templates/index.html)

![rclshark-web-gui](images_for_readme/rclshark-web-gui.png)
 -->


## About author

- author : [Ar-Ray](https://github.com/Ar-Ray-code)
- [Twitter](https://twitter.com/Ray255Ar)

 <!-- ![](images_for_readme/author_description.png) -->

