ROSGRAPH_MSGS_VERSION = 1.11.2
ROSGRAPH_MSGS_SITE = https://github.com/ros/ros_comm_msgs/archive
ROSGRAPH_MSGS_SOURCE = $(ROSGRAPH_MSGS_VERSION).tar.gz
ROSGRAPH_MSGS_SUBDIR = rosgraph_msgs
ROSGRAPH_MSGS_INSTALL_STAGING = YES

ROSGRAPH_MSGS_DEPENDENCIES = host-catkin message-generation std-msgs

ROSGRAPH_MSGS_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'

$(eval $(cmake-package))
