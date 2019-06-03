# add test tool for rockchip platform
# Author : Hans Yang <yhx@rock-chips.com>

ROCKCHIP_TEST_VERSION = 20190603
ROCKCHIP_TEST_SITE_METHOD = local
ROCKCHIP_TEST_SITE = $(TOPDIR)/package/rockchip/rockchip_test/src

ifeq ($(BR2_PACKAGE_RK1808),y)
define ROCKCHIP_TEST_INSTALL_TARGET_CMDS
	cp -rf  $(@D)/rockchip_test  ${TARGET_DIR}/
	cp -rf $(@D)/rockchip_test_${ARCH}/* ${TARGET_DIR}/rockchip_test/ || true
	cp -rf $(@D)/npu ${TARGET_DIR}/rockchip_test/
endef
else
define ROCKCHIP_TEST_INSTALL_TARGET_CMDS
	cp -rf  $(@D)/rockchip_test  ${TARGET_DIR}/
	cp -rf $(@D)/rockchip_test_${ARCH}/* ${TARGET_DIR}/rockchip_test/ || true
endef
endif

$(eval $(generic-package))
