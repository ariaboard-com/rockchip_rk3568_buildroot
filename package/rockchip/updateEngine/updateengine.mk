################################################################################
#
# Rockchip updateEngine For Linux
#
################################################################################

UPDATEENGINE_VERSION = develop
UPDATEENGINE_SITE = $(TOPDIR)/../external/update_engine
UPDATEENGINE_SITE_METHOD = local

UPDATEENGINE_LICENSE = Apache V2.0
UPDATEENGINE_LICENSE_FILES = NOTICE
CXX="$(TARGET_CXX)"
PROJECT_DIR="$(@D)"
UPDATEENGINE_BUILD_OPTS=-I$(PROJECT_DIR) \
    --sysroot=$(STAGING_DIR) \
    -fPIC \
    -lssl \
    -lcrypto \
    -lcurl \
    -lpthread

UPDATEENGINE_MAKE_OPTS = \
        CFLAGS="$(TARGET_CFLAGS) $(UPDATEENGINE_BUILD_OPTS)" \
        PROJECT_DIR="$(@D)"

define UPDATEENGINE_BUILD_CMDS
    $(TARGET_MAKE_ENV) $(MAKE) -C $(@D) CXX="$(TARGET_CXX)" $(UPDATEENGINE_MAKE_OPTS)
endef

define UPDATEENGINE_INSTALL_TARGET_CMDS
        $(INSTALL) -D -m 755 $(@D)/update_engine $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
