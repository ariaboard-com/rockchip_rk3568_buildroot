#!/bin/sh

CMD=`realpath $0`
BUILDROOT_DIR=`pwd`
SDK_DIR=`dirname $BUILDROOT_DIR`
RV1108_DEVICES_BOARD_DIR=$SDK_DIR/device/rockchip/$RK_TARGET_PRODUCT/overlay-board

echo "======================================================="
echo "SDK_DIR                  = $SDK_DIR"
echo "BUILDROOT_DIR            = $BUILDROOT_DIR"
echo "RV1108_DEVICES_BOARD_DIR = $RV1108_DEVICES_BOARD_DIR"
echo "RK_TARGET_PRODUCT        = $RK_TARGET_PRODUCT"
echo "RK_TARGET_BOARD_VERSION  = $RK_TARGET_BOARD_VERSION"
echo "======================================================="

rm $TARGET_DIR/etc/init.d/S01logging
rm $TARGET_DIR/etc/init.d/S20urandom
rm $TARGET_DIR/etc/init.d/S40network

if [ ! -d  $RV1108_DEVICES_BOARD_DIR ]; then
        echo "$RV1108_DEVICES_BOARD_DIR no exit"
	return
else
	cd $RV1108_DEVICES_BOARD_DIR
fi

if [ -d  rv1108-$RK_TARGET_BOARD_VERSION ]; then
	echo "copy rv1108-$RK_TARGET_BOARD_VERSION"
	rsync -av --exclude rv1108-$RK_TARGET_BOARD_VERSION/userdata rv1108-$RK_TARGET_BOARD_VERSION/* $TARGET_DIR/
else
	echo "rv1108-$RK_TARGET_BOARD_VERSION no exit"
fi

cd $BUILDROOT_DIR
