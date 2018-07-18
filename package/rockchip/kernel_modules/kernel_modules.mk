################################################################################
#
# kernel_modules
#
################################################################################

# This package is used to build rockchip kernel modules and install into rootfs

KERNEL_MODULES_LICENSE = GPL-2.0
KERNEL_MODULES_LICENSE_FILES = COPYING

KERNEL_MODULES_SITE = $(TOPDIR)/../kernel
KERNEL_MODULES_SITE_METHOD = local

KERNEL_MODULES_KCONFIG_DEFCONFIG = $(call qstrip,$(BR2_PACKAGE_KERNEL_DEFCONFIG))_defconfig

KERNEL_MODULES_MAKE_FLAGS = \
	HOSTCC="$(HOSTCC)" \
	HOSTCFLAGS="$(HOSTCFLAGS)" \
        ARCH=$(KERNEL_ARCH) \
        CROSS_COMPILE="$(TARGET_CROSS)" \
	INSTALL_MOD_STRIP=1 \
	INSTALL_MOD_PATH="$(TARGET_DIR)" \
        DEPMOD=$(HOST_DIR)/sbin/depmod

define KERNEL_MODULES_BUILD_CMDS
	(cd $(@D); \
		$(TARGET_MAKE_ENV) $(MAKE) $(KERNEL_MODULES_MAKE_FLAGS) \
			$(KERNEL_MODULES_KCONFIG_DEFCONFIG) Image modules modules_install)
endef

$(eval $(kconfig-package))
