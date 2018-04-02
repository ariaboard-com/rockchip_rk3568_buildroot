# Rockchip's libcutils porting from Android
# Author : Cody Xie <cody.xie@rock-chips.com>

ifeq ($(BR2_PACKAGE_RK3036_ECHO),y)
LIBCUTILS_SITE = $(TOPDIR)/../external/libcutils
LIBCUTILS_SITE_METHOD = local
LIBCUTILS_DEPENDENCIES += liblog
else ifeq ($(BR2_PACKAGE_RK3308),y)
LIBCUTILS_SITE = $(TOPDIR)/../external/libcutils
LIBCUTILS_SITE_METHOD = local
LIBCUTILS_DEPENDENCIES += liblog
else ifeq ($(BR2_PACKAGE_RK3326),y)
LIBCUTILS_SITE = $(TOPDIR)/../external/libcutils
LIBCUTILS_SITE_METHOD = local
LIBCUTILS_DEPENDENCIES += liblog
else ifeq ($(BR2_PACKAGE_RK312X),y)
LIBCUTILS_SITE = $(TOPDIR)/../external/libcutils
LIBCUTILS_SITE_METHOD = local
LIBCUTILS_DEPENDENCIES += liblog
else
LIBCUTILS_SITE = $(call qstrip, ssh://git@10.10.10.78:2222/argus/externals/libcutils.git)
LIBCUTILS_SITE_METHOD = git
LIBCUTILS_SOURCE = libcutils-${LIBCUTILS_VERSION}.tar.gz
LIBCUTILS_FROM_GIT = y
endif
LIBCUTILS_VERSION = 2c61c38
LIBCUTILS_INSTALL_STAGING = YES

$(eval $(cmake-package))
