CVR_SITE = $(TOPDIR)/../app/cvr
CVR_SITE_METHOD = local
CVR_INSTALL_STAGING = YES

# add dependencies
CVR_DEPENDENCIES = rkcamera messenger process_units libpng12 rv1108_minigui rknr ffmpeg mpp rkmedia

CVR_CONF_OPTS += -DUI_RESOLUTION=$(call qstrip,$(RK_UI_RESOLUTION))

define CVR_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/rockchip/rv1108_package/app/cvr/S12_cvr \
		    $(TARGET_DIR)/etc/init.d

    $(INSTALL) -m 0644 -D package/rockchip/rv1108_package/app/cvr/cvr.conf \
                    $(TARGET_DIR)/etc/cvr.conf
endef

$(eval $(cmake-package))
