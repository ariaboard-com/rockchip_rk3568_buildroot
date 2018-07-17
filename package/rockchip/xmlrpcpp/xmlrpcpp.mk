XMLRPCPP_VERSION = 1.14.2
XMLRPCPP_SITE = https://github.com/ros/ros_comm/archive
XMLRPCPP_SOURCE = $(XMLRPCPP_VERSION).tar.gz
XMLRPCPP_SUBDIR = utilities/xmlrpcpp
XMLRPCPP_INSTALL_STAGING = YES

XMLRPCPP_DEPENDENCIES = host-catkin cpp_common rostime gtest

XMLRPCPP_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'

$(eval $(cmake-package))
