################################################################################
#
# internal-storage
#
################################################################################

INTERNAL_STORAGE_VERSION = 0.0.1
INTERNAL_STORAGE_SITE = $(TOPDIR)/package/rockchip/internal-storage
INTERNAL_STORAGE_SITE_METHOD = local

define INTERNAL_STORAGE_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/61-internal-storage.rules $(TARGET_DIR)/lib/udev/rules.d/
	$(INSTALL) -m 0755 -D $(@D)/S30mount $(TARGET_DIR)/etc/init.d/
	mkdir -p $(TARGET_DIR)/oem $(TARGET_DIR)/userdata
	cd $(TARGET_DIR) && ln -s userdata data && cd -

endef

$(eval $(generic-package))
