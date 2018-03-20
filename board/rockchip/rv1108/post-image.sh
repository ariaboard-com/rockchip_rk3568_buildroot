#!/bin/sh

BOARD_DIR="$(dirname $0)"
KERNELIMAGE=${HOST_DIR}/usr/bin/kernelimage
FIRMWAREMERGER=${HOST_DIR}/usr/bin/firmwareMerger

DTB=$2

cp ${BOARD_DIR}/setting.ini ${BINARIES_DIR}/
cp ${BOARD_DIR}/rv1108ddr.bin ${BINARIES_DIR}/
cp ${BOARD_DIR}/rv1108loader.bin ${BINARIES_DIR}/
cp ${BOARD_DIR}/kernelimage $KERNELIMAGE
cp ${BOARD_DIR}/firmwareMerger $FIRMWAREMERGER

$KERNELIMAGE --pack --kernel ${BINARIES_DIR}/zImage.$DTB ${BINARIES_DIR}/kernel.img 0x62000000 > /dev/null && \
rm -f $BINARIES_DIR/zImage-dtb  && \
$FIRMWAREMERGER -p ${BINARIES_DIR}/setting.ini ${BINARIES_DIR}/

exit $?
