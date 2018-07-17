ROSTEST_VERSION = 1.14.2
ROSTEST_SITE = https://github.com/ros/ros_comm/archive
ROSTEST_SOURCE = $(ROSTEST_VERSION).tar.gz
ROSTEST_SUBDIR = tools/rostest
ROSTEST_INSTALL_STAGING = YES

ROSTEST_DEPENDENCIES = host-catkin rosunit

ROSTEST_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/' \

$(eval $(cmake-package))
