ifeq ($(BR2_PACKAGE_UVC_APP), y)
    UVC_APP_SITE = $(TOPDIR)/../external/uvc_app
    UVC_APP_SITE_METHOD = local
    UVC_APP_INSTALL_STAGING = YES
    UVC_APP_DEPENDENCIES = libdrm mpp

define UVC_APP_INSTALL_TARGET_CMDS
    if [ -f $(UVC_APP_SITE)/mpp_enc_cfg.conf ]; then \
         $(INSTALL) -m 644 -D $(UVC_APP_SITE)/mpp_enc_cfg.conf \
              $(TARGET_DIR)/etc/mpp_enc_cfg.conf;\
    fi
endef

ifeq ($(BR2_PACKAGE_CAMERA_ENGINE_RKISP),y)
    UVC_APP_DEPENDENCIES += camera_engine_rkisp
endif

ifneq ($(BR2_PACKAGE_RKMEDIA_UVC), y)
ifeq ($(BR2_PACKAGE_RKMEDIA), y)
    UVC_APP_DEPENDENCIES = rkmedia
    UVC_APP_CONF_OPTS = -DCOMPILES_CAMERA=ON
endif
endif

ifeq ($(BR2_PACKAGE_ROCKX),y)
    UVC_APP_DEPENDENCIES += rockx linux-rga
    UVC_APP_CONF_OPTS += "-DEPTZ_SUPPORT=ON" "-DROCKX_HEADER_DIR=$(STAGING_DIR)/usr/include/rockx"
endif

ifeq ($(BR2_PACKAGE_DBSERVER),y)
    UVC_APP_DEPENDENCIES += libIPCProtocol
    UVC_APP_CONF_OPTS += "-DDBSERVER_SUPPORT=ON" "-DLIBIPCPROTOCOL_HEADER_DIR=$(STAGING_DIR)/usr/include/libIPCProtocol"
endif

    $(eval $(cmake-package))
endif
