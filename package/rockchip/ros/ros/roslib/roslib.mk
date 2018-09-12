#default to KINETIC
ROSLIB_VERSION = 1.14.4

ifeq ($(BR2_PACKAGE_ROS_INDIGO),y)
ROSLIB_VERSION = 1.11.14
endif

ROSLIB_SOURCE = $(ROSLIB_VERSION).tar.gz
ROSLIB_SITE = https://github.com/ros/ros/archive
ROSLIB_SUBDIR = core/roslib

ROSLIB_DEPENDENCIES = boost rospack

$(eval $(catkin-package))
