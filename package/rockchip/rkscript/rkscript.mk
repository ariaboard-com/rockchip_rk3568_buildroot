################################################################################
#
# rkscript
#
################################################################################

RKSCRIPT_SITE = $(TOPDIR)/../external/rkscript
RKSCRIPT_SITE_METHOD = local
RKSCRIPT_USB_CONFIG_FILE = $(TARGET_DIR)/etc/init.d/.usb_config

define RKSCRIPT_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/61-partition-init.rules $(TARGET_DIR)/lib/udev/rules.d/
	$(INSTALL) -m 0644 -D $(@D)/61-sd-cards-auto-mount.rules $(TARGET_DIR)/lib/udev/rules.d/
	$(INSTALL) -m 0644 -D $(@D)/61-usbdevice.rules $(TARGET_DIR)/lib/udev/rules.d/
	$(INSTALL) -m 0644 -D $(@D)/fstab $(TARGET_DIR)/etc/
	$(INSTALL) -m 0755 -D $(@D)/glmarktest.sh $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 -D $(@D)/gstaudiotest.sh $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 -D $(@D)/gstmp3play.sh $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 -D $(@D)/gstmp4play.sh $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 -D $(@D)/gstvideoplay.sh $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 -D $(@D)/gstvideotest.sh $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 -D $(@D)/gstwavplay.sh $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 -D $(@D)/mp3play.sh $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 -D $(@D)/resize-helper $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 -D $(@D)/S21mountall.sh $(TARGET_DIR)/etc/init.d/
#	$(INSTALL) -m 0755 -D $(@D)/S22resize-disk $(TARGET_DIR)/etc/init.d/
	$(INSTALL) -m 0755 -D $(@D)/S50usbdevice $(TARGET_DIR)/etc/init.d/
	$(INSTALL) -m 0755 -D $(@D)/usbdevice $(TARGET_DIR)/usr/bin/
	$(INSTALL) -m 0755 -D $(@D)/waylandtest.sh $(TARGET_DIR)/usr/bin/
	echo -e "/dev/block/by-name/misc\t\t/misc\t\t\temmc\t\tdefaults\t\t0\t0" >> $(TARGET_DIR)/etc/fstab
	echo -e "/dev/block/by-name/oem\t\t/oem\t\t\t$$RK_OEM_FS_TYPE\t\tdefaults\t\t0\t2" >> $(TARGET_DIR)/etc/fstab
	echo -e "/dev/block/by-name/userdata\t/userdata\t\t$$RK_USERDATA_FS_TYPE\t\tdefaults\t\t0\t2" >> $(TARGET_DIR)/etc/fstab
	cd $(TARGET_DIR) && rm -rf oem userdata data mnt udisk sdcard && mkdir -p oem userdata mnt/sdcard && ln -s userdata data && ln -s media/usb0 udisk && ln -s mnt/sdcard sdcard && cd -
	if test -e $(RKSCRIPT_USB_CONFIG_FILE) ; then \
		rm $(RKSCRIPT_USB_CONFIG_FILE) ; \
	fi
	touch $(RKSCRIPT_USB_CONFIG_FILE)
endef

ifeq ($(BR2_PACKAGE_ANDROID_TOOLS_ADBD),y)
define RKSCRIPT_ADD_ADBD_CONFIG
	if test ! `grep usb_adb_en $(RKSCRIPT_USB_CONFIG_FILE)` ; then \
		echo usb_adb_en >> $(RKSCRIPT_USB_CONFIG_FILE) ; \
	fi
endef
RKSCRIPT_POST_INSTALL_TARGET_HOOKS += RKSCRIPT_ADD_ADBD_CONFIG
endif

ifeq ($(BR2_PACKAGE_MTP),y)
define RKSCRIPT_ADD_MTP_CONFIG
	if test ! `grep usb_mtp_en $(RKSCRIPT_USB_CONFIG_FILE)` ; then \
		echo usb_mtp_en >> $(RKSCRIPT_USB_CONFIG_FILE) ; \
	fi
endef
RKSCRIPT_POST_INSTALL_TARGET_HOOKS += RKSCRIPT_ADD_MTP_CONFIG
endif

ifeq ($(BR2_PACKAGE_USB_MASS_STORAGE),y)
define RKSCRIPT_ADD_UMS_CONFIG
	if test ! `grep usb_ums_en $(RKSCRIPT_USB_CONFIG_FILE)` ; then \
		echo usb_ums_en >> $(RKSCRIPT_USB_CONFIG_FILE) ; \
	fi
endef
RKSCRIPT_POST_INSTALL_TARGET_HOOKS += RKSCRIPT_ADD_UMS_CONFIG
endif

ifeq ($(BR2_PACKAGE_RKNPU_NTB),y)
define RKSCRIPT_ADD_NTB_CONFIG
	if test ! `grep usb_ntb_en $(RKSCRIPT_USB_CONFIG_FILE)` ; then \
		echo usb_ntb_en >> $(RKSCRIPT_USB_CONFIG_FILE) ; \
	fi
endef
RKSCRIPT_POST_INSTALL_TARGET_HOOKS += RKSCRIPT_ADD_NTB_CONFIG
endif

ifeq ($(BR2_PACKAGE_RKNPU_ACM),y)
define RKSCRIPT_ADD_ACM_CONFIG
	if test ! `grep usb_acm_en $(RKSCRIPT_USB_CONFIG_FILE)` ; then \
		echo usb_acm_en >> $(RKSCRIPT_USB_CONFIG_FILE) ; \
	fi
endef
RKSCRIPT_POST_INSTALL_TARGET_HOOKS += RKSCRIPT_ADD_ACM_CONFIG
endif

$(eval $(generic-package))
