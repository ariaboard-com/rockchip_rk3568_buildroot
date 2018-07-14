GENCPP_VERSION = 0.6.0
GENCPP_SITE = https://github.com/ros/gencpp/archive
GENCPP_SOURCE = $(GENCPP_VERSION).tar.gz
GENCPP_INSTALL_STAGING = YES

GENCPP_DEPENDENCIES = host-catkin genmsg

GENCPP_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'

$(eval $(cmake-package))
