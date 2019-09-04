################################################################################
#
# Chromium
#
################################################################################
CHROMIUM_VERSION = 74.0.3729.157
CHROMIUM_SITE_METHOD = local
CHROMIUM_SITE = $(TOPDIR)/../external/chromium

ifeq ($(call qstrip,$(BR2_ARCH)),arm)
define CHROMIUM_INSTALL_TARGET_CMDS
    tar zxvf $(@D)/chromium-ozone-wayland_74.0.3729.157/$(BR2_ARCH)/chromium-ozone-wayland_armhf.tgz -C $(TARGET_DIR)/
endef
endif

ifeq ($(call qstrip,$(BR2_ARCH)),aarch64)
define CHROMIUM_INSTALL_TARGET_CMDS
    tar zxvf $(@D)/chromium-ozone-wayland_74.0.3729.157/$(BR2_ARCH)/chromium-ozone-wayland_aarch64.tgz -C $(TARGET_DIR)/
endef
endif

$(eval $(generic-package))
