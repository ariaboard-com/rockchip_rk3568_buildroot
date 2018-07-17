ROSCPP_VERSION = 1.14.2
ROSCPP_SOURCE = $(ROSCPP_VERSION).tar.gz
ROSCPP_SITE = https://github.com/ros/ros_comm/archive
ROSCPP_SUBDIR = clients/roscpp
ROSCPP_INSTALL_STAGING = YES

ROSCPP_DEPENDENCIES = host-catkin cpp_common message-generation \
		      rosconsole roscpp_serialization roscpp_traits \
		      rosgraph_msgs rostime std-msgs xmlrpcpp



ROSCPP_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'

$(eval $(cmake-package))
