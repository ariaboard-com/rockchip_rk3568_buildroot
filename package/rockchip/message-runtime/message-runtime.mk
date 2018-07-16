MESSAGE_RUNTIME_VERSION = 0.4.12
MESSAGE_RUNTIME_SOURCE = $(MESSAGE_RUNTIME_VERSION).tar.gz
MESSAGE_RUNTIME_SITE = https://github.com/ros/message_runtime/archive
MESSAGE_RUNTIME_INSTALL_STAGING = YES

MESSAGE_RUNTIME_DEPENDENCIES = host-catkin gencpp cpp_common roscpp_serialization

MESSAGE_RUNTIME_CONF_OPTS += \
	-DCMAKE_INSTALL_PREFIX:PATH='/opt/ros/kinetic' \
	-DCMAKE_PREFIX_PATH='$(TARGET_DIR)/opt/ros/kinetic/;$(HOST_DIR)/opt/ros/kinetic/'

$(eval $(cmake-package))
