ifeq ($(BR2_PACKAGE_RKSL), y)
    RKSL_SITE = $(TOPDIR)/../app/rksl
    RKSL_SITE_METHOD = local
    RKSL_INSTALL_STAGING = YES
    RKSL_DEPENDENCIES = libdrm linux-rga camera_engine_rkisp
    RKSL_CONF_OPTS += "-DDRM_HEADER_DIR=$(STAGING_DIR)/usr/include/drm"
    $(eval $(cmake-package))
endif
