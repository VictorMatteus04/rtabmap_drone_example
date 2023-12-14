#!/bin/bash

source /opt/ros/noetic/setup.bash
source /usr/local/px4/Tools/setup_gazebo.bash /usr/local/px4 /usr/local/px4/build/px4_sitl_default
export ROS_PACKAGE_PATH=\$ROS_PACKAGE_PATH:/usr/local/px4:/usr/local/px4/Tools/sitl_gazebo
export GAZEBO_MODEL_PATH=\$GAZEBO_MODEL_PATH:/opt/ros/noetic/share/rtabmap_drone_example/models
export GAZEBO_MODEL_PATH=\$GAZEBO_MODEL_PATH:/opt/ros/noetic/share/realsense_gazebo_plugin/models

exec $@