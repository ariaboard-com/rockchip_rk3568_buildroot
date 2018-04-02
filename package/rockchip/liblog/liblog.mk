# Rockchip's liblog porting from Android
# Author : Cody Xie <cody.xie@rock-chips.com>

ifeq ($(BR2_PACKAGE_RK3036_ECHO),y)
LIBLOG_SITE = $(TOPDIR)/../external/liblog
LIBLOG_SITE_METHOD = local
LIBLOG_INSTALL_STAGING = YES

$(eval $(cmake-package))
endif

ifeq ($(BR2_PACKAGE_RK3308),y)
LIBLOG_SITE = $(TOPDIR)/../external/liblog
LIBLOG_SITE_METHOD = local
LIBLOG_INSTALL_STAGING = YES

$(eval $(cmake-package))
endif

ifeq ($(BR2_PACKAGE_RK3326),y)
LIBLOG_SITE = $(TOPDIR)/../external/liblog
LIBLOG_SITE_METHOD = local
LIBLOG_INSTALL_STAGING = YES

$(eval $(cmake-package))
endif

ifeq ($(BR2_PACKAGE_RK312X),y)
LIBLOG_SITE = $(TOPDIR)/../external/liblog
LIBLOG_SITE_METHOD = local
LIBLOG_INSTALL_STAGING = YES

$(eval $(cmake-package))
endif
