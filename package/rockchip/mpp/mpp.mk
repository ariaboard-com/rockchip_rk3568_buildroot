# Rockchip's MPP(Multimedia Processing Platform)
MPP_SITE = $(TOPDIR)/../external/mpp
MPP_VERSION = release
MPP_SITE_METHOD = local

MPP_CONF_OPTS = "-DRKPLATFORM=ON"
MPP_CONF_DEPENDENCIES += libdrm

MPP_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_MPP_ALLOCATOR_DRM),y)
MPP_CONF_OPTS += "-DHAVE_DRM=ON"
endif

ifeq ($(BR2_PACKAGE_RK3328),y)
define MPP_H265_SUPPORTED_FIRMWARE
	mkdir -p $(TARGET_DIR)/lib/firmware/
	$(INSTALL) -m 0644 -D package/rockchip/mpp/monet.bin \
		$(TARGET_DIR)/lib/firmware/
endef
MPP_POST_INSTALL_TARGET_HOOKS += MPP_H265_SUPPORTED_FIRMWARE
endif

$(eval $(cmake-package))
