cmake_minimum_required(VERSION 3.5)

project(rclsharkc)

# Default to C11
if(NOT CMAKE_C_STANDARD)
  set(CMAKE_C_STANDARD 11)
endif()

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  add_compile_options(-Wall -Wextra -Wpedantic)
endif()

set(CMAKE_VERBOSE_MAKEFILE ON)

find_package(ament_cmake_ros REQUIRED)
find_package(rcl REQUIRED)
find_package(rclc REQUIRED)
find_package(computer_msgs REQUIRED)

# include_directories(include)

add_executable(rclshark src/rclshark_light.c)
ament_target_dependencies(rclshark rcl rclc computer_msgs)

install(TARGETS
  rclshark
  DESTINATION lib/${PROJECT_NAME}
)

ament_package()
