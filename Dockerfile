# This is an auto generated Dockerfile for ros:ros-base
# generated from docker_images_ros2/create_ros_image.Dockerfile.em
FROM ros:foxy-ros-core-focal

ENV ROS_DISTRO=foxy
ENV ROS_ROOT=/opt/ros/${ROS_DISTRO}
ENV ROS_WS=/.service_ws

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

# =============
RUN apt-get -y update && apt-get -y upgrade && apt-get install -y supervisor iproute2 python3-psutil

RUN rm -rf ./${ROS_WS}/
RUN git clone --recursive https://github.com/Ar-Ray-code/rclshark.git ${ROS_WS}/src/rclshark

RUN . ${ROS_ROOT}/setup.sh && cd ${ROS_WS} && colcon build --symlink-install
RUN ${ROS_WS}/src/rclshark/rclshark/supervisor/install_docker.sh

RUN cp ${ROS_WS}/src/rclshark/rclshark/supervisor/rclshark_supervisor.conf /etc/supervisor/conf.d/
RUN wget https://raw.githubusercontent.com/Ar-Ray-code/setup_ros_env/master/ros2_init.bash
RUN echo "supervisord &" >> ~/.bashrc