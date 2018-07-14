GENLISP_VERSION = 0.4.15
GENLISP_SITE = https://github.com/ros/genlisp/archive
GENLISP_SOURCE = $(GENLISP_VERSION).tar.gz
GENLISP_INSTALL_STAGING = YES

GENLISP_DEPENDENCIES = host-catkin gencpp

GENLISP_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'

$(eval $(cmake-package))
