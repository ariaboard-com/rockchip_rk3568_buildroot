################################################################################
#
# rktoolkit
#
################################################################################

RKTOOLKIT_VERSION = master
RKTOOLKIT_SITE = $(TOPDIR)/../external/rktoolkit
RKTOOLKIT_SITE_METHOD = local
RKTOOLKIT_LICENSE_FILES = LICENSE
RKTOOLKIT_LICENSE = Apache V2.0

define RKTOOLKIT_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) $(@D)/io.c -o $(@D)/io
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) $(@D)/update.c $(@D)/update_recv/update_recv.c -I$(@D)/update_recv/ -o $(@D)/update
endef

define RKTOOLKIT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/io $(TARGET_DIR)/usr/bin/io
	$(INSTALL) -D -m 755 $(@D)/update $(TARGET_DIR)/usr/bin/update
endef

$(eval $(generic-package))
