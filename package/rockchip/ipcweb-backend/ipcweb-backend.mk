# Rockchip's MPP(Multimedia Processing Platform)
IPCWEB_BACKEND_SITE = $(TOPDIR)/../app/ipcweb-backend
IPCWEB_BACKEND_VERSION = release
IPCWEB_BACKEND_SITE_METHOD = local

IPCWEB_BACKEND_DEPENDENCIES = libcgicc boost openssl
IPCWEB_BACKEND_CONF_OPTS += -DIPCWEBBACKEND_BUILD_TESTS=OFF

$(eval $(cmake-package))
