#!/bin/sh

BOARD_DIR="$(dirname $0)"
BR_ROOT=$PWD
TARGET_DIR=$BR_ROOT/output/target

#need to overwrite mesa libs,so do the copy during post build.
for filename in `ls $BOARD_DIR/lib/gpu`
do
if test -e $TARGET_DIR/usr/lib/$filename
then
rm $TARGET_DIR/usr/lib/$filename
fi
done
cp -d $BOARD_DIR/lib/gpu/* $TARGET_DIR/usr/lib/

#for files in bin directory
for filename in `ls $BOARD_DIR/bin/`
do
if test -e $TARGET_DIR/usr/bin/$filename
then
rm $TARGET_DIR/usr/bin/$filename
fi
done
cp -d $BOARD_DIR/bin/* $TARGET_DIR/usr/bin/
