ACTIONLIB_VERSION = 1.11.14
ACTIONLIB_SOURCE = $(ACTIONLIB_VERSION).tar.gz
ACTIONLIB_SITE = https://github.com/ros/actionlib/archive
ACTIONLIB_INSTALL_STAGING = YES

ACTIONLIB_DEPENDENCIES = \
	host-catkin actionlib-msgs message-generation roscpp \
	rosunit std-msgs boost

ACTIONLIB_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'

ifeq ($(BR2_PACKAGE_ACTIONLIB_ENABLE_TEST),y)
ACTIONLIB_DEPENDENCIES += rostest
else
ACTIONLIB_CONF_OPTS += -DCATKIN_ENABLE_TESTING=False
endif

$(eval $(cmake-package))
