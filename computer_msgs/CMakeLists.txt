cmake_minimum_required(VERSION 3.5)
project(computer_msgs)

set(CMAKE_CXX_STANDARD 17)

find_package(ament_cmake REQUIRED)
find_package(rosidl_default_generators REQUIRED)
find_package(std_msgs REQUIRED)

rosidl_generate_interfaces(${PROJECT_NAME}
  "msg/PcStatus.msg"
  # "srv/PcStatusSrv.srv"
)

ament_export_dependencies(rosidl_default_runtime)

ament_package()
