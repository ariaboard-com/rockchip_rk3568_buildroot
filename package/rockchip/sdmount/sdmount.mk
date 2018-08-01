################################################################################
#
# sdmount
#
################################################################################

SDMOUNT_VERSION = 0.0.1
SDMOUNT_SITE = $(TOPDIR)/package/rockchip/sdmount
SDMOUNT_SITE_METHOD = local
define SDMOUNT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/61-sd-cards-auto-mount.rules $(TARGET_DIR)/lib/udev/rules.d/
endef

$(eval $(generic-package))
