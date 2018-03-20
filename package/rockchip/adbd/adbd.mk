# Rockchip's adbd porting for Linux
# Author : Cody Xie <cody.xie@rock-chips.com>

ifeq ($(BR2_PACKAGE_RK3036_ECHO),y)
ADBD_SITE = $(TOPDIR)/../external/adb
ADBD_SITE_METHOD = local
else ifeq ($(BR2_PACKAGE_RK3308),y)
ADBD_SITE = $(TOPDIR)/../external/adb
ADBD_SITE_METHOD = local
else ifeq ($(BR2_PACKAGE_RK312X),y)
ADBD_SITE = $(TOPDIR)/../external/adb
ADBD_SITE_METHOD = local
else
ADBD_SITE = $(call qstrip, ssh://git@10.10.10.78:2222/argus/externals/adb.git)
ADBD_SITE_METHOD = git
ADBD_SOURCE = adbd-${ADBD_VERSION}.tar.gz
ADBD_FROM_GIT = y
endif
ADBD_VERSION = 0d8ec12

ADBD_DEPENDENCIES += libcutils

ifeq ($(BR2_PACKAGE_BUSYBOX),y)
ifeq ($(BR2_PACKAGE_START_STOP_DAEMON), y)
ADBD_DEPENDENCIES += busybox
endif
endif

ifeq ($(BR2_KERNEL_HEADERS_4_4),y)
ADBD_INIT_SCRIPT=package/rockchip/adbd/S30adbd-configfs
else
ADBD_INIT_SCRIPT=package/rockchip/adbd/S30adbd
endif

define ADBD_INSTALL_INIT_SYSV
$(INSTALL) -D -m 0755 ${ADBD_INIT_SCRIPT} \
		$(TARGET_DIR)/etc/init.d/S30adbd
$(INSTALL) -D -m 0755 package/rockchip/adbd/usb_config \
        $(TARGET_DIR)/usr/bin/usb_config
endef

$(eval $(cmake-package))
