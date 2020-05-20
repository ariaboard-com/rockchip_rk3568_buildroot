ifeq ($(BR2_PACKAGE_RKFACIAL), y)
    RKFACIAL_SITE = $(TOPDIR)/../external/rkfacial
    RKFACIAL_SITE_METHOD = local
    RKFACIAL_INSTALL_STAGING = YES
    RKFACIAL_DEPENDENCIES = rockface libdrm linux-rga sqlite camera_engine_rkisp alsa-lib mpp
    RKFACIAL_CONF_OPTS += "-DDRM_HEADER_DIR=$(STAGING_DIR)/usr/include/drm"
    ifeq ($(BR2_PACKAGE_RKFACIAL_USE_WEB_SERVER), y)
        RKFACIAL_CONF_OPTS += "-DUSE_WEB_SERVER=y"
        RKFACIAL_DEPENDENCIES += libIPCProtocol libgdbus
    endif
    $(eval $(cmake-package))
endif
