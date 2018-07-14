#!/bin/sh
TYPE=`blkid /dev/$1 | awk -F '"' '{print $6}'`

if [ "${TYPE}" == "exfat" ] ;then
	mount.exfat /dev/$1 /udisk
elif [ "${TYPE}" == "ntfs" ] ;then

	mount.ntfs-3g /dev/$1 /udisk
else
	mount /dev/$1 /udisk
fi

sync
