################################################################################
#
# usbhost
#
################################################################################

USBHOST_VERSION = 0.0.1
USBHOST_SITE = $(TOPDIR)/package/rockchip/usbhost
USBHOST_SITE_METHOD = local

define USBHOST_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/61-usb-disk-auto-mount.rules $(TARGET_DIR)/lib/udev/rules.d/

endef

$(eval $(generic-package))
