GENPY_VERSION = 0.5.10
GENPY_SITE = https://github.com/ros/genpy/archive
GENPY_SOURCE = $(GENPY_VERSION).tar.gz
GENPY_INSTALL_STAGING = YES
GENPY_DEPENDENCIES = host-catkin genlisp genmsg

GENPY_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'

$(eval $(cmake-package))
