################################################################################
#
# usbdevice
#
################################################################################

USBDEVICE_VERSION = 0.0.1
USBDEVICE_SITE = $(TOPDIR)/package/rockchip/usbdevice
USBDEVICE_SITE_METHOD = local
USBDEVICE_LICENSE = Apache V2.0
USBDEVICE_LICENSE_FILES = NOTICE

define USBDEVICE_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/S50usbdevice $(TARGET_DIR)/etc/init.d/
	$(INSTALL) -m 0644 -D $(@D)/61-usbdevice.rules $(TARGET_DIR)/lib/udev/rules.d/
	$(INSTALL) -m 0755 -D $(@D)/usbdevice $(TARGET_DIR)/usr/bin/

endef

$(eval $(generic-package))
