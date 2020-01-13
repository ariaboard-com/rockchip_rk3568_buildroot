################################################################################
#
# rknpu
#
################################################################################
RKNPU_VERSION = 1.2.1
RKNPU_SITE_METHOD = local
RKNPU_SITE = $(TOPDIR)/../external/rknpu
NPU_TEST_FILE = $(@D)/test

ifeq ($(BR2_PACKAGE_RKNPU_PCIE),y)
NPU_KO_FILE = galcore_rk3399pro-npu-pcie.ko
else ifeq ($(BR2_PACKAGE_RK3399PRO_NPU),y)
NPU_KO_FILE = galcore_rk3399pro-npu.ko
else ifeq ($(BR2_PACKAGE_RK1806),y)
NPU_KO_FILE = galcore_rk1806.ko
else
NPU_KO_FILE = galcore.ko
endif

ifeq ($(BR2_arm),y)
NPU_PLATFORM = linux-armhf
else
NPU_PLATFORM = linux-aarch64
endif

ifeq ($(BR2_PACKAGE_PYTHON_RKNN), y)
BUILD_PYTHON_RKNN=y
endif

define RKNPU_INSTALL_TARGET_CMDS
    mkdir -p $(TARGET_DIR)/lib/modules/
    mkdir -p $(TARGET_DIR)/usr/share/npu/
    $(INSTALL) -D -m 0644 $(@D)/drivers/npu_ko/$(NPU_KO_FILE) $(TARGET_DIR)/lib/modules/galcore.ko
    cp -r $(@D)/drivers/common/* $(TARGET_DIR)/
    cp -r $(@D)/drivers/common/* $(STAGING_DIR)/
    cp -r $(@D)/drivers/$(NPU_PLATFORM)/* $(TARGET_DIR)/
    cp -r $(@D)/drivers/$(NPU_PLATFORM)/* $(STAGING_DIR)/

    if [ -e "$(@D)/test" ]; then \
        cp -r $(@D)/test $(TARGET_DIR)/usr/share/npu; \
    fi

    if [ x${BUILD_PYTHON_RKNN} != x ]; then \
        cp -r $(@D)/rknn/python/rknn $(TARGET_DIR)/usr/lib/python3.6/site-packages/; \
    fi

endef

$(eval $(generic-package))
