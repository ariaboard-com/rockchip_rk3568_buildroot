################################################################################
#
# tb(thunder boot)
#
################################################################################

THUNDERBOOT_VERSION = master
THUNDERBOOT_SITE_METHOD = local
THUNDERBOOT_SITE = $(TOPDIR)/package/rockchip/thunderboot

KERNEL_VERSION=`make -C $(TOPDIR)/../kernel kernelversion |grep -v make`
INSTALL_MODULES = $(call qstrip,$(BR2_THUNDERBOOT_INSTALL_MODULES))

define THUNDERBOOT_BUILD_CMDS
	make -C $(TOPDIR)/../kernel INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=${THUNDERBOOT_BUILDDIR} modules_install ARCH=${BR2_ARCH}
endef

define THUNDERBOOT_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/modules/ $(TARGET_DIR)/etc/preinit.d/

	for module in `echo ${INSTALL_MODULES} | tr ',' '\n'`; do \
		find ${THUNDERBOOT_BUILDDIR}/lib/modules/${KERNEL_VERSION}/kernel -name $$module | xargs -i cp {} $(TARGET_DIR)/lib/modules/; \
	done

	$(INSTALL) -D -m 755 $(@D)/S07mountall $(TARGET_DIR)/etc/preinit.d/
	$(INSTALL) -D -m 755 $(@D)/tb_poweroff $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
