STD_MSGS_VERSION = 0.5.11
STD_MSGS_SITE = https://github.com/ros/std_msgs/archive
STD_MSGS_SOURCE = $(STD_MSGS_VERSION).tar.gz
STD_MSGS_INSTALL_STAGING = YES

STD_MSGS_DEPENDENCIES = host-python-empy host-python-em host-catkin message-generation message-runtime

STD_MSGS_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'

$(eval $(cmake-package))

