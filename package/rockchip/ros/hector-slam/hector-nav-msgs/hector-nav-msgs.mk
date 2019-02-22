HECTOR_NAV_MSGS_VERSION = 0.3.4
HECTOR_NAV_MSGS_SITE = https://github.com/tu-darmstadt-ros-pkg/hector_slam/archive
HECTOR_NAV_MSGS_SOURCE = $(HECTOR_NAV_MSGS_VERSION).tar.gz
HECTOR_NAV_MSGS_SUBDIR = hector_nav_msgs

HECTOR_NAV_MSGS_DEPENDENCIES = nav-msgs geometry-msgs message-generation

$(eval $(catkin-package))
