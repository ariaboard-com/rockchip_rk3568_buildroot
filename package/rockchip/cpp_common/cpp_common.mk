CPP_COMMON_VERSION = 0.6.11
CPP_COMMON_SITE = https://github.com/ros/roscpp_core/archive
CPP_COMMON_SOURCE = $(ROSCPP_CORE_VERSION).tar.gz
CPP_COMMON_SUBDIR = cpp_common
CPP_COMMON_INSTALL_STAGING = YES
CPP_COMMON_DEPENDENCIES += catkin console-bridge boost

CPP_COMMON_CONF_OPTS += -DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' -DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'

$(eval $(cmake-package))
