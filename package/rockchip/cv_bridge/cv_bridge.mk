CV_BRIDGE_VERSION = 1.12.8
CV_BRIDGE_SITE = https://github.com/ros-perception/vision_opencv/archive
CV_BRIDGE_SOURCE = $(CV_BRIDGE_VERSION).tar.gz
CV_BRIDGE_SUBDIR = cv_bridge

CV_BRIDGE_DEPENDENCIES = host-catkin rosconsole sensor_msgs boost opencv3 host-python-numpy gtest

CV_BRIDGE_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'

$(eval $(cmake-package))
