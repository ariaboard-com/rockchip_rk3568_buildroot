MESSAGE_GENERATION_VERSION = 0.2.10
MESSAGE_GENERATION_SOURCE = $(MESSAGE_GENERATION_VERSION).tar.gz
MESSAGE_GENERATION_SITE = https://github.com/ros/message_generation/archive
MESSAGE_GENERATION_INSTALL_STAGING = YES

MESSAGE_GENERATION_DEPENDENCIES = host-catkin gencpp genlisp genpy

MESSAGE_GENERATION_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'

$(eval $(cmake-package))
