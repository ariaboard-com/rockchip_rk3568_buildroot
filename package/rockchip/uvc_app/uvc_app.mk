ifeq ($(BR2_PACKAGE_UVC_APP), y)
    UVC_APP_SITE = $(TOPDIR)/../external/uvc_app
    UVC_APP_SITE_METHOD = local
    UVC_APP_INSTALL_STAGING = YES
    UVC_APP_DEPENDENCIES = libdrm mpp
    $(eval $(cmake-package))
endif
