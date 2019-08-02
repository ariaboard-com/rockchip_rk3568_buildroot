################################################################################
#
# rknpu firmware
#
################################################################################
RKNPU_FW_VERSION = 1.0.0
RKNPU_FW_SITE_METHOD = local
RKNPU_FW_SITE = $(TOPDIR)/../external/rknpu-fw

define RKNPU_FW_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/usr/share/npu_fw
    $(INSTALL) -m 0755 -D $(@D)/npu_fw/* $(TARGET_DIR)/usr/share/npu_fw/
    $(INSTALL) -m 0755 -D $(@D)/bin/* $(TARGET_DIR)/usr/bin/
    $(INSTALL) -m 0755 -D $(@D)/S11_npu_init $(TARGET_DIR)/etc/init.d/
endef

$(eval $(generic-package))
