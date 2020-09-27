################################################################################
#
# libmali For Linux
#
################################################################################

LIBMALI_VERSION = develop
LIBMALI_SITE = $(TOPDIR)/../external/libmali
LIBMALI_SITE_METHOD = local

LIBMALI_INSTALL_STAGING = YES

LIBMALI_DEPENDENCIES = mesa3d

LIBMALI_CONF_OPTS = -Dwith-overlay=true -Dopencl-icd=false

ifeq ($(BR2_PACKAGE_LIBMALI_ONLY_CL),y)
LIBMALI_CONF_OPTS += -Dplatform=only-cl
else ifeq ($(BR2_PACKAGE_WAYLAND),y)
LIBMALI_CONF_OPTS += -Dplatform=wayland
else ifeq ($(BR2_PACKAGE_XORG7)),y)
LIBMALI_CONF_OPTS += -Dplatform=x11
else
LIBMALI_CONF_OPTS += -Dplatform=gbm
endif

ifeq ($(BR2_PACKAGE_LIBMALI_WITHOUT_CL),y)
LIBMALI_CONF_OPTS += -Dsubversion=without-cl
endif

ifneq ($(BR2_PACKAGE_RK3326)$(BR2_PACKAGE_PX30),)
LIBMALI_CONF_OPTS += -Dgpu=bifrost-g31 -Dversion=rxp0
else ifeq ($(BR2_PACKAGE_PX3SE),y)
LIBMALI_CONF_OPTS += -Dgpu=utgard-400 -Dversion=r7p0 \
		     -Dsubversion=r3p0
else ifneq ($(BR2_PACKAGE_RK312X)$(BR2_PACKAGE_RK3128H)$(BR2_PACKAGE_RK3036)$(BR2_PACKAGE_RK3032),)
LIBMALI_CONF_OPTS += -Dgpu=utgard-400 -Dversion=r7p0 -Dsubversion=r1p0
else ifeq ($(BR2_PACKAGE_RK3288),y)
LIBMALI_CONF_OPTS += -Dgpu=midgard-t76x -Dversion=r18p0 \
		     -Dsubversion=all
else ifneq ($(BR2_PACKAGE_RK3399)$(BR2_PACKAGE_RK3399PRO),)
LIBMALI_CONF_OPTS += -Dgpu=midgard-t86x -Dversion=r18p0
else ifeq ($(BR2_PACKAGE_RK3328),y)
LIBMALI_CONF_OPTS += -Dgpu=utgard-450 -Dversion=r7p0
endif

$(eval $(meson-package))
