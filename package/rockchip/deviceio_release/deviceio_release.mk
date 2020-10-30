################################################################################
#
# deviceio_release
#
################################################################################
DEVICEIO_RELEASE_SITE = $(TOPDIR)/../external/deviceio_release
DEVICEIO_RELEASE_SITE_METHOD = local
DEVICEIO_RELEASE_INSTALL_STAGING = YES
DEVICEIO_RELEASE_DEPENDENCIES += wpa_supplicant alsa-lib
BT_TTY_DEV = $(call qstrip,$(BR2_PACKAGE_RKWIFIBT_BTUART))
ifeq ($(call qstrip,$(BR2_ARCH)), arm)
        DEVICEIOARCH = lib32
	BSAARCH = arm
else ifeq ($(call qstrip, $(BR2_ARCH)), aarch64)
        DEVICEIOARCH = lib64
	BSAARCH = arm64
endif

ifeq ($(call qstrip,$(BR2_PACKAGE_RKWIFIBT_VENDOR)), REALTEK)
	LIBDEVICEIOSO = bluez/libDeviceIo.so
	DEVICEIO_RELEASE_DEPENDENCIES += readline bluez5_utils libglib2 bluez-alsa
else ifeq ($(call qstrip,$(BR2_PACKAGE_RKWIFIBT_VENDOR)), BROADCOM)
	LIBDEVICEIOSO = broadcom/libDeviceIo.so
else ifeq ($(call qstrip,$(BR2_PACKAGE_RKWIFIBT_VENDOR)), CYPRESS)
	LIBDEVICEIOSO = cypress/libDeviceIo.so
else
	LIBDEVICEIOSO = libDeviceIo_fake.so
endif

define DEVICEIO_RELEASE_INSTALL_COMMON
	$(INSTALL) -D -m 0755 $(@D)/bsa_bt_sink.sh $(TARGET_DIR)/usr/bin/bsa_bt_sink.sh
	$(INSTALL) -D -m 0755 $(@D)/bsa_server.sh $(TARGET_DIR)/usr/bin/bsa_server.sh
	sed -i 's/BT_TTY_DEV/\/dev\/$(BT_TTY_DEV)/g' $(TARGET_DIR)/usr/bin/bsa_server.sh
	$(INSTALL) -D -m 0755 $(STAGING_DIR)/usr/bin/deviceio_test $(TARGET_DIR)/usr/bin/deviceio_test
endef

define DEVICEIO_RELEASE_INSTALL_TARGET_CMDS
	$(DEVICEIO_RELEASE_INSTALL_COMMON)
endef

define DEVICEIO_PRE_BUILD_HOOK
	$(INSTALL) -D -m 0755 $(@D)/DeviceIO/$(DEVICEIOARCH)/$(LIBDEVICEIOSO) $(TARGET_DIR)/usr/lib/libDeviceIo.so
	$(INSTALL) -D -m 0755 $(@D)/DeviceIO/$(DEVICEIOARCH)/$(LIBDEVICEIOSO) $(STAGING_DIR)/usr/lib/libDeviceIo.so
	$(DEVICEIO_RELEASE_PRE_INSTALL_BSA)
endef

DEVICEIO_RELEASE_PRE_BUILD_HOOKS += DEVICEIO_PRE_BUILD_HOOK

DEVICEIO_RELEASE_CONF_OPTS += -DCMAKE_INSTALL_STAGING=$(STAGING_DIR)

$(eval $(cmake-package))
