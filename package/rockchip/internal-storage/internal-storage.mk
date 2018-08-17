################################################################################
#
# internal-storage
#
################################################################################

INTERNAL_STORAGE_VERSION = 0.0.1
INTERNAL_STORAGE_SITE = $(TOPDIR)/package/rockchip/internal-storage
INTERNAL_STORAGE_SITE_METHOD = local

define INTERNAL_STORAGE_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/fstab $(TARGET_DIR)/etc/
	echo -e "/dev/block/by-name/misc\t\t/misc\t\t\temmc\t\tdefaults\t\t0\t0" >> $(TARGET_DIR)/etc/fstab
	echo -e "/dev/block/by-name/oem\t\t/oem\t\t\t$$RK_OEM_FS_TYPE\t\tdefaults\t\t0\t0" >> $(TARGET_DIR)/etc/fstab
	echo -e "/dev/block/by-name/userdata\t/userdata\t\t$$RK_USERDATA_FS_TYPE\t\tdefaults\t\t0\t0" >> $(TARGET_DIR)/etc/fstab
	$(INSTALL) -m 0755 -D $(@D)/61-internal-storage.rules $(TARGET_DIR)/lib/udev/rules.d/
	$(INSTALL) -m 0755 -D $(@D)/S30mount $(TARGET_DIR)/etc/init.d/
	cd $(TARGET_DIR) && rm -rf oem userdata data && mkdir -p oem userdata && ln -s userdata data && cd -

endef

$(eval $(generic-package))
