PLUGINLIB_VERSION = 1.10.6

PLUGINLIB_SOURCE = $(PLUGINLIB_VERSION).tar.gz
PLUGINLIB_SITE = https://github.com/ros/pluginlib/archive

PLUGINLIB_DEPENDENCIES = boost class-loader rosconsole roslib tinyxml

$(eval $(catkin-package))
