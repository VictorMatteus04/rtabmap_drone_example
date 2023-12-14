FROM osrf/ros:noetic-desktop-full

#LABEL maintainer="user@email.com"
#LABEL version="0.1"

LABEL description="This is custom Docker Image for \
building PX4 with ROS/Gazebo compatibility for SITL."

RUN apt-get update && apt-get install -y \
	apt-utils \
	mesa-utils \
    python3-pip \
	git \
	xauth \
	wget \
	nano \
	python3-catkin-tools \
	python3-tk \
	python3-dbg \
	ros-noetic-mavros-msgs \
	ros-noetic-mavlink \
	ros-noetic-mavros \
	ros-noetic-mavros-extras \
	ros-noetic-rtabmap \
    ros-noetic-rtabmap-ros \
	ros-noetic-gazebo-dev \
    ros-noetic-geographic-msgs \
    ros-noetic-dwa-local-planner \
    ros-noetic-gazebo-ros \
    ros-noetic-gazebo-ros-pkgs \
    ros-noetic-gazebo-ros-control \
    ros-noetic-control-toolbox \
    ros-noetic-move-base \
    ros-noetic-xacro \
    ros-noetic-robot-state-publisher \
    libgeographic-dev \
    geographiclib-tools \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    && rm -rf /var/lib/apt/lists/

RUN pip3 install toml packaging jinja2 empy pyros-genmsg kconfiglib

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

WORKDIR /root/

RUN git clone https://github.com/PX4/PX4-Autopilot.git && \
    cd PX4-Autopilot && \
    git checkout v1.12.3 && \
    git submodule update --init --recursive && \
    make -j8 px4_sitl_default gazebo && \
    make px4_sitl_default install && \
    cd && \
    rm -rf PX4-Autopilot

RUN echo [""]

RUN source /ros_entrypoint.sh && \
    mkdir -p ~/catkin_ws/src && \
    cd ~/catkin_ws/src && \
    catkin_init_workspace && \
    git clone https://github.com/mavlink/mavros.git && \
    git clone https://github.com/Flying-Robots-LARC/realsense_gazebo_plugin.git && \
    cd mavros && \
    git checkout 1.9.0 && \
    ./mavros/scripts/install_geographiclib_datasets.sh && \
    cd ~/catkin_ws && \
    catkin_make -j8 -DCMAKE_INSTALL_PREFIX=/opt/ros/noetic install && \
    cd && \
    rm -rf ~/catkin_ws/devel ~/catkin_ws/build ~/catkin_ws/src/mavros ~/catkin_ws/src/realsense_gazebo_plugin

RUN echo [""]

COPY . /root/catkin_ws/src/rtabmap_drone_example

RUN source /ros_entrypoint.sh && \
    cd ~/catkin_ws && \
    catkin_make -j8 -DCMAKE_INSTALL_PREFIX=/opt/ros/noetic install && \
    cd && \
    rm -rf ~/catkin_ws

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES \
    ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES \
    ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

RUN echo "#!/bin/bash" >> /entrypoint.sh && \
    echo "set -e" >> /entrypoint.sh && \
    echo "source /opt/ros/noetic/setup.bash" >> /entrypoint.sh && \
    echo "source /usr/local/px4/Tools/setup_gazebo.bash /usr/local/px4 /usr/local/px4/build/px4_sitl_default" >> /entrypoint.sh && \
    echo "export ROS_PACKAGE_PATH=\$ROS_PACKAGE_PATH:/usr/local/px4:/usr/local/px4/Tools/sitl_gazebo" >> /entrypoint.sh && \
    echo "export GAZEBO_MODEL_PATH=\$GAZEBO_MODEL_PATH:/opt/ros/noetic/share/rtabmap_drone_example/models" >> /entrypoint.sh && \
    echo "export GAZEBO_MODEL_PATH=\$GAZEBO_MODEL_PATH:/opt/ros/noetic/share/realsense_gazebo_plugin/models" >> /entrypoint.sh && \
    echo "exec \"\$@\"" >> /entrypoint.sh && \
    chmod +x /entrypoint.sh
    
RUN apt-get update && \
 apt-get install ros-noetic-teleop-twist-keyboard -y

WORKDIR /worlds

RUN git clone https://github.com/Pequi-Mecanico-Home/mrs_gazebo_common_resources && \
    git clone https://github.com/Pequi-Mecanico-Home/Petrobras_Competition && \
    # Copy model files to Gazebo Directory
    cp -r /worlds/Petrobras_Competition/models /usr/share/gazebo-11/ && \
    cp -r /worlds/mrs_gazebo_common_resources/models /usr/share/gazebo-11/

CMD ["bash"]