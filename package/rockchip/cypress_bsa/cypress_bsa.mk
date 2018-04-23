CYPRESS_BSA_SITE = $(TOPDIR)/../external/bluetooth_bsa
CYPRESS_BSA_SITE_METHOD = local

CYPRESS_BSA_PATH = 3rdparty/embedded/bsa_examples/linux
CYPRESS_BSA_LIBBSA = libbsa
CYPRESS_BSA_APP = app_manager app_av app_avk app_ble app_dg \
				 app_hl app_hs app_tm app_common app_tm \
				 app_socket app_hd app_hh

CYPRESS_BSA_BUILD_TYPE = arm64

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

	mkdir -p $(TARGET_DIR)/data/bsa
	mkdir -p $(TARGET_DIR)/data/bsa/config
	#$(INSTALL) -D -m 755 $(@D)/test_files/av/44k8bpsStereo.wav $(TARGET_DIR)/etc/bsa
	#$(INSTALL) -D -m 755 $(@D)/test_files/dg/tx_test_file.txt $(TARGET_DIR)/etc/bsa
	$(INSTALL) -D -m 755 package/rockchip/cypress_bsa/S44bluetooth $(TARGET_DIR)/etc/init.d

endef

$(eval $(generic-package))
