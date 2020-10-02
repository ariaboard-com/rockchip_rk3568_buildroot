################################################################################
#
# tb(thunder boot)
#
################################################################################

THUNDERBOOT_VERSION = master
THUNDERBOOT_SITE_METHOD = local
THUNDERBOOT_SITE = $(TOPDIR)/package/rockchip/thunderboot

KERNEL_VERSION=`make -C $(TOPDIR)/../kernel kernelversion |grep -v make`

define THUNDERBOOT_BUILD_CMDS
	make -C $(TOPDIR)/../kernel INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=${THUNDERBOOT_BUILDDIR} modules_install ARCH=${BR2_ARCH}
endef

define THUNDERBOOT_INSTALL_TARGET_CMDS
    $(INSTALL) -D -m 644 ${THUNDERBOOT_BUILDDIR}/lib/modules/${KERNEL_VERSION}/kernel/drivers/mmc/host/dw_mmc-rockchip.ko $(TARGET_DIR)/lib/modules/
    $(INSTALL) -D -m 755 $(@D)/S07mountall $(TARGET_DIR)/etc/preinit.d/
endef

$(eval $(generic-package))
