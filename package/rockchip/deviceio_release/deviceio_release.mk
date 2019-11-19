################################################################################
#
# deviceio_release
#
################################################################################
DEVICEIO_RELEASE_SITE = $(TOPDIR)/../external/deviceio_release
DEVICEIO_RELEASE_SITE_METHOD = local
DEVICEIO_RELEASE_INSTALL_STAGING = YES

ifeq ($(call qstrip,$(BR2_PACKAGE_RKWIFIBT_VENDOR)), REALTEK)
	LIBDEVICEIOSO = libDeviceIo_bluez.so
	DEVICEIO_RELEASE_DEPENDENCIES += readline bluez5_utils libglib2
else ifeq ($(call qstrip,$(BR2_PACKAGE_RKWIFIBT_VENDOR)), BROADCOM)
	LIBDEVICEIOSO = libDeviceIo_broadcom.so
	DEVICEIO_RELEASE_DEPENDENCIES += broadcom_bsa
else
	LIBDEVICEIOSO = libDeviceIo_cypress.so
	DEVICEIO_RELEASE_DEPENDENCIES += cypress_bsa
endif

DEVICEIO_RELEASE_DEPENDENCIES += wpa_supplicant alsa-lib

ifeq ($(call qstrip,$(BR2_ARCH)), arm)
	DEVICEIOARCH = lib32
else ifeq ($(call qstrip, $(BR2_ARCH)), aarch64)
	DEVICEIOARCH = lib64
endif

define DEVICEIO_RELEASE_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/DeviceIO/$(DEVICEIOARCH)/$(LIBDEVICEIOSO) $(TARGET_DIR)/usr/lib/libDeviceIo.so
endef

$(eval $(generic-package))
