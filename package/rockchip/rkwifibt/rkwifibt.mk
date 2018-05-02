################################################################################
#
# rkwifibt
#
################################################################################

RKWIFIBT_VERSION = 1.0.0
RKWIFIBT_SITE_METHOD = local
RKWIFIBT_SITE = $(TOPDIR)/package/rockchip/rkwifibt/src

RKWIFIBT_MODULES_PATH = $(TOPDIR)/../kernel/drivers/net/wireless/rockchip_wlan
BT_TTY_DEV = $(call qstrip,$(BR2_PACKAGE_RKWIFIBT_BTUART))

ifeq ($(BR2_PACKAGE_RKWIFIBT_AP6255),y)
CHIP_VENDOR = BROADCOM
CHIP_NAME = AP6255
BT_FIRMWARE = BCM4345C0.hcd
endif

ifeq ($(BR2_PACKAGE_RKWIFIBT_AP6212A1),y)
CHIP_VENDOR = BROADCOM
CHIP_NAME = AP6212A1
BT_FIRMWARE = bcm43438a1.hcd
endif

ifeq ($(BR2_PACKAGE_RKWIFIBT_AWCM256),y)
CHIP_VENDOR = BROADCOM
CHIP_NAME = AW-CM256
BT_FIRMWARE = bcm43438a1.hcd
endif

ifeq ($(BR2_PACKAGE_RKWIFIBT_AWNB197),y)
CHIP_VENDOR = BROADCOM
CHIP_NAME = AW-NB197
BT_FIRMWARE = BCM4343A1.hcd
endif

ifeq ($(CHIP_VENDOR), BROADCOM)
define RKWIFIBT_BUILD_CMDS
    $(TARGET_CC) -o $(@D)/brcm_tools/brcm_patchram_plus1 $(@D)/brcm_tools/brcm_patchram_plus1.c
    $(TARGET_CC) -o $(@D)/brcm_tools/dhd_priv $(@D)/brcm_tools/dhd_priv.c
endef

define RKWIFIBT_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/usr/lib/modules
    mkdir -p $(TARGET_DIR)/system/etc/firmware
    $(INSTALL) -D -m 0644 $(@D)/firmware/broadcom/$(CHIP_NAME)/wifi/* $(TARGET_DIR)/system/etc/firmware
	$(INSTALL) -D -m 0644 $(@D)/firmware/broadcom/$(CHIP_NAME)/bt/* $(TARGET_DIR)/system/etc/firmware
	$(INSTALL) -D -m 0755 $(@D)/brcm_tools/brcm_patchram_plus1 $(TARGET_DIR)/usr/bin/brcm_patchram_plus1
	$(INSTALL) -D -m 0755 $(@D)/brcm_tools/dhd_priv $(TARGET_DIR)/usr/bin/dhd_priv
	@$(INSTALL) -D -m 0644 $(RKWIFIBT_MODULES_PATH)/rkwifi/bcmdhd/bcmdhd.ko $(TARGET_DIR)/usr/lib/modules || echo "Err, Please cd kernel and compile wifi modules first"
	sed -i 's/MODULE_PATH/\/usr\/lib\/modules\/bcmdhd.ko/g' $(@D)/S42load_wifi_modules
	$(INSTALL) -D -m 0755 $(@D)/S42load_wifi_modules $(TARGET_DIR)/etc/init.d
	sed -i 's/BTFIRMWARE_PATH/\/system\/etc\/firmware\/$(BT_FIRMWARE)/g' $(@D)/rk_load_bt_firmware
	sed -i 's/BT_TTY_DEV/\/dev\/$(BT_TTY_DEV)/g' $(@D)/rk_load_bt_firmware
    $(INSTALL) -D -m 0755 $(@D)/rk_load_bt_firmware $(TARGET_DIR)/usr/bin
	$(INSTALL) -D -m 0755 $(@D)/bin/* $(TARGET_DIR)/usr/bin/
endef
endif

$(eval $(generic-package))
