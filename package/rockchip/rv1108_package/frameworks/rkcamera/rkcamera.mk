RKCAMERA_SITE = $(TOPDIR)/../frameworks/rkcamera
RKCAMERA_SITE_METHOD = local
RKCAMERA_INSTALL_STAGING = YES

# add dependencies
RKCAMERA_DEPENDENCIES = libcamerahal adk libion cjson

RKCAMERA_CONF_OPTS += \
    -DBOARD_VERSION=rv1108-lock-evb-v10

$(eval $(cmake-package))
