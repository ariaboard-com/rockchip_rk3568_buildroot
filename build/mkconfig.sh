#!/bin/bash

BUILD_DIR=$(cd `dirname $0`; pwd)
if [ -h $0 ]
then
        CMD=$(readlink $0)
        BUILD_DIR=$(dirname $CMD)
fi
cd $BUILD_DIR/../../
TOP_DIR=$(pwd)
cd - > /dev/null
CONIFG_DIR=$TOP_DIR/buildroot/configs
CONFIG=$1
LINE=$(head -n 1 $CONIFG_DIR/$CONFIG)
ROCKCHIP=$(echo "$LINE" | cut -c1-8)
TARGET_DIR=${CONFIG%_defconfig}
mkdir -p $TOP_DIR/buildroot/output/$TARGET_DIR
DST_CONFIG=$TOP_DIR/buildroot/output/$TARGET_DIR/.rockchipconfig
SRC_CONFIG=$TOP_DIR/buildroot/configs/$CONFIG
echo "dst:$DST_CONFIG"
echo "src:$SRC_CONFIG"
if [ $ROCKCHIP = rockchip ]
then
	rm $DST_CONFIG 2>/dev/null
	for line in $(cat $SRC_CONFIG)
	do
		if [ -f $TOP_DIR/buildroot/configs/${line} ]
		then 
			echo "merge $TOP_DIR/buildroot/configs/${line}"
			cat $TOP_DIR/buildroot/configs/${line} >> $DST_CONFIG
		else
			echo "${line}" >> $DST_CONFIG
		fi
	done
else
	cp $SRC_CONFIG $DST_CONFIG
fi

