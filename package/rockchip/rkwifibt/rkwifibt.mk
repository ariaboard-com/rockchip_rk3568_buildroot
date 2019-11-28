################################################################################
#
# rkwifibt
#
################################################################################

RKWIFIBT_VERSION = 1.0.0
RKWIFIBT_SITE_METHOD = local
RKWIFIBT_SITE = $(TOPDIR)/../external/rkwifibt
RKWIFIBT_LICENSE = Apache V2.0
RKWIFIBT_LICENSE_FILES = NOTICE

BT_TTY_DEV = $(call qstrip,$(BR2_PACKAGE_RKWIFIBT_BTUART))

ifeq ($(call qstrip,$(RK_ARCH)),arm64)
RKWIFIBT_TOOLCHAIN = $(TOPDIR)/../prebuilts/gcc/linux-x86/aarch64/gcc-linaro-6.3.1-2017.05-x86_64_aarch64-linux-gnu/bin/aarch64-linux-gnu-
else ifeq ($(call qstrip,$(RK_ARCH)),arm)
RKWIFIBT_TOOLCHAIN = $(TOPDIR)/../prebuilts/gcc/linux-x86/arm/gcc-linaro-6.3.1-2017.05-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
endif
RKARCH=$(BR2_ARCH)

define RKWIFIBT_INSTALL_COMMON
    mkdir -p $(TARGET_DIR)/lib/firmware $(TARGET_DIR)/usr/lib/modules $(TARGET_DIR)/system/etc/firmware $(TARGET_DIR)/lib/firmware/rtlbt
    $(INSTALL) -D -m 0755 $(@D)/wpa_supplicant.conf $(TARGET_DIR)/etc/
    $(INSTALL) -D -m 0755 $(@D)/dnsmasq.conf $(TARGET_DIR)/etc/
    $(INSTALL) -D -m 0755 $(@D)/wifi_start.sh $(TARGET_DIR)/usr/bin/
    $(INSTALL) -D -m 0755 $(@D)/src/rk_wifi_init $(TARGET_DIR)/usr/bin/
endef

define RKWIFIBT_BROADCOM_INSTALL
    $(SED) "/load wifi modules/a\\  \   insmod \/system\/lib\/modules\/$(BR2_PACKAGE_RKWIFIBT_WIFI_KO)" $(@D)/S66load_wifi_modules
    $(SED) 's/BT_TTY_DEV/\/dev\/$(BT_TTY_DEV)/g' $(@D)/S66load_wifi_modules
    $(INSTALL) -D -m 0755 $(@D)/S66load_wifi_modules $(TARGET_DIR)/etc/init.d/
    $(INSTALL) -D -m 0644 $(@D)/firmware/broadcom/$(BR2_PACKAGE_RKWIFIBT_CHIPNAME)/wifi/* $(TARGET_DIR)/system/etc/firmware/
    $(INSTALL) -D -m 0755 $(@D)/brcm_tools/brcm_patchram_plus1 $(TARGET_DIR)/usr/bin/
    $(INSTALL) -D -m 0755 $(@D)/brcm_tools/dhd_priv $(TARGET_DIR)/usr/bin/
    $(INSTALL) -D -m 0755 $(@D)/bin/$(RKARCH)/* $(TARGET_DIR)/usr/bin/
    $(INSTALL) -D -m 0644 $(@D)/firmware/broadcom/$(BR2_PACKAGE_RKWIFIBT_CHIPNAME)/bt/* $(TARGET_DIR)/system/etc/firmware/
    $(INSTALL) -D -m 0755 $(@D)/bt_load_broadcom_firmware $(TARGET_DIR)/usr/bin/
    $(SED) 's/BTFIRMWARE_PATH/\/system\/etc\/firmware\/$(BR2_PACKAGE_RKWIFIBT_BT_FW)/g' $(TARGET_DIR)/usr/bin/bt_load_broadcom_firmware
    $(SED) 's/BT_TTY_DEV/\/dev\/$(BT_TTY_DEV)/g' $(TARGET_DIR)/usr/bin/bt_load_broadcom_firmware
    $(INSTALL) -D -m 0755 $(TARGET_DIR)/usr/bin/bt_load_broadcom_firmware $(TARGET_DIR)/usr/bin/bt_pcba_test
    $(INSTALL) -D -m 0755 $(TARGET_DIR)/usr/bin/bt_load_broadcom_firmware $(TARGET_DIR)/usr/bin/bt_init.sh
endef

define RKWIFIBT_REALTEK_INSTALL
    $(INSTALL) -D -m 0755 $(@D)/bin/$(RKARCH)/rtwpriv $(TARGET_DIR)/usr/bin/
    $(INSTALL) -D -m 0755 $(@D)/S66load_wifi_modules $(TARGET_DIR)/etc/init.d/
    $(INSTALL) -D -m 0755 $(@D)/realtek/rtk_hciattach/rtk_hciattach $(TARGET_DIR)/usr/bin/rtk_hciattach
    $(INSTALL) -D -m 0755 $(@D)/bin/$(RKARCH)/* $(TARGET_DIR)/usr/bin/
    $(INSTALL) -D -m 0644 $(@D)/realtek/$(BR2_PACKAGE_RKWIFIBT_CHIPNAME)/* $(TARGET_DIR)/lib/firmware/rtlbt/
    $(INSTALL) -D -m 0644 $(@D)/realtek/$(BR2_PACKAGE_RKWIFIBT_CHIPNAME)/mp_* $(TARGET_DIR)/lib/firmware/rtlbt/
    $(INSTALL) -D -m 0644 $(@D)/realtek/$(BR2_PACKAGE_RKWIFIBT_CHIPNAME)/mp_* $(TARGET_DIR)/lib/firmware/
    $(INSTALL) -D -m 0755 $(@D)/bt_realtek* $(TARGET_DIR)/usr/bin/
    $(INSTALL) -D -m 0644 $(@D)/realtek/bluetooth_uart_driver/hci_uart.ko $(TARGET_DIR)/usr/lib/modules/hci_uart.ko
    $(INSTALL) -D -m 0755 $(@D)/bt_load_rtk_firmware $(TARGET_DIR)/usr/bin/
    $(SED) 's/BT_TTY_DEV/\/dev\/$(BT_TTY_DEV)/g' $(TARGET_DIR)/usr/bin/bt_load_rtk_firmware
    $(INSTALL) -D -m 0755 $(TARGET_DIR)/usr/bin/bt_load_rtk_firmware $(TARGET_DIR)/usr/bin/bt_pcba_test
    $(INSTALL) -D -m 0755 $(TARGET_DIR)/usr/bin/bt_load_rtk_firmware $(TARGET_DIR)/usr/bin/bt_init.sh
endef

define RKWIFIBT_ROCKCHIP_INSTALL
    $(INSTALL) -D -m 0644 $(@D)/firmware/rockchip/WIFI_FIRMWARE/rk912* $(TARGET_DIR)/lib/firmware/
    $(INSTALL) -D -m 0755 $(@D)/S66load_wifi_rk912_modules $(TARGET_DIR)/etc/init.d/
endef

define RKWIFIBT_BUILD_CMDS
    mkdir -p $(TARGET_DIR)/system/lib/modules/
    $(TOPDIR)/../build.sh modules
    find $(TOPDIR)/../kernel/drivers/net/wireless/rockchip_wlan/* -name $(BR2_PACKAGE_RKWIFIBT_WIFI_KO) | xargs -n1 -i cp {} $(TARGET_DIR)/system/lib/modules/
    $(TARGET_CC) -o $(@D)/brcm_tools/brcm_patchram_plus1 $(@D)/brcm_tools/brcm_patchram_plus1.c
    $(TARGET_CC) -o $(@D)/brcm_tools/dhd_priv $(@D)/brcm_tools/dhd_priv.c
    $(TARGET_CC) -o $(@D)/src/rk_wifi_init $(@D)/src/rk_wifi_init.c
    $(MAKE) -C $(@D)/realtek/rtk_hciattach/ CC=$(TARGET_CC)
    $(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(TOPDIR)/../kernel/ M=$(@D)/realtek/bluetooth_uart_driver ARCH=$(RK_ARCH) CROSS_COMPILE=$(RKWIFIBT_TOOLCHAIN)
endef

ifeq ($(BR2_PACKAGE_RKWIFIBT_VENDOR), "BROADCOM")
define RKWIFIBT_INSTALL_TARGET_CMDS
    $(RKWIFIBT_INSTALL_COMMON)
    $(RKWIFIBT_BROADCOM_INSTALL)
endef
endif

ifeq ($(BR2_PACKAGE_RKWIFIBT_VENDOR), "CYPRESS")
define RKWIFIBT_INSTALL_TARGET_CMDS
    $(RKWIFIBT_INSTALL_COMMON)
    $(RKWIFIBT_BROADCOM_INSTALL)
endef
endif

ifeq ($(BR2_PACKAGE_RKWIFIBT_VENDOR), "REALTEK")
define RKWIFIBT_INSTALL_TARGET_CMDS
    $(RKWIFIBT_INSTALL_COMMON)
    $(RKWIFIBT_REALTEK_INSTALL)
endef
endif

ifeq ($(BR2_PACKAGE_RKWIFIBT_VENDOR), "ROCKCHIP")
define RKWIFIBT_INSTALL_TARGET_CMDS
    $(RKWIFIBT_INSTALL_COMMON)
    $(RKWIFIBT_ROCKCHIP_INSTALL)
endef
endif

$(eval $(generic-package))
