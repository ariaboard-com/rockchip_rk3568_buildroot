ROSUNIT_VERSION = 1.14.4
ROSUNIT_SOURCE = $(ROSUNIT_VERSION).tar.gz
ROSUNIT_SITE = https://github.com/ros/ros/archive
ROSUNIT_SUBDIR = tools/rosunit
ROSUNIT_INSTALL_STAGING = YES

ROSUNIT_DEPENDENCIES = host-catkin
ROSUNIT_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'

$(eval $(cmake-package))
