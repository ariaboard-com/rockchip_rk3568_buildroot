# Rockchip's MPP(Multimedia Processing Platform)
IPCWEB_BACKEND_SITE = $(TOPDIR)/../app/ipcweb-backend
IPCWEB_BACKEND_VERSION = release
IPCWEB_BACKEND_SITE_METHOD = local

IPCWEB_BACKEND_DEPENDENCIES = libcgicc openssl libIPCProtocol
IPCWEB_BACKEND_CONF_OPTS += -DIPCWEBBACKEND_BUILD_TESTS=OFF

ifeq ($(BR2_PACKAGE_IPCWEB_BACKEND_JWT), y)
IPCWEB_BACKEND_CONF_OPTS += -DENABLE_JWT=ON
else
IPCWEB_BACKEND_CONF_OPTS += -DENABLE_JWT=OFF
endif

ifeq ($(BR2_PACKAGE_RK_OEM), y)
IPCWEB_BACKEND_INSTALL_TARGET_OPTS = DESTDIR=$(BR2_PACKAGE_RK_OEM_INSTALL_TARGET_DIR) install/fast
IPCWEB_BACKEND_DEPENDENCIES += rk_oem
IPCWEB_BACKEND_CONF_OPTS += -DIPCWEBBACKEND_INSTALL_ON_OEM_PARTITION=ON
define IPCWEB_BACKEND_INSTALL_TARGET_CMDS
	rm -rf $(BASE_DIR)/oem/www
	cp -rfp $(@D)/www $(BASE_DIR)/oem
	mkdir -p $(BASE_DIR)/oem/www/cgi-bin/
	cp -rfp $(@D)/src/entry.cgi $(BASE_DIR)/oem/www/cgi-bin/
endef
else
define IPCWEB_BACKEND_INSTALL_TARGET_CMDS
	rm -rf $(TARGET_DIR)/usr/www
	cp -rfp $(@D)/www $(TARGET_DIR)/usr
	mkdir -p  $(TARGET_DIR)/usr/www/cgi-bin/
	cp -rfp $(@D)/src/entry.cgi $(TARGET_DIR)/usr/www/cgi-bin/
endef
endif

$(eval $(cmake-package))
