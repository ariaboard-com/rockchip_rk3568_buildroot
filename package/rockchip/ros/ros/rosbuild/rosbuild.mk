#default to KINETIC
ROSBUILD_VERSION = 1.14.4

ifeq ($(BR2_PACKAGE_ROS_INDIGO),y)
ROSBUILD_VERSION = 1.11.14
endif

ROSBUILD_SOURCE = $(ROSBUILD_VERSION).tar.gz
ROSBUILD_SITE = https://github.com/ros/ros/archive
ROSBUILD_SUBDIR = core/rosbuild

$(eval $(catkin-package))
