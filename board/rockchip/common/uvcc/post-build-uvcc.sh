#!/bin/bash

BUILDROOT=$(pwd)
TARGET=$1
NAME=$(whoami)
HOST=$(hostname)
KERNEL_DIR=$BUILDROOT/../kernel
OUTPUT_DIR=$TARGET/../


rm -rf $TARGET/usr/lib/libstdc++.so*
echo "==========build oem to rootfs=========="
echo "$BUILDROOT_DIR"
echo "$SDK_DIR"
echo "$RK_TARGET_PRODUCT"
echo "$RK_CFG_BUILDROOT"

rm -rf $SDK_DIR/buildroot/output/$RK_CFG_BUILDROOT/target/oem/
cp -rf $SDK_DIR/buildroot/output/$RK_CFG_BUILDROOT/oem/. $SDK_DIR/buildroot/output/$RK_CFG_BUILDROOT/target/oem/

exit 0
