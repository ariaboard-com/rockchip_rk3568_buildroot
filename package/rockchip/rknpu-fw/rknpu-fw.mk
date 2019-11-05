################################################################################
#
# rknpu firmware
#
################################################################################
RKNPU_FW_VERSION = 1.0.0
RKNPU_FW_SITE_METHOD = local
RKNPU_FW_SITE = $(TOPDIR)/../external/rknpu-fw

ifeq ($(BR2_PACKAGE_RKNPU_PCIE),y)
define RKNPU_FW_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/usr/share/npu_fw
    $(INSTALL) -m 0755 -D $(@D)/npu_fw_pcie/* $(TARGET_DIR)/usr/share/npu_fw/
    $(INSTALL) -m 0755 -D $(@D)/bin/npu-image.sh $(TARGET_DIR)/usr/bin/
    $(INSTALL) -m 0755 -D $(@D)/bin/npu_transfer_proxy $(TARGET_DIR)/usr/bin/
    $(INSTALL) -m 0755 -D $(@D)/bin/npu_upgrade_pcie $(TARGET_DIR)/usr/bin/npu_upgrade
    $(INSTALL) -m 0755 -D $(@D)/bin/upgrade_tool $(TARGET_DIR)/usr/bin/
    $(INSTALL) -m 0755 -D $(@D)/S11_npu_init $(TARGET_DIR)/etc/init.d/
endef
else
define RKNPU_FW_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/usr/share/npu_fw
    $(INSTALL) -m 0755 -D $(@D)/npu_fw_n4/* $(TARGET_DIR)/usr/share/npu_fw/
    $(INSTALL) -m 0755 -D $(@D)/bin/npu-image.sh $(TARGET_DIR)/usr/bin/
    $(INSTALL) -m 0755 -D $(@D)/bin/npu_transfer_proxy $(TARGET_DIR)/usr/bin/
    $(INSTALL) -m 0755 -D $(@D)/bin/npu_upgrade $(TARGET_DIR)/usr/bin/
    $(INSTALL) -m 0755 -D $(@D)/bin/upgrade_tool $(TARGET_DIR)/usr/bin/
    $(INSTALL) -m 0755 -D $(@D)/S11_npu_init $(TARGET_DIR)/etc/init.d/
endef
endif

$(eval $(generic-package))
