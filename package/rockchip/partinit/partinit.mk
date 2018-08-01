################################################################################
#
# partinit
#
################################################################################

PARTINIT_VERSION = 0.0.1
PARTINIT_SITE = $(TOPDIR)/package/rockchip/partinit
PARTINIT_SITE_METHOD = local

define PARTINIT_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/partinit $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 -D $(@D)/S10part $(TARGET_DIR)/etc/init.d/
endef

$(eval $(generic-package))
