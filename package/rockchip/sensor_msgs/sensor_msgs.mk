SENSOR_MSGS_VERSION = 1.12.6
SENSOR_MSGS_SITE = https://github.com/ros/common_msgs/archive
SENSOR_MSGS_SOURCE = $(SENSOR_MSGS_VERSION).tar.gz
SENSOR_MSGS_SUBDIR = sensor_msgs
SENSOR_MSGS_INSTALL_STAGING = YES

SENSOR_MSGS_DEPENDENCIES = host-catkin geometry_msgs message-generation std-msgs

SENSOR_MSGS_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'

$(eval $(cmake-package))
