################################################################################
#
# usbhost
#
################################################################################

USBHOST_VERSION = 0.0.1
USBHOST_SITE = $(TOPDIR)/package/rockchip/usbhost
USBHOST_SITE_METHOD = local

define USBHOST_INSTALL_TARGET_CMDS
	cd $(TARGET_DIR) && ln -s media/usb0 udisk && cd -
endef

$(eval $(generic-package))
