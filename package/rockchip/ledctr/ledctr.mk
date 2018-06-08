################################################################################
#
# ledctr
#
################################################################################

LEDCTR_LICENSE_FILES = NOTICE
LEDCTR_LICENSE = Apache V2.0
LEDCTR_SITE = $(TOPDIR)/package/rockchip/ledctr
LEDCTR_SITE_METHOD = local
LEDCTR_LICENSE = Apache V2.0
LEDCTR_LICENSE_FILES = NOTICE
CXX="$(TARGET_CXX)"
PROJECT_DIR="$(@D)"
LEDCTR_BUILD_OPTS=-I$(PROJECT_DIR) -fPIC \
	--sysroot=$(STAGING_DIR) \
	-ldl -lpthread

LEDCTR_MAKE_OPTS = \
        CXXFLAGS="$(TARGET_CPPFLAGS) $(LEDCTR_BUILD_OPTS)" \
        PROJECT_DIR="$(@D)"

define LEDCTR_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) CXX="$(TARGET_CXX)" $(LEDCTR_MAKE_OPTS)
endef

define LEDCTR_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/ledctr $(TARGET_DIR)/usr/bin/
endef

$(eval $(generic-package))
