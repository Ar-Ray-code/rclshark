# generated from ament/cmake/core/templates/nameConfig.cmake.in

# prevent multiple inclusion
if(_rclsharkc_CONFIG_INCLUDED)
  # ensure to keep the found flag the same
  if(NOT DEFINED rclsharkc_FOUND)
    # explicitly set it to FALSE, otherwise CMake will set it to TRUE
    set(rclsharkc_FOUND FALSE)
  elseif(NOT rclsharkc_FOUND)
    # use separate condition to avoid uninitialized variable warning
    set(rclsharkc_FOUND FALSE)
  endif()
  return()
endif()
set(_rclsharkc_CONFIG_INCLUDED TRUE)

# output package information
if(NOT rclsharkc_FIND_QUIETLY)
  message(STATUS "Found rclsharkc: 1.0.1 (${rclsharkc_DIR})")
endif()

# warn when using a deprecated package
if(NOT "" STREQUAL "")
  set(_msg "Package 'rclsharkc' is deprecated")
  # append custom deprecation text if available
  if(NOT "" STREQUAL "TRUE")
    set(_msg "${_msg} ()")
  endif()
  # optionally quiet the deprecation message
  if(NOT ${rclsharkc_DEPRECATED_QUIET})
    message(DEPRECATION "${_msg}")
  endif()
endif()

# flag package as ament-based to distinguish it after being find_package()-ed
set(rclsharkc_FOUND_AMENT_PACKAGE TRUE)

# include all config extra files
set(_extras "")
foreach(_extra ${_extras})
  include("${rclsharkc_DIR}/${_extra}")
endforeach()
