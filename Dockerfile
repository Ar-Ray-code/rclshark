# This is an auto generated Dockerfile for ros:ros-base
# generated from docker_images_ros2/create_ros_image.Dockerfile.em
FROM ros:foxy-ros-core-focal

ENV ROS_DISTRO=foxy

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    git \
    wget \
    python3-colcon-common-extensions \
    python3-colcon-mixin \
    python3-rosdep \
    python3-vcstool \
    && rm -rf /var/lib/apt/lists/*

# bootstrap rosdep
RUN rosdep init && \
  rosdep update --rosdistro $ROS_DISTRO

# setup colcon mixin and metadata
RUN colcon mixin add default \
      https://raw.githubusercontent.com/colcon/colcon-mixin-repository/master/index.yaml && \
    colcon mixin update && \
    colcon metadata add default \
      https://raw.githubusercontent.com/colcon/colcon-metadata-repository/master/index.yaml && \
    colcon metadata update

# install ros2 packages
RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-foxy-ros-base=0.9.2-1* \
    && rm -rf /var/lib/apt/lists/*

# RCLSHARK SETUP ===============================================================
## setup rclshark env
ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}

ENV TARGET_DIR='rclshark'
ENV INSTALL_DIR='/opt'
ENV COMPUTER_MSGS_VERSION='v1.0.0'
ENV RCLSHARK_WS=${INSTALL_DIR}/${TARGET_DIR}/${TARGET_DIR}'_ws'

## apt install tools
RUN apt-get -y update && apt-get -y upgrade && apt-get install -y \
    supervisor \
    iproute2 \
    python3-psutil \
    && rm -rf /var/lib/apt/lists/*

## git clone rclshark
RUN git clone --recursive https://github.com/Ar-Ray-code/rclshark.git ${RCLSHARK_WS}/src
RUN mv ${RCLSHARK_WS}/src/rclshark/rclshark/ ${RCLSHARK_WS}/src/rclshark/
## colcon build
RUN . ${ROS_ROOT}/setup.sh && cd ${RCLSHARK_WS} && colcon build --symlink-install
RUN ${RCLSHARK_WS}/src/rclshark/supervisor/install_docker.sh

## setup ros_env
RUN wget https://raw.githubusercontent.com/Ar-Ray-code/setup_ros_env/master/ros2_init.bash

## setup supervisord
RUN cp ${RCLSHARK_WS}/src/rclshark/supervisor/rclshark_supervisor.conf /etc/supervisor/conf.d/
RUN echo "supervisord &" >> ~/.bashrc