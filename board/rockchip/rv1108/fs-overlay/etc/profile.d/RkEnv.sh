#! /bin/sh
export PATH=/bin:/sbin:/usr/bin:/usr/sbin
export LD_LIBRARY_PATH=/lib/:/usr/lib/:/usr/local/lib/

mkdir /data
mount -t jffs2 /dev/mtdblock5 /data
[ $? = 0 ] && echo "/data mount /dev/mtdblock5 OK" || /bin/busybox mount -t ext4 /dev/mmcblk0p5 /data
[ $? = 0 ] && echo "/data monut /dev/mmcblk0p5 OK"