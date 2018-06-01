################################################################################
#
# update
#
################################################################################

UPDATE_LICENSE_FILES = NOTICE
UPDATE_LICENSE = Apache V2.0

define UPDATE_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		package/rockchip/update/update.c -o $(@D)/update
endef

define UPDATE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/update $(TARGET_DIR)/usr/bin/update
endef

$(eval $(generic-package))
