################################################################################
#
# libmali For Linux
#
################################################################################

LIBMALI_VERSION = develop
LIBMALI_SITE = $(TOPDIR)/../external/libmali
LIBMALI_SITE_METHOD = local

define LIBMALI_INSTALL_TARGET_CMDS
ifeq ($(BR2_PACKAGE_RK3308),y)
endif
ifeq ($(BR2_PACKAGE_RK3326)$(BR2_PACKAGE_PX30),y)
	$(INSTALL) -D -m 755 $(@D)/lib/libmali-bifrost-g31-rxp0-wayland-gbm.so $(TARGET_DIR)/usr/lib/
	ln -s $(TARGET_DIR)/usr/lib/libmali-bifrost-g31-rxp0-wayland-gbm.so $(TARGET_DIR)/usr/lib/libmali.so
endif
ifeq ($(BR2_PACKAGE_PX3SE),y)
	$(INSTALL) -D -m 755 $(@D)/lib/libmali-utgard-400-r7p0-r3p0-wayland.so $(TARGET_DIR)/usr/lib/
	ln -s $(TARGET_DIR)/usr/lib/libmali-utgard-400-r7p0-r3p0-wayland.so $(TARGET_DIR)/usr/lib/libmali.so
	$(INSTALL) -D -m 755 $(@D)/overlay/S10libmali_px3se $(TARGET_DIR)/usr/lib/etc/init.d/S10libmali
	$(INSTALL) -D -m 755 $(@D)/overlay/px3seBase $(TARGET_DIR)/usr/sbin/
endif
ifeq ($(BR2_PACKAGE_RK3288),y)
	$(INSTALL) -D -m 755 $(@D)/lib/aarch64-linux-gnu/libmali-midgard-t76x-r14p0-r0p0-wayland.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 755 $(@D)/lib/aarch64-linux-gnu/libmali-midgard-t76x-r14p0-r1p0-wayland.so $(TARGET_DIR)/usr/lib/
	$(INSTALL) -D -m 755 $(@D)/overlay/S10libmali_rk3288 $(TARGET_DIR)/usr/lib/etc/init.d/S10libmali
endif
ifeq ($(BR2_PACKAGE_RK3399),y)
	$(INSTALL) -D -m 755 $(@D)/lib/aarch64-linux-gnu/libmali-midgard-t86x-r14p0-wayland.so $(TARGET_DIR)/usr/lib/
	ln -s $(TARGET_DIR)/usr/lib/libmali-midgard-t86x-r14p0-wayland.so $(TARGET_DIR)/usr/lib/libmali.so
endif

ln -s $(TARGET_DIR)/usr/lib/libmali.so $(TARGET_DIR)/usr/lib/libEGL.so
ln -s $(TARGET_DIR)/usr/lib/libmali.so $(TARGET_DIR)/usr/lib/libEGL.so.1
ln -s $(TARGET_DIR)/usr/lib/libmali.so $(TARGET_DIR)/usr/lib/libgbm.so
ln -s $(TARGET_DIR)/usr/lib/libmali.so $(TARGET_DIR)/usr/lib/libgbm.so.1
ln -s $(TARGET_DIR)/usr/lib/libmali.so $(TARGET_DIR)/usr/lib/libGLESv1_CM.so.1
ln -s $(TARGET_DIR)/usr/lib/libmali.so $(TARGET_DIR)/usr/lib/libGLESv2.so
ln -s $(TARGET_DIR)/usr/lib/libmali.so $(TARGET_DIR)/usr/lib/libGLESv2.so.2
ln -s $(TARGET_DIR)/usr/lib/libmali.so $(TARGET_DIR)/usr/lib/libMaliOpenCL.so
ln -s $(TARGET_DIR)/usr/lib/libmali.so $(TARGET_DIR)/usr/lib/libOpenCL.so
ln -s $(TARGET_DIR)/usr/lib/libmali.so $(TARGET_DIR)/usr/lib/libwayland-egl.so
ln -s $(TARGET_DIR)/usr/lib/libmali.so $(TARGET_DIR)/usr/lib/libwayland-egl.so.1
endef

$(eval $(generic-package))
