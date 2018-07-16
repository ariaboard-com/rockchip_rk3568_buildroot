GENMSG_VERSION = 0.5.11
GENMSG_SITE = https://github.com/ros/genmsg/archive
GENMSG_SOURCE = $(GENMSG_VERSION).tar.gz
GENMSG_INSTALL_STAGING = YES
GENMSG_DEPENDENCIES += host-catkin

GENMSG_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH=$(HOST_DIR)/opt/ros/kinetic/

$(eval $(cmake-package))
