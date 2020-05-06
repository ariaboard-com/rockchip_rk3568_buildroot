#!/bin/bash

BUILDROOT=$(pwd)
TARGET=$1
NAME=$(whoami)
HOST=$(hostname)
KERNEL_DIR=$BUILDROOT/../kernel
OUTPUT_DIR=$TARGET/../


mkdir -p $TARGET/overlayfs/rw
mkdir -p $TARGET/overlayfs/ro
mkdir -p $TARGET/overlayfs/ovlfs

rm -rf $TARGET/lib/udev/v4l_id
rm -f $TARGET/lib/udev/rules.d/75-net-description.rules
rm -f $TARGET/lib/udev/rules.d/60-persistent-input.rules
rm -f $TARGET/lib/udev/rules.d/70-mouse.rules
rm -f $TARGET/lib/udev/rules.d/70-joystick.rules
rm -f $TARGET/lib/udev/rules.d/64-btrfs.rules
rm -f $TARGET/lib/udev/rules.d/60-persistent-storage-tape.rules
rm -f $TARGET/lib/udev/rules.d/60-serial.rules
rm -f $TARGET/lib/udev/rules.d/60-persistent-storage.rules
rm -f $TARGET/lib/udev/rules.d/70-touchpad.rules
rm -f $TARGET/lib/udev/rules.d/60-block.rules
rm -f $TARGET/lib/udev/rules.d/60-drm.rules
rm -f $TARGET/lib/udev/rules.d/60-sensor.rules
rm -f $TARGET/lib/udev/rules.d/80-net-name-slot.rules
rm -f $TARGET/lib/udev/rules.d/80-drivers.rules
rm -f $TARGET/lib/udev/rules.d/60-cdrom_id.rules
rm -f $TARGET/lib/udev/rules.d/60-evdev.rules
rm -f $TARGET/lib/udev/rules.d/60-persistent-v4l.rules
rm -f $TARGET/lib/udev/rules.d/75-probe_mtd.rules
rm -f $TARGET/lib/udev/rules.d/60-persistent-alsa.rules
rm -f $TARGET/lib/udev/rules.d/78-sound-card.rules
rm -f $TARGET/lib/udev/rules.d/50-udev-default.rules
rm -f $TARGET/lib/udev/rules.d/60-input-id.rules

rm -rf $TARGET/lib/udev/scsi_id
rm -rf $TARGET/lib/udev/ata_id
rm -rf $TARGET/lib/udev/collect
rm -rf $TARGET/lib/udev/cdrom_id
rm -rf $TARGET/lib/udev/mtd_probe
rm -rf $TARGET/etc/init.d

make modules_install -C $KERNEL_DIR ARCH=$RK_ARCH INSTALL_MOD_PATH=$TARGET INSTALL_MOD_STRIP=1
if [ $? -ne 0 ]; then
	echo -e "ERROR: ====================== Please build kernel first!!! ====================="
	exit 1
fi
KERNEL_VERSION=`make -C $KERNEL_DIR kernelversion |grep -v make`
MODULES_TMP_TAR=$OUTPUT_DIR/modules.ko.tar
( cd $TARGET && tar cf $MODULES_TMP_TAR ` find lib/modules/$KERNEL_VERSION -type f \
	-name dw_mmc-rockchip.ko \
	-o -name dw_mmc-pltfm.ko \
	-o -name dw_mmc.ko       \
	-o -name mmc_block.ko    \
	-o -name mmc_core.ko     \
	-o -name modules.dep ` )
( cd $TARGET && rm -rf $TARGET/lib/modules/$KERNEL_VERSION && tar xf $MODULES_TMP_TAR&& rm $MODULES_TMP_TAR )

exit 0
