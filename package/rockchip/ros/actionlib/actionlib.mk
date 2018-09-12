ACTIONLIB_VERSION = 1.11.12
ACTIONLIB_SOURCE = $(ACTIONLIB_VERSION).tar.gz
ACTIONLIB_SITE = https://github.com/ros/actionlib/archive

ACTIONLIB_DEPENDENCIES = \
	actionlib-msgs roscpp boost
	#actionlib-msgs message-generation roscpp \
	#rosunit std-msgs

	#select BR2_PACKAGE_BOOST_THREAD
	#select BR2_PACKAGE_BOOST_CHRONO
	#select BR2_PACKAGE_BOOST_FILESYSTEM
	#select BR2_PACKAGE_BOOST_SIGNALS


ifeq ($(BR2_PACKAGE_ACTIONLIB_ENABLE_TEST),y)
ACTIONLIB_DEPENDENCIES += rostest
else
ACTIONLIB_CONF_OPTS += -DCATKIN_ENABLE_TESTING=False
endif

$(eval $(catkin-package))
