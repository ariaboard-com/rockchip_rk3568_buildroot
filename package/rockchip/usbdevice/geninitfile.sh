#!/bin/bash

make_config_string()
{
	tmp=$CONFIG_STRING
	if [ -n "$CONFIG_STRING" ]; then
		CONFIG_STRING=${tmp}_${1}
	else
		CONFIG_STRING=$1
	fi
}

echo $TARGET_DIR
CONFIG_FILE=$TARGET_DIR/../.config
MASS_STORAGE=BR2_PACKAGE_USB_MASS_STORAGE
MTP=BR2_PACKAGE_MTP
ADB=BR2_PACKAGE_ANDROID_TOOLS_ADBD
MULT_FUNCTIONS=0
SOURCE_DIR=$1

CONFIG_MASS_STORAGE=`grep -i "$MASS_STORAGE" $CONFIG_FILE | grep =y`
CONFIG_MTP=`grep -i "$MTP" $CONFIG_FILE | grep =y`
CONFIG_ADB=`grep -i "$ADB" $CONFIG_FILE | grep =y`

if [ -n "$CONFIG_MASS_STORAGE" ]; then
	MULT_FUNCTIONS=`expr $MULT_FUNCTIONS + 1`
	sed -i \
	"/INIT_FUNCTIONS/a\
	\	mkdir /sys/kernel/config/usb_gadget/rockchip/functions/mass_storage.0\n\
	echo /dev/disk/by-partlabel/userdata > /sys/kernel/config/usb_gadget/rockchip/functions/mass_storage.0/lun.0/file\n\
	ln -s /sys/kernel/config/usb_gadget/rockchip/functions/mass_storage.0 /sys/kernel/config/usb_gadget/rockchip/configs/b.1/f$MULT_FUNCTIONS\
	" $SOURCE_DIR/S50usbdevice
	make_config_string ums
fi

if [ -n "$CONFIG_MTP" ]; then
	MULT_FUNCTIONS=`expr $MULT_FUNCTIONS + 1`
	sed -i \
	"/INIT_FUNCTIONS/a\
	\	mkdir /sys/kernel/config/usb_gadget/rockchip/functions/mtp.gs0\n\
	ln -s /sys/kernel/config/usb_gadget/rockchip/functions/mtp.gs0 /sys/kernel/config/usb_gadget/rockchip/configs/b.1/f$MULT_FUNCTIONS\
	" $SOURCE_DIR/S50usbdevice
	sed -i \
	"/START_APP_AFTER_UDC/a\
	\	sleep 1 && mtp-server&\
	" $SOURCE_DIR/S50usbdevice
	make_config_string mtp
fi

if [ -n "$CONFIG_ADB" ]; then
	MULT_FUNCTIONS=`expr $MULT_FUNCTIONS + 1`
	sed -i \
	"/INIT_FUNCTIONS/a\
	\	mkdir /sys/kernel/config/usb_gadget/rockchip/functions/ffs.adb\n\
	ln -s /sys/kernel/config/usb_gadget/rockchip/functions/ffs.adb /sys/kernel/config/usb_gadget/rockchip/configs/b.1/f$MULT_FUNCTIONS\
	" $SOURCE_DIR/S50usbdevice

	sed -i \
	"/START_APP_BEFORE_UDC/a\
	\	mkdir -p /dev/usb-ffs/adb\n\
	mount -o uid=2000,gid=2000 -t functionfs adb /dev/usb-ffs/adb\n\
	export service_adb_tcp_port=5555\n\
	adbd&\n\
	sleep 1 &&\n\
	" $SOURCE_DIR/S50usbdevice
	make_config_string adb
fi

case "$CONFIG_STRING" in
    ums)
        IDPRODUCT=0x0000
        ;;
    mtp)
        IDPRODUCT=0x0001
        ;;
    adb)
        IDPRODUCT=0x0006
        ;;
    mtp_adb)
        IDPRODUCT=0x0011
        ;;
    ums_adb)
        IDPRODUCT=0x0018
        ;;
    *)
        IDPRODUCT=0x0019
esac

sed -i \
"/ADD_IDPRODUCT/a\
\	echo ${IDPRODUCT} > /sys/kernel/config/usb_gadget/rockchip/idProduct\
" $SOURCE_DIR/S50usbdevice

sed -i \
"/INIT_CONFIG/a\
\	echo \"$CONFIG_STRING\" > /sys/kernel/config/usb_gadget/rockchip/configs/b.1/strings/0x409/configuration\
" $SOURCE_DIR/S50usbdevice
