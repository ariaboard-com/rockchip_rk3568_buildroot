ifeq ($(BR2_PACKAGE_RKFACIAL), y)
    RKFACIAL_SITE = $(TOPDIR)/../external/rkfacial
    RKFACIAL_SITE_METHOD = local
    RKFACIAL_INSTALL_STAGING = YES
    RKFACIAL_DEPENDENCIES = rockface libdrm linux-rga sqlite alsa-lib mpp jpeg jpeg-turbo
ifeq ($(BR2_PACKAGE_RK1806),y)
    RKFACIAL_DEPENDENCIES += camera_engine_rkisp
    RKFACIAL_CONF_OPTS += "-DCAMERA_ENGINE_RKISP=y"
endif
ifeq ($(BR2_PACKAGE_RK1808),y)
    RKFACIAL_DEPENDENCIES += camera_engine_rkisp
    RKFACIAL_CONF_OPTS += "-DCAMERA_ENGINE_RKISP=y"
endif
ifeq ($(BR2_PACKAGE_RV1126_RV1109),y)
    RKFACIAL_DEPENDENCIES += camera_engine_rkaiq
    RKFACIAL_CONF_OPTS += "-DCAMERA_ENGINE_RKAIQ=y"
endif
    RKFACIAL_CONF_OPTS += "-DDRM_HEADER_DIR=$(STAGING_DIR)/usr/include/drm"
    ifeq ($(BR2_PACKAGE_RKFACIAL_USE_WEB_SERVER), y)
        RKFACIAL_CONF_OPTS += "-DUSE_WEB_SERVER=y"
        RKFACIAL_DEPENDENCIES += libIPCProtocol libgdbus
    endif
    ifeq ($(BR2_PACKAGE_RKFACIAL_ENABLE_IR_TEST_DATA), y)
        RKFACIAL_CONF_OPTS += "-DIR_TEST_DATA=y"
    endif
    $(eval $(cmake-package))
endif
