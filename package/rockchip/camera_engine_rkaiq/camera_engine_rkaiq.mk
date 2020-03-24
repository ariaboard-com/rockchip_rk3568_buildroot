################################################################################
#
# Rockchip Camera Engine RKaiq For Linux
#
################################################################################

CAMERA_ENGINE_RKAIQ_VERSION = 1.0
CAMERA_ENGINE_RKAIQ_SITE = $(TOPDIR)/../external/camera_engine_rkaiq
CAMERA_ENGINE_RKAIQ_SITE_METHOD = local

CAMERA_ENGINE_RKAIQ_LICENSE = Apache V2.0
CAMERA_ENGINE_RKAIQ_LICENSE_FILES = NOTICE

CAMERA_ENGINE_RKAIQ_TARGET_INSTALL_DIR = $(TARGET_DIR)

ifeq ($(BR2_PACKAGE_RK_OEM), y)
CAMERA_ENGINE_RKAIQ_INSTALL_TARGET_OPTS = DESTDIR=$(BR2_PACKAGE_RK_OEM_INSTALL_TARGET_DIR) install/fast
CAMERA_ENGINE_RKAIQ_DEPENDENCIES += rk_oem
CAMERA_ENGINE_RKAIQ_TARGET_INSTALL_DIR = $(BR2_PACKAGE_RK_OEM_INSTALL_TARGET_DIR)
endif

define CAMERA_ENGINE_RKAIQ_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m  644 $(@D)/all_lib/Release/librkaiq.so $(CAMERA_ENGINE_RKAIQ_TARGET_INSTALL_DIR)/usr/lib/
endef

$(eval $(cmake-package))
