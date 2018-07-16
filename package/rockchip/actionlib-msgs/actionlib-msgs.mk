ACTIONLIB_MSGS_VERSION = 1.12.6
ACTIONLIB_MSGS_SOURCE = $(ACTIONLIB_MSGS_VERSION).tar.gz
ACTIONLIB_MSGS_SITE = https://github.com/ros/common_msgs/archive
ACTIONLIB_MSGS_SUBDIR = actionlib_msgs
ACTIONLIB_MSGS_INSTALL_STAGING = YES

ACTIONLIB_MSGS_DEPENDENCIES = \
	host-catkin cpp_common roscpp_serialization \
	message-generation message-runtime std-msgs

ACTIONLIB_MSGS_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'

$(eval $(cmake-package))
