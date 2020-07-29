#!/bin/bash

BUILDROOT_DIR=`pwd`
SDK_DIR=`dirname $BUILDROOT_DIR`

export LIBDIR=$TARGET_DIR/usr/lib/
export HEADER_DIR=$STAGING_DIR/usr/include
export BSPDIR=$TARGET_DIR/../BSP

echo "$BUILDROOT_DIR"
echo "$SDK_DIR"
echo "$LIBDIR"

rm -rf $BSPDIR
mkdir $BSPDIR
mkdir -p $BSPDIR/lib
mkdir -p $BSPDIR/include
mkdir -p $BSPDIR/example
mkdir -p $BSPDIR/resource

cd $BSPDIR
# copy libs
cp $LIBDIR/libdrm.* ./lib/ -dv
cp $LIBDIR/libv4l2.* ./lib/ -dv
cp $LIBDIR/libv4lconvert.* ./lib -dv

cp $LIBDIR/librga.* ./lib/ -dv
cp $LIBDIR/librockchip_mpp.* ./lib/ -dv

cp $LIBDIR/libasound.* ./lib/ -dv
cp $LIBDIR/libavformat.* ./lib/ -dv
cp $LIBDIR/libavcodec.* ./lib/ -dv
cp $LIBDIR/libswresample.* ./lib/ -dv
cp $LIBDIR/libavutil.* ./lib/ -dv

cp $LIBDIR/libRKAP* ./lib/ -dv
cp $LIBDIR/libmd_share.so ./lib/ -dv

cp $LIBDIR/librkaiq.* ./lib/ -dv
cp $LIBDIR/libeasymedia.* ./lib/ -dv

#copy headers
cp $HEADER_DIR/rga ./include/ -vrf
#mkdir ./include/rkaiq
#cp $HEADER_DIR/rkaiq/uAPI ./include/rkaiq/ -vrf
cp $HEADER_DIR/rkaiq ./include/ -rf
cp $SDK_DIR/external/rkmedia/include/rkmedia ./include/ -vrf

#copy examples
cp $SDK_DIR/external/rkmedia/test/c_api/* ./example/ -vrf

#copy resource, like camera aiq files
cp $SDK_DIR/external/camera_engine_rkaiq/iqfiles ./resource -vrf

cd -
