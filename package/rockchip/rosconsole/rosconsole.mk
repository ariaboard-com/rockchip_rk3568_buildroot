ROSCONSOLE_VERSION = 1.13.7
ROSCONSOLE_SOURCE = $(ROSCONSOLE_VERSION).tar.gz
ROSCONSOLE_SITE = https://github.com/ros/rosconsole/archive
ROSCONSOLE_INSTALL_STAGING = YES

ROSCONSOLE_DEPENDENCIES = \
	host-catkin cpp_common rostime rosunit boost

ROSCONSOLE_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'

$(eval $(cmake-package))
