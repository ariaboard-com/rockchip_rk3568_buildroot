################################################################################
#
# libmali For Linux
#
################################################################################

LIBMALI_VERSION = develop
LIBMALI_SITE = $(TOPDIR)/../external/libmali
LIBMALI_SITE_METHOD = local

LIBMALI_INSTALL_STAGING = YES

LIBMALI_DEPENDENCIES = host-patchelf mesa3d

ifeq ($(BR2_PACKAGE_WAYLAND),y)
LIBMALI_SUFFIX = -wayland
else
ifeq ($(BR2_PACKAGE_XORG7)),y)
LIBMALI_SUFFIX =
else
LIBMALI_SUFFIX = -gbm
endif
endif

ifeq ($(BR2_PACKAGE_LIBMALI_WITHOUT_CL),y)
LIBMALI_SUFFIX := $(LIBMALI_SUFFIX)-without-cl
endif

ifeq ($(BR2_PACKAGE_LIBMALI_ONLY_CL),y)
LIBMALI_SUFFIX := $(LIBMALI_SUFFIX)-only-cl
endif

ifneq ($(BR2_PACKAGE_RK3326)$(BR2_PACKAGE_PX30),)
LIBMALI_LIBS = libmali-bifrost-g31-rxp0$(LIBMALI_SUFFIX).so
else ifeq ($(BR2_PACKAGE_PX3SE),y)
LIBMALI_LIBS = libmali-utgard-400-r7p0-r3p0$(LIBMALI_SUFFIX).so

define LIBMALI_INSTALL_PX3SE_HOOKS
	$(INSTALL) -D -m 755 $(@D)/overlay/S10libmali_px3se $(1)/etc/init.d/S10libmali
	$(INSTALL) -D -m 755 $(@D)/overlay/px3seBase $(1)/usr/sbin/
endef
LIBMALI_POST_INSTALL_HOOKS += LIBMALI_INSTALL_PX3SE_HOOKS

else ifneq ($(BR2_PACKAGE_RK3126C)$(BR2_PACKAGE_RK3128)$(BR2_PACKAGE_RK3128H),)
LIBMALI_LIBS = libmali-utgard-400-r7p0-r1p1$(LIBMALI_SUFFIX).so
else ifeq ($(BR2_PACKAGE_RK3288),y)
LIBMALI_LIBS = libmali-midgard-t76x-r14p0-r0p0$(LIBMALI_SUFFIX).so \
	       libmali-midgard-t76x-r14p0-r1p0$(LIBMALI_SUFFIX).so

define LIBMALI_INSTALL_3288_HOOKS
	$(INSTALL) -D -m 755 $(@D)/overlay/S10libmali_rk3288 $(1)/etc/init.d/S10libmali
endef
LIBMALI_POST_INSTALL_HOOKS += LIBMALI_INSTALL_3288_HOOKS

else ifneq ($(BR2_PACKAGE_RK3399)$(BR2_PACKAGE_RK3399PRO),)
LIBMALI_LIBS = libmali-midgard-t86x-r14p0$(LIBMALI_SUFFIX).so
else ifeq ($(BR2_PACKAGE_RK3328),y)
LIBMALI_LIBS = libmali-utgard-450-r7p0-r0p0$(LIBMALI_SUFFIX).so
endif

ifneq ($(LIBMALI_LIBS),)
LIBMALI_ARCH_DIR = $(if $(BR2_arm),arm-linux-gnueabihf,aarch64-linux-gnu)

define LIBMALI_INSTALL_CMDS
	cd $(@D)/lib/$(LIBMALI_ARCH_DIR) && \
		$(INSTALL) -D -m 644 $(LIBMALI_LIBS) $(1)/usr/lib/

	for l in $(LIBMALI_LIBS); do \
		patchelf --set-soname libmali.so.1 $(1)/usr/lib/$$l ; \
	done

	echo $(LIBMALI_LIBS) | xargs -n 1 | head -n 1 | \
		xargs -i ln -sf {} $(1)/usr/lib/libmali.so.1
endef
LIBMALI_POST_INSTALL_HOOKS += LIBMALI_INSTALL_CMDS
endif

define LIBMALI_CREATE_LINKS
	ln -sf libmali.so.1 $(1)/usr/lib/libmali.so
	ln -sf libmali.so $(1)/usr/lib/libMali.so.1
	ln -sf libMali.so.1 $(1)/usr/lib/libMali.so

	rm -f $(1)/usr/lib/libEGL.so*
	ln -sf libmali.so $(1)/usr/lib/libEGL.so.1
	ln -sf libEGL.so.1 $(1)/usr/lib/libEGL.so

	rm -f $(1)/usr/lib/libgbm.so*
	ln -sf libmali.so $(1)/usr/lib/libgbm.so.1
	ln -sf libgbm.so.1 $(1)/usr/lib/libgbm.so

	rm -f $(1)/usr/lib/libGLESv1_CM.so*
	ln -sf libmali.so $(1)/usr/lib/libGLESv1_CM.so.1
	ln -sf libGLESv1_CM.so.1 $(1)/usr/lib/libGLESv1_CM.so

	rm -f $(1)/usr/lib/libGLESv2.so*
	ln -sf libmali.so $(1)/usr/lib/libGLESv2.so.2
	ln -sf libGLESv2.so.2 $(1)/usr/lib/libGLESv2.so
endef
LIBMALI_POST_INSTALL_HOOKS += LIBMALI_CREATE_LINKS

ifeq ($(BR2_PACKAGE_WAYLAND),y)
define LIBMALI_CREATE_WAYLAND_LINKS
	rm -f $(1)/usr/lib/libwayland-egl.so*

	ln -sf libmali.so $(1)/usr/lib/libwayland-egl.so.1
	ln -sf libwayland-egl.so.1 $(1)/usr/lib/libwayland-egl.so
endef
LIBMALI_POST_INSTALL_HOOKS += LIBMALI_CREATE_WAYLAND_LINKS
endif

# px3se/3126c/3128 not support opencl
ifeq ($(BR2_PACKAGE_PX3SE)$(BR2_PACKAGE_RK3126C)$(BR2_PACKAGE_RK3128)$(BR2_PACKAGE_LIBMALI_WITHOUT_CL),)
define LIBMALI_CREATE_OPENCL_LINKS
	rm -f $(1)/usr/lib/libOpenCL.so*

	ln -sf libmali.so $(1)/usr/lib/libMaliOpenCL.so
	ln -sf libMaliOpenCL.so $(1)/usr/lib/libOpenCL.so
endef
LIBMALI_POST_INSTALL_HOOKS += LIBMALI_CREATE_OPENCL_LINKS
endif

define LIBMALI_POST_INSTALL_HOOKS_STAGING
	$(foreach hook,$(LIBMALI_POST_INSTALL_HOOKS),\
		$(call $(hook),$(STAGING_DIR))$(sep))
endef
LIBMALI_POST_INSTALL_STAGING_HOOKS += LIBMALI_POST_INSTALL_HOOKS_STAGING

define LIBMALI_POST_INSTALL_HOOKS_TARGET
	$(foreach hook,$(LIBMALI_POST_INSTALL_HOOKS),\
		$(call $(hook),$(TARGET_DIR))$(sep))
endef
LIBMALI_POST_INSTALL_TARGET_HOOKS += LIBMALI_POST_INSTALL_HOOKS_TARGET

$(eval $(generic-package))
