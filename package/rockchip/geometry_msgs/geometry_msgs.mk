GEOMETRY_MSGS_VERSION = 1.12.6
GEOMETRY_MSGS_SITE = https://github.com/ros/common_msgs/archive
GEOMETRY_MSGS_SOURCE = $(GEOMETRY_MSGS_VERSION).tar.gz
GEOMETRY_MSGS_SUBDIR = geometry_msgs
GEOMETRY_MSGS_INSTALL_STAGING = YES

GEOMETRY_MSGS_DEPENDENCIES += host-catkin message-generation std-msgs

GEOMETRY_MSGS_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'

$(eval $(cmake-package))
