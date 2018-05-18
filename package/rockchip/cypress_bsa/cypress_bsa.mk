CYPRESS_BSA_SITE = $(TOPDIR)/../external/bluetooth_bsa
CYPRESS_BSA_SITE_METHOD = local

CYPRESS_BSA_PATH = 3rdparty/embedded/bsa_examples/linux
CYPRESS_BSA_LIBBSA = libbsa
CYPRESS_BSA_APP = app_manager app_av app_avk app_ble app_dg \
				 app_hl app_hs app_tm app_tm app_socket \
				 app_hd app_hh app_ble_wifi_introducer

CYPRESS_BSA_BUILD_TYPE = arm64

ifeq ($(BR2_PACKAGE_CYPRESS_BSA_AWCM256),y)
	BTFIRMWARE = BCM4345C0.hcd
endif

ifeq ($(BR2_PACKAGE_CYPRESS_BSA_AWNB197),y)
	BTFIRMWARE = BCM4343A1.hcd
endif

define CYPRESS_BSA_BUILD_CMDS
	$(MAKE) -C $(@D)/$(CYPRESS_BSA_PATH)/$(CYPRESS_BSA_LIBBSA)/build CPU=$(CYPRESS_BSA_BUILD_TYPE) ARMGCC=$(TARGET_CC)
	for ff in $(CYPRESS_BSA_APP); do \
		$(MAKE) -C $(@D)/$(CYPRESS_BSA_PATH)/$$ff/build CPU=$(CYPRESS_BSA_BUILD_TYPE) ARMGCC=$(TARGET_CC) BSASHAREDLIB=TRUE; \
	done

endef

define CYPRESS_BSA_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/server/$(CYPRESS_BSA_BUILD_TYPE)/bsa_server \
		$(TARGET_DIR)/usr/bin/bsa_server
	$(INSTALL) -D -m 755 $(@D)/$(CYPRESS_BSA_PATH)/$(CYPRESS_BSA_LIBBSA)/build/$(CYPRESS_BSA_BUILD_TYPE)/sharedlib/libbsa.so \
		$(TARGET_DIR)/usr/lib/libbsa.so
	for ff in $(CYPRESS_BSA_APP); do \
		$(INSTALL) -D -m 755 $(@D)/$(CYPRESS_BSA_PATH)/$${ff}/build/$(CYPRESS_BSA_BUILD_TYPE)/$${ff} $(TARGET_DIR)/usr/bin/${ff}; \
	done

	mkdir -p $(TARGET_DIR)/etc/bsa_file
	$(INSTALL) -D -m 755 $(TOPDIR)/../external/bluetooth_bsa/test_files/av/8k8bpsMono.wav $(TARGET_DIR)/etc/bsa_file/
	$(INSTALL) -D -m 755 $(TOPDIR)/../external/bluetooth_bsa/test_files/av/8k16bpsStereo.wav $(TARGET_DIR)/etc/bsa_file/
	$(INSTALL) -D -m 755 package/rockchip/cypress_bsa/bsa_bt_sink.sh $(TARGET_DIR)/usr/bin/
	$(INSTALL) -D -m 755 package/rockchip/cypress_bsa/bsa_bt_source.sh $(TARGET_DIR)/usr/bin/
	sed -i 's/BTFIRMWARE_PATH/\/system\/etc\/firmware\/$(BTFIRMWARE)/g' $(TARGET_DIR)/usr/bin/bsa_bt_sink.sh
	sed -i 's/BTFIRMWARE_PATH/\/system\/etc\/firmware\/$(BTFIRMWARE)/g' $(TARGET_DIR)/usr/bin/bsa_bt_source.sh

endef

$(eval $(generic-package))
