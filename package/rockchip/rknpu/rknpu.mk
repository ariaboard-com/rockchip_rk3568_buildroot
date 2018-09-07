################################################################################
#
# rknpu
#
################################################################################
RKNPU_VERSION = 1.0.0
RKNPU_SITE_METHOD = local
RKNPU_SITE = $(TOPDIR)/../external/rknpu
NPU_TEST_FILE = $(@D)/nputest

define RKNPU_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/usr/lib/modules/
    $(INSTALL) -D -m 0644 $(@D)/drivers/*.ko $(TARGET_DIR)/usr/lib/modules/
    $(INSTALL) -D -m 0644 $(@D)/drivers/*.so $(TARGET_DIR)/usr/lib
    $(INSTALL) -D -m 0755 $(@D)/S99NPU_init $(TARGET_DIR)/etc/init.d/

    if [ -e "$(@D)/nputest" ]; then \
	cp -r $(@D)/nputest $(TARGET_DIR)/usr/share; \
    fi

endef

$(eval $(generic-package))
