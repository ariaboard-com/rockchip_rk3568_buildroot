################################################################################
#
# libmali For Linux
#
################################################################################

LIBMALI_VERSION = develop
LIBMALI_SITE = $(TOPDIR)/../external/libmali
LIBMALI_SITE_METHOD = local

LIBMALI_DEPENDENCIES = mesa3d

ifeq ($(BR2_PACKAGE_WAYLAND),y)
# Somehow the px30/3326's wayland mali named "-wayland-gbm"
ifneq ($(BR2_PACKAGE_PX30)$(BR2_PACKAGE_RK3326),)
LIBMALI_SUFFIX = -wayland-gbm
else
LIBMALI_SUFFIX = -wayland
endif
else
ifeq ($(BR2_PACKAGE_XORG7)),y)
LIBMALI_SUFFIX = -x11-fbdev
else
LIBMALI_SUFFIX = -gbm
endif
endif

ifeq ($(BR2_PACKAGE_LIBMALI_WITHOUT_CL),y)
LIBMALI_SUFFIX := $(LIBMALI_SUFFIX)-without-cl
endif

ifneq ($(BR2_PACKAGE_RK3326)$(BR2_PACKAGE_PX30),)
LIBMALI_LIBS = libmali-bifrost-g31-rxp0$(LIBMALI_SUFFIX).so
else ifeq ($(BR2_PACKAGE_PX3SE),y)
LIBMALI_LIBS = libmali-utgard-400-r7p0-r3p0$(LIBMALI_SUFFIX).so

define LIBMALI_INSTALL_HOOKS
	$(INSTALL) -D -m 755 $(@D)/overlay/S10libmali_px3se $(TARGET_DIR)/etc/init.d/S10libmali
	$(INSTALL) -D -m 755 $(@D)/overlay/px3seBase $(TARGET_DIR)/usr/sbin/
endef
LIBMALI_POST_INSTALL_TARGET_HOOKS += LIBMALI_INSTALL_HOOKS

else ifneq ($(BR2_PACKAGE_RK3126C)$(BR2_PACKAGE_RK3128)$(BR2_PACKAGE_RK3128H),)
LIBMALI_LIBS = libmali-utgard-400-r7p0-r1p1$(LIBMALI_SUFFIX).so
else ifeq ($(BR2_PACKAGE_RK3288),y)
LIBMALI_LIBS = libmali-midgard-t76x-r14p0-r0p0$(LIBMALI_SUFFIX).so \
	       libmali-midgard-t76x-r14p0-r1p0$(LIBMALI_SUFFIX).so

define LIBMALI_INSTALL_HOOKS
	$(INSTALL) -D -m 755 $(@D)/overlay/S10libmali_rk3288 $(TARGET_DIR)/etc/init.d/S10libmali
endef
LIBMALI_POST_INSTALL_TARGET_HOOKS += LIBMALI_INSTALL_HOOKS

else ifneq ($(BR2_PACKAGE_RK3399)$(BR2_PACKAGE_RK3399PRO),)
LIBMALI_LIBS = libmali-midgard-t86x-r14p0$(LIBMALI_SUFFIX).so
else ifeq ($(BR2_PACKAGE_RK3328),y)
LIBMALI_LIBS = libmali-utgard-450-r7p0-r0p0$(LIBMALI_SUFFIX).so
endif

define LIBMALI_REMOVE_MESA_LIBS
	rm -f \
	$(TARGET_DIR)/usr/lib/libEGL.so* \
	$(TARGET_DIR)/usr/lib/libgbm.so* \
	$(TARGET_DIR)/usr/lib/libGLESv1_CM.so* \
	$(TARGET_DIR)/usr/lib/libGLESv2.so* \
	$(TARGET_DIR)/usr/lib/libOpenCL.so* \
	$(TARGET_DIR)/usr/lib/libwayland-egl.so*
endef
LIBMALI_PRE_INSTALL_TARGET_HOOKS += LIBMALI_REMOVE_MESA_LIBS

ifneq ($(LIBMALI_LIBS),)
LIBMALI_ARCH_DIR = $(if $(BR2_arm),arm-linux-gnueabihf,aarch64-linux-gnu)

define LIBMALI_INSTALL_TARGET_CMDS
	cd $(@D)/lib/$(LIBMALI_ARCH_DIR) && \
		$(INSTALL) -D -m 644 $(LIBMALI_LIBS) $(TARGET_DIR)/usr/lib/

	echo $(LIBMALI_LIBS) | xargs -n 1 | head -n 1 | \
		xargs -i ln -sf {} $(TARGET_DIR)/usr/lib/libmali.so
endef
endif

define LIBMALI_CREATE_LINKS
	ln -sf libmali.so $(TARGET_DIR)/usr/lib/libMali.so
	ln -sf libmali.so $(TARGET_DIR)/usr/lib/libEGL.so.1
	ln -sf libEGL.so.1 $(TARGET_DIR)/usr/lib/libEGL.so
	ln -sf libmali.so $(TARGET_DIR)/usr/lib/libgbm.so.1
	ln -sf libgbm.so.1 $(TARGET_DIR)/usr/lib/libgbm.so
	ln -sf libmali.so $(TARGET_DIR)/usr/lib/libGLESv1_CM.so.1
	ln -sf libGLESv1_CM.so.1 $(TARGET_DIR)/usr/lib/libGLESv1_CM.so
	ln -sf libmali.so $(TARGET_DIR)/usr/lib/libGLESv2.so.2
	ln -sf libGLESv2.so.2 $(TARGET_DIR)/usr/lib/libGLESv2.so
endef
LIBMALI_POST_INSTALL_TARGET_HOOKS += LIBMALI_CREATE_LINKS

ifeq ($(BR2_PACKAGE_WAYLAND),y)
define LIBMALI_CREATE_WAYLAND_LINKS
	ln -sf libmali.so $(TARGET_DIR)/usr/lib/libwayland-egl.so.1
	ln -sf libwayland-egl.so.1 $(TARGET_DIR)/usr/lib/libwayland-egl.so
endef
LIBMALI_POST_INSTALL_TARGET_HOOKS += LIBMALI_CREATE_WAYLAND_LINKS
endif

# px3se/3126c/3128 not support opencl
ifeq ($(BR2_PACKAGE_PX3SE)$(BR2_PACKAGE_RK3126C)$(BR2_PACKAGE_RK3128)$(BR2_PACKAGE_LIBMALI_WITHOUT_CL),)
define LIBMALI_CREATE_OPENCL_LINKS
	ln -sf libmali.so $(TARGET_DIR)/usr/lib/libMaliOpenCL.so
	ln -sf libMaliOpenCL.so $(TARGET_DIR)/usr/lib/libOpenCL.so
endef
LIBMALI_POST_INSTALL_TARGET_HOOKS += LIBMALI_CREATE_OPENCL_LINKS
endif

$(eval $(generic-package))
