CONSOLE_BRIDGE_VERSION = 0.4.0
CONSOLE_BRIDGE_SITE = https://github.com/ros/console_bridge/archive
CONSOLE_BRIDGE_SOURCE = $(CONSOLE_BRIDGE_VERSION).tar.gz
CONSOLE_BRIDGE_INSTALL_STAGING = YES

$(eval $(cmake-package))
