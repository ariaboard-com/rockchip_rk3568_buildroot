MEDIASERVER_SITE = $(TOPDIR)/../app/mediaserver
MEDIASERVER_SITE_METHOD = local

MEDIASERVER_DEPENDENCIES = rkmedia dbus dbus-cpp librkdb cjson

MEDIASERVER_CONF_OPTS += -DBR2_SDK_PATH=$(HOST_DIR)

$(eval $(cmake-package))
