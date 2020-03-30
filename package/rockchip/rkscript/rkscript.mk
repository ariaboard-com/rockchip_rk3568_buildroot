################################################################################
#
# rkscript
#
################################################################################

RKSCRIPT_SITE = $(TOPDIR)/../external/rkscript
RKSCRIPT_SITE_METHOD = local
RKSCRIPT_LICENSE = Apache V2.0
RKSCRIPT_LICENSE_FILES = NOTICE
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
UMS_BLOCK_PATH = $(call qstrip,$(BR2_PACKAGE_USB_MASS_STORAGE_BLOCK))
UMS_BLOCK_SIZE = $(call qstrip,$(BR2_PACKAGE_USB_MASS_STORAGE_BLOCK_SIZE))
UMS_BLOCK_TYPE = $(call qstrip,$(BR2_PACKAGE_USB_MASS_STORAGE_BLOCK_TYPE))

ifeq ($(BR2_PACKAGE_USB_MASS_STORAGE_BLOCK_RO),y)
UMS_BLOCK_RO = y
else
UMS_BLOCK_RO = n
endif

ifeq ($(BR2_PACKAGE_USB_MASS_STORAGE_BLOCK_AUTO_MOUNT),y)
UMS_BLOCK_AUTO_MOUNT = y
else
UMS_BLOCK_AUTO_MOUNT = n
endif

define RKSCRIPT_ADD_UMS_CONFIG
	if test ! `grep usb_ums_en $(RKSCRIPT_USB_CONFIG_FILE)` ; then \
		echo usb_ums_en >> $(RKSCRIPT_USB_CONFIG_FILE) ; \
	fi

	if test ! `grep "ums_block=" $(RKSCRIPT_USB_CONFIG_FILE)` ; then \
		echo "ums_block=$(UMS_BLOCK_PATH)" >> $(RKSCRIPT_USB_CONFIG_FILE) ; \
	fi

	if test ! `grep ums_block_size $(RKSCRIPT_USB_CONFIG_FILE)` ; then \
		echo "ums_block_size=$(UMS_BLOCK_SIZE)" >> $(RKSCRIPT_USB_CONFIG_FILE) ; \
	fi

	[[ ! `grep ums_block_ro $(RKSCRIPT_USB_CONFIG_FILE)` && $(UMS_BLOCK_RO) = y ]] && \
		echo "ums_block_ro=on" >> $(RKSCRIPT_USB_CONFIG_FILE) || echo "ums is not read-only"

	[[ ! `grep ums_block_auto_mount $(RKSCRIPT_USB_CONFIG_FILE)` && $(UMS_BLOCK_AUTO_MOUNT) = y ]] && \
		echo "ums_block_auto_mount=on" >> $(RKSCRIPT_USB_CONFIG_FILE) || echo "disabled ums auto mount"

	if test ! `grep ums_block_type $(RKSCRIPT_USB_CONFIG_FILE)` ; then \
		echo "ums_block_type=$(UMS_BLOCK_TYPE)" >> $(RKSCRIPT_USB_CONFIG_FILE) ; \
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

ifeq ($(BR2_PACKAGE_USB_MODULE),y)
RKSCRIPT_USB_MODULE = $(call qstrip,$(BR2_PACKAGE_USB_MODULE_NAME))
define RKSCRIPT_ADD_USB_MODULE_SUPPORT
	find $(TOPDIR)/../kernel/drivers/phy/* -name "$(RKSCRIPT_USB_MODULE)" | \
	xargs -n1 -i cp {} $(TARGET_DIR)/system/lib/modules/

	$(SED) "/parameter_init/i\\	insmod \/system\/lib\/modules\/$(RKSCRIPT_USB_MODULE)" \
		$(TARGET_DIR)/etc/init.d/S50usbdevice
endef
RKSCRIPT_POST_INSTALL_TARGET_HOOKS += RKSCRIPT_ADD_USB_MODULE_SUPPORT
endif

$(eval $(generic-package))
