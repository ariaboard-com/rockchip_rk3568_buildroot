#!/bin/sh

BOARD_DIR="$(dirname $0)"
BR_ROOT=$PWD
TARGET_DIR=$BR_ROOT/output/target

install -d -m 0755 $TARGET_DIR/mnt/sdcard
install -d -m 0755 $TARGET_DIR/mnt/udisk
