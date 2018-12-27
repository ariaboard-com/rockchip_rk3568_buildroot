ifeq ($(BR2_PACKAGE_DUI),y)

DUI_SITE = $(TOPDIR)/../external/dui
DUI_SITE_METHOD = local
DUI_INSTALL_STAGING = YES

DUI_DEPENDENCIES += deviceio opus

$(eval $(cmake-package))

endif
