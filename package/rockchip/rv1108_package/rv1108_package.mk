include package/rockchip/rv1108_package/.BoardConfig.mk
include $(sort $(wildcard package/rockchip/rv1108_package/*/*.mk))

RV_SDK_DIR=$(TOPDIR)/..
RV_OUTPUT_DIR=$(TOPDIR)/output/rockchip_rv1108
RV_IMAGE_DIR=$(RV_OUTPUT_DIR)/images
RV_LOADER_DIR=$(TOPDIR)/../loader
RV_TARGET_USB_BOOT_DIR=$(TOPDIR)/../tools/Windows_Upgrade_Tool/AndroidTool_Release_v2.65/Image/
RV_KERNEL_DIR=$(TOPDIR)/../kernel
RV_USERDATA_DIR=$(RV_OUTPUT_DIR)/userdata
RV_BUILD_DIR=$(TOPDIR)/../build
RV_BOARD_OVAERLAY_DIR=$(TOPDIR)/../device/rockchip/$(RK_TARGET_PRODUCT)
RV_BOARD_USERDATA_DIR=$(RV_BOARD_OVAERLAY_DIR)/userdata
RV_USERDATA_JFFS2_BCSIZE=0x$(shell echo "obase=16;$(RK_USERDATA_FILESYSTEM_SIZE)" | cut -d 'M' -f1 | bc)00000


### build loader
ifeq ($(RK_STORAGE_TYPE),emmc)
    EMMC_ONLY=1
else ifeq ($(RK_STORAGE_TYPE),nor) 
    NOR_ONLY=1
else
    ALL_SUPPORT=1
endif

LOADER_BUILD_MAKE_ENV += \
    POWER_HOLD_GPIO_GROUP=$(RK_LOADER_POWER_HOLD_GPIO_GROUP) \
    POWER_HOLD_GPIO_INDEX=$(RK_LOADER_POWER_HOLD_GPIO_INDEX) \
    EMMC_TURNING_DEGREE=$(RK_LOADER_EMMC_TURNING_DEGREE) \
    BOOTPART_SELECT=$(RK_LOADER_BOOTPART_SELECT) \
    EMMC_ONLY=$(EMMC_ONLY) \
    NOR_ONLY=$(NOR_ONLY) \
    ALL_SUPPORT=$(ALL_SUPPORT)

loader:
	make -C $(RV_LOADER_DIR) PLAT=rv1108usbplug
	make -C $(RV_LOADER_DIR) PLAT=rv1108loader $(LOADER_BUILD_MAKE_ENV)
	cp $(RV_LOADER_DIR)/rk_tools/bin/rv11/RV1108_DDR3.bin  $(RV_IMAGE_DIR)/rv1108ddr.bin
	cp $(RV_LOADER_DIR)/Project/rv1108loader/Debug/bin/rv1108loader.bin $(RV_IMAGE_DIR)/
	cp $(RV_LOADER_DIR)/RV1108_usb_boot_V1.24.bin $(RV_TARGET_USB_BOOT_DIR)/RV1108_usb_boot.bin

loader-clean:
	make -C $(RV_LOADER_DIR) PLAT=rv1108usbplug clean
	make -C $(RV_LOADER_DIR) PLAT=rv1108loader clean


### build kernel
kernel:
	$(info RK_KERNEL_DEFCONFIG=$(RK_KERNEL_DEFCONFIG))
	$(info RK_ARCH=$(RK_ARCH))
	make -C $(RV_KERNEL_DIR) ARCH=$(RK_ARCH) $(RK_KERNEL_DEFCONFIG)
	make -C $(RV_KERNEL_DIR) ARCH=$(RK_ARCH) $(RK_KERNEL_DTS).img -j$(RK_JOBS)
	make -C $(RV_KERNEL_DIR) modules
	make -C $(RV_KERNEL_DIR) INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=$(RV_OUTPUT_DIR)/tmp_modules modules_install
	mkdir -p $(RV_OUTPUT_DIR)/modules
	find $(RV_OUTPUT_DIR)/tmp_modules -name "*.ko" | xargs cp -t  $(RV_OUTPUT_DIR)/modules
	rm -fr $(RV_OUTPUT_DIR)/tmp_modules

kernel-clean:
	make -C $(RV_KERNEL_DIR) clean

### build userdata
RK_USERDATA_FILESYSTEM_TYPE=jffs2
ifeq ($(RK_USERDATA_FILESYSTEM_TYPE),ext4)
    MKDATAIMAGE = make_ext4fs -l $(RK_USERDATA_FILESYSTEM_SIZE) $(RV_IMAGE_DIR)/userdata.img $(RV_USERDATA_DIR)/
else ifeq ($(RK_USERDATA_FILESYSTEM_TYPE),jffs2)
    MKDATAIMAGE = mkfs.jffs2 -d $(RV_OUTPUT_DIR)/userdata/ -o $(RV_IMAGE_DIR)/userdata.img -e 0x10000 --pad=$(RV_USERDATA_JFFS2_BCSIZE) -n
else
    MKDATAIMAGE = make_ext4fs -l $(RK_USERDATA_FILESYSTEM_SIZE) $(RV_IMAGE_DIR)/userdata.img $(RV_USERDATA_DIR)/
endif

userdata:
	if [ ! -d $(RV_USERDATA_DIR) ]; then mkdir -p $(RV_USERDATA_DIR); else rm -fr $(RV_USERDATA_DIR)/*; fi
	if [ -f $(RV_IMAGE_DIR)/userdata.img ]; then rm $(RV_IMAGE_DIR)/userdata.img; fi
	cp -fr $(RV_BOARD_USERDATA_DIR)/* $(RV_USERDATA_DIR)
	$(MKDATAIMAGE)

fw:
	if [ ! -L $(RV_SDK_DIR)/output ]; then ln -s $(TOPDIR)/output $(RV_SDK_DIR)/output; fi
	if [ -f $(RV_IMAGE_DIR)/dtb ]; then rm $(RV_IMAGE_DIR)/dtb; fi
	cp $(RV_KERNEL_DIR)/arch/arm/boot/dts/$(RK_KERNEL_DTS).dtb $(RV_IMAGE_DIR)/dtb
	if [ -f $(RV_IMAGE_DIR)/kernel.img ]; then rm $(RV_IMAGE_DIR)/kernel.img; fi
	$(RV_BUILD_DIR)/kernelimage --pack --kernel $(RV_KERNEL_DIR)/arch/arm/boot/Image $(RV_IMAGE_DIR)/kernel.img 0x60308000 > /dev/null
	if [ -f $(RV_IMAGE_DIR)/Firmware.img ]; then rm $(RV_IMAGE_DIR)/Firmware.img; fi
	$(RV_BUILD_DIR)/firmwareMerger -p $(RV_BUILD_DIR)/setting_ini/$(RK_SETTING_INI) $(RV_IMAGE_DIR)

fww:
	cd $(TOPDIR)/../tools/Linux_Upgrade_Tool_* && ./linux_upgrade.sh

clean: loader-clean kernel-clean

all: loader kernel userdata fw

