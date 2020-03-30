# add test tool for rockchip platform
# Author : Hans Yang <yhx@rock-chips.com>

ROCKCHIP_TEST_VERSION = 20191021
ROCKCHIP_TEST_SITE_METHOD = local
ROCKCHIP_TEST_SITE = $(TOPDIR)/package/rockchip/rockchip_test/src
ROCKCHIP_TEST_LICENSE = Apache V2.0
ROCKCHIP_TEST_LICENSE_FILES = NOTICE

ifeq ($(BR2_PACKAGE_RK1808),y)
define ROCKCHIP_TEST_INSTALL_TARGET_CMDS
	cp -rf  $(@D)/rockchip_test  ${TARGET_DIR}/
	cp -rf $(@D)/rockchip_test_${ARCH}/* ${TARGET_DIR}/rockchip_test/ || true
	cp -rf $(@D)/npu ${TARGET_DIR}/rockchip_test/
	$(INSTALL) -D -m 0755 $(@D)/rockchip_test/auto_reboot/S99_auto_reboot $(TARGET_DIR)/etc/init.d/
endef
else
define ROCKCHIP_TEST_INSTALL_TARGET_CMDS
	cp -rf  $(@D)/rockchip_test  ${TARGET_DIR}/
	cp -rf $(@D)/rockchip_test_${ARCH}/* ${TARGET_DIR}/rockchip_test/ || true
	$(INSTALL) -D -m 0755 $(@D)/rockchip_test/auto_reboot/S99_auto_reboot $(TARGET_DIR)/etc/init.d/
endef
endif

$(eval $(generic-package))
